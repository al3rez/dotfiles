#!/usr/bin/env bash
set -euo pipefail

DAY="$HOME/Pictures/13-Ventura-Light.jpg"
NIGHT="$HOME/Pictures/13-Ventura-Dark.jpg"
CURRENT=""

while true; do
  hour=$(date +%H)
  if [ "$hour" -ge 7 ] && [ "$hour" -lt 19 ]; then
    wall="$DAY"
  else
    wall="$NIGHT"
  fi

  # Restart if wallpaper changed, or swaybg is not running.
  if [ "$wall" != "$CURRENT" ] || ! pgrep -x swaybg >/dev/null 2>&1; then
    pkill -x swaybg 2>/dev/null || true
    swaybg -i "$wall" -m fill &
    CURRENT="$wall"
  fi

  sleep 30
done
