#!/usr/bin/env bash
set -euo pipefail

# Simple Nix/Home Manager smoke test for this dotfiles setup.
# Usage:
#   ./scripts/nix-smoke-test.sh
#   ./scripts/nix-smoke-test.sh <flake-ref>
# Examples:
#   ./scripts/nix-smoke-test.sh
#   ./scripts/nix-smoke-test.sh .#al3rez
#   ./scripts/nix-smoke-test.sh ~/dotfiles#al3rez

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
FLAKE="${1:-$REPO_ROOT#al3rez}"

ok()   { printf "\033[32m[OK]\033[0m %s\n" "$*"; }
warn() { printf "\033[33m[WARN]\033[0m %s\n" "$*"; }
err()  { printf "\033[31m[ERR]\033[0m %s\n" "$*"; }

if [ "$FLAKE" = "]" ] || [ "$FLAKE" = "[" ]; then
  warn "Ignoring invalid flake argument '$FLAKE' and using default"
  FLAKE="$REPO_ROOT#al3rez"
fi

if [[ "$FLAKE" == *"#"* ]]; then
  FLAKE_BASE="${FLAKE%%#*}"
  HM_NAME="${FLAKE##*#}"
else
  FLAKE_BASE="$FLAKE"
  HM_NAME="al3rez"
fi
BUILD_TARGET="${FLAKE_BASE}#homeConfigurations.${HM_NAME}.activationPackage"

FAILS=0

check_cmd() {
  local cmd="$1"
  if command -v "$cmd" >/dev/null 2>&1; then
    local path
    path="$(command -v "$cmd")"
    ok "$cmd exists at $path"
  else
    err "$cmd not found"
    FAILS=$((FAILS + 1))
  fi
}

check_path_exists() {
  local p="$1"
  if [ -e "$p" ]; then
    ok "$p exists"
  else
    err "$p missing"
    FAILS=$((FAILS + 1))
  fi
}

check_symlink_or_same() {
  local p="$1"
  if [ -L "$p" ]; then
    ok "$p is symlinked ($(readlink "$p"))"
  elif [ -e "$p" ]; then
    warn "$p exists but is not a symlink (can still be fine if identical)"
  else
    err "$p missing"
    FAILS=$((FAILS + 1))
  fi
}

check_dir_managed_by_hm() {
  local d="$1"
  if [ ! -d "$d" ]; then
    err "$d missing"
    FAILS=$((FAILS + 1))
    return
  fi

  # Home Manager with recursive dirs often keeps the directory real,
  # while files inside are symlinks to /nix/store/...home-manager-files.
  local hm_links
  hm_links=$(find "$d" -type l -exec readlink {} \; 2>/dev/null | grep -c 'home-manager-files' || true)

  if [ "$hm_links" -gt 0 ]; then
    ok "$d is HM-managed ($hm_links symlinked entries inside)"
  elif [ -L "$d" ]; then
    ok "$d is symlinked ($(readlink "$d"))"
  else
    warn "$d exists but no HM symlinks detected inside"
  fi
}

echo "== Nix/Home Manager smoke test =="
echo "Flake: $FLAKE"
echo "Build target: $BUILD_TARGET"
echo

# 1) Make sure flake can evaluate/build activation package
if nix build "$BUILD_TARGET" --no-link; then
  ok "flake activation package builds"
else
  err "flake activation package build failed (see error above)"
  FAILS=$((FAILS + 1))
fi

# 2) Core binaries
for b in kitty tmux nvim Hyprland walker swaybg wl-copy; do
  check_cmd "$b"
done

# 3) Managed config files
check_symlink_or_same "$HOME/.tmux.conf"
check_symlink_or_same "$HOME/.config/kitty/kitty.conf"
check_dir_managed_by_hm "$HOME/.config/nvim"
check_dir_managed_by_hm "$HOME/.config/hypr"
check_dir_managed_by_hm "$HOME/.config/walker"

# 4) Wallpaper files
check_path_exists "$HOME/Pictures/13-Ventura-Light.jpg"
check_path_exists "$HOME/Pictures/13-Ventura-Dark.jpg"

echo
if [ "$FAILS" -eq 0 ]; then
  ok "All checks passed"
  exit 0
else
  err "$FAILS check(s) failed"
  exit 1
fi
