local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")

-- TODO add volume icon
local volume = wibox.widget {
    {
        id = 'bar',
        maximum       = 100,
        value         = 50,
        forced_height = 20,
        forced_width  = 100,
        bar_height = 3,
        bar_active_color         = beautiful.bg_focus,
        bar_color      = beautiful.bg_normal,
        widget        = wibox.widget.slider,
    },
    {
        id = 'textbox',
        text = "50",
        halign = 'center',
        valign = 'center',
        widget  = wibox.widget.textbox
    },
    layout = wibox.layout.stack
}

local muted = false -- Keep track of mute

local function update_volume()
    awful.spawn.easy_async_with_shell("pamixer --get-mute", function(stdout)
        if string.match(stdout, 'false') then
            awful.spawn.easy_async_with_shell("pamixer --get-volume", function(stdout)
                -- TODO text concatenation
                volume.textbox.text = stdout
                --volume.bar:set_value(tonumber(stdout))
                volume.bar.value = tonumber(stdout)
            end)
            muted = false
        else 
            muted = true
            volume.textbox.text = "Muted"
            volume.bar.value = 0
        end
    end)
end

function volume.raise_volume()
    awful.spawn.with_shell("pamixer --increase 10")
    update_volume()
end

function volume.lower_volume()
    awful.spawn.with_shell("pamixer --decrease 10") 
    update_volume()
end

function volume.mute()
    awful.spawn.with_shell("pamixer --toggle-mute")
    if muted then
        muted = false
        update_volume()
    else 
        muted = true
        volume.textbox.text = "Muted"
        --volume.bar:set_value(tonumber(stdout))
        volume.bar.value = 0
    end
end

volume.bar:connect_signal('property::value', function()
    awful.spawn.easy_async_with_shell("pamixer --set-volume " .. volume.bar.value, function()
        update_volume()
    end)
end)

update_volume()

-- TODO how to run update_volume on creation (below doesn't work)
--return setmetatable(volume, { __call = function(_, ...) return update_volume() end})
return volume
