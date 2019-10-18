local gears = require("gears")
local laptop = require("utils.laptop") -- so we know if we are on a laptop
local naughty = require("naughty")

local autostart = {
    "blueman-manager",
    "compton --config " .. os.getenv("HOME") .. "/.config/compton/compton.conf",
    "light-locker",
}

local laptop_normal = {
    "libinput-gestures-setup start",
}

local laptop_touch = {
    "onboard",
}


-- We got a laptop so add gestures
if laptop.islaptop then
    autostart = gears.table.join(autostart, laptop_normal)
end

-- It's a touch screen so we need our touch stuff
if laptop.touch then
    autostart = gears.table.join(autostart, laptop_touch)
end

return autostart
