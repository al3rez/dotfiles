#!/bin/bash
DAY=~/Pictures/13-Ventura-Light.jpg
NIGHT=~/Pictures/13-Ventura-Dark.jpg

while true; do
    hour=$(date +%H)
    if [ "$hour" -ge 7 ] && [ "$hour" -lt 19 ]; then
        wall=$DAY
    else
        wall=$NIGHT
    fi
    pkill swaybg
    swaybg -i "$wall" -m fill &
    sleep 3600
done
