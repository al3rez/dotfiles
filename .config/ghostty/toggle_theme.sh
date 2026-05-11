#!/usr/bin/env bash
set -euo pipefail

schema="org.gnome.desktop.interface"
key="color-scheme"
current="$(gsettings get "$schema" "$key" | tr -d "'")"
script_path="$(readlink -f -- "${BASH_SOURCE[0]}")"
script_dir="$(cd -- "$(dirname -- "$script_path")" && pwd)"

case "$current" in
  prefer-dark)
    next="prefer-light"
    ;;
  prefer-light)
    next="prefer-dark"
    ;;
  default)
    theme="$(gsettings get "$schema" gtk-theme | tr -d "'")"
    if [[ "$theme" == *-dark || "$theme" == *-Dark ]]; then
      next="prefer-light"
    else
      next="prefer-dark"
    fi
    ;;
  *)
    next="prefer-dark"
    ;;
esac

gsettings set "$schema" "$key" "$next"

case "$next" in
  prefer-dark)
    css="style-dark.css"
    ;;
  prefer-light)
    css="style-light.css"
    ;;
  *)
    css="style-dark.css"
    ;;
esac

cp "$script_dir/$css" "$script_dir/style.css"
echo "color-scheme: $current -> $next"
echo "css: $css -> style.css"
