#!/usr/bin/env bash
set -euo pipefail

schema="org.gnome.desktop.interface"
scheme="$(gsettings get "$schema" color-scheme | tr -d "'")"
script_path="$(readlink -f -- "${BASH_SOURCE[0]}")"
script_dir="$(cd -- "$(dirname -- "$script_path")" && pwd)"

case "$scheme" in
  prefer-dark)
    css="style-dark.css"
    ;;
  prefer-light)
    css="style-light.css"
    ;;
  default)
    theme="$(gsettings get "$schema" gtk-theme | tr -d "'")"
    if [[ "$theme" == *-dark || "$theme" == *-Dark ]]; then
      css="style-dark.css"
    else
      css="style-light.css"
    fi
    ;;
  *)
    css="style-dark.css"
    ;;
esac

cp "$script_dir/$css" "$script_dir/style.css"
echo "color-scheme: $scheme"
echo "css: $css -> style.css"
