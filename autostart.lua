local gears = require("gears")
local laptop = require("utils.laptop") -- so we know if we are on a laptop

local autostart = {
    "blueman-manager",
    "compton --config " .. os.getenv("HOME") .. "/.config/compton/compton.conf",
    "light-locker"
}

local laptop_touch = {
    "onboard"

}

local laptop_normal = {
    "libinput-gestures-setup start"
}


if laptop.islaptop then
    gears.table.join(autostart, laptop_normal)
end

if laptop.touch then
    gears.table.join(autostart, laptop_touch)
end

return autostart
