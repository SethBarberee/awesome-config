local autostart = {
    "compton --config " .. os.getenv("HOME") .. "/.config/compton/compton.conf",
    "onboard",
    "libinput-gestures-setup start",
    "light-locker"
}
return autostart
