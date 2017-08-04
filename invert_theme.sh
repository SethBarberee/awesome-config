#!/bin/bash

if (($1 == 1)); then
    cp rc.lua rc.lua.bak && cp rc.lua.greenblack rc.lua
elif (($1 == 2)); then
    cp rc.lua rc.lua.greenblack && cp rc.lua.bak rc.lua
else
    echo "Usage: ./invert_theme.sh [argument]"
    echo "1 - to invert"
    echo "2 - to revert to normal"
    exit 1
fi
