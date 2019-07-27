local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")

-- TODO add volume icon
local volume = wibox.widget {
    text = "50",
    halign = 'center',
    valign = 'center',
    widget  = wibox.widget.textbox
}

local muted = false -- Keep track of mute

local function update_volume()
    awful.spawn.easy_async_with_shell("ponymix get-volume", function(stdout)
        -- TODO text concatenation
        volume.text = stdout
    end)
end

function volume.raise_volume()
    awful.spawn.with_shell("ponymix increase 10")
    update_volume()
end

function volume.lower_volume()
    awful.spawn.with_shell("ponymix decrease 10") 
    update_volume()
end

function volume.mute()
    awful.spawn.with_shell("ponymix toggle")
    if muted then
        muted = false
        update_volume()
    else 
        muted = true
        volume.text = "Muted"
    end
end

-- TODO how to run update_volume on creation
return volume
