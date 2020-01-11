local awful = require("awful")
local gears = require("gears")
local laptop = require("utils.laptop") -- so we know if we are on a laptop
local naughty = require("naughty")

local apps = {
    "blueman-manager",
    "picom --config " .. os.getenv("HOME") .. "/.config/compton/compton.conf",
    "light-locker",
}

local laptop_normal = {
    "libinput-gestures-setup start",
}

local laptop_touch = {
    "onboard",
}


local autostart = {}

-- We got a laptop so add gestures
function autostart.startup_apps()
    if laptop.data.islaptop then
        --naughty.notification { title = "DEBUG", message = "laptop normal"}
        apps = gears.table.join(apps, laptop_normal)
    end

    -- It's a touch screen so we need our touch stuff
    if laptop.data.touch then
        --naughty.notification { title = "DEBUG", message = "laptop touch"}
        apps = gears.table.join(apps, laptop_touch)
    end

    -- Spawn all the programs needed at startup
    for _,v in pairs(apps) do
        awful.spawn.once(v)
    end
end

gears.timer.delayed_call(function()
    autostart.startup_apps()
end)
return autostart
