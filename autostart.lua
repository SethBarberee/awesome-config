local autostart = {
    "compton --config " .. os.getenv("HOME") .. "/.config/compton/compton.conf",
    "libinput-gestures-setup start"
}
return autostart
