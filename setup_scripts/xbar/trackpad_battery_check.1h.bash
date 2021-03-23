#!/bin/bash

# ref
#   - https://mac-tegaki.com/basic-usage/check-bluetooth-battery-level.html
#   - https://orebibou.com/ja/home/201704/20170421_001/
battery_percentage=$(ioreg -r -d 1 -k BatteryPercent | egrep '("BatteryPercent"|"Product") '| tail -n1|awk -F '[^0-9]+' 'BEGIN{OFS=""}{$1=$1;print $0}')
echo "${battery_percentage}% TrackPad"
