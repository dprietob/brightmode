#!/usr/bin/env bash

# Adjust brightness in day/night mode on multiple monitors using ddcutil
# Usage:
#   brightmode day
#   brightmode night

# Configure the brightness values for each mode
BRIGHTNESS_DAY=50
BRIGHTNESS_NIGHT=10
#--------------------

RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

if [ $# -lt 1 ]; then
    echo "Usage: brightmode <day|night>"
    exit 1
fi

if ! command -v ddcutil >/dev/null 2>&1; then
    echo -e "${RED}Error: \"ddcutil\" must be installed on the system to run brightmode!${NC}"
    exit 1
fi

if [ $1 == "day" ]; then
    BRIGHT=$BRIGHTNESS_DAY
elif [ $1 == "night" ]; then
    BRIGHT=$BRIGHTNESS_NIGHT
else
    echo -e "${RED}Error: mode \"$1\" is not allowed! Options: \"day\" or \"night\"${NC}"
    exit 1
fi

DISPLAYS=$(ddcutil detect | grep "Display" | wc -l)

if [ "$DISPLAYS" -eq 0 ]; then
    echo -e "${RED}Error: no monitors compatible with DDC/CI were detected!${NC}"
    exit 1
fi

for i in $(seq 1 $DISPLAYS); do
    echo -e "${YELLOW}  → Adjusting monitor $i to $1 ($BRIGHT)${NC}"
    ddcutil --display $i setvcp 10 $BRIGHT
done
