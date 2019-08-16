local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")

-- TODO add volume icon
local volume = wibox.widget {
    {
        id = 'bar',
        max_value     = 100,
        value         = 50,
        forced_height = 20,
        forced_width  = 100,
        paddings      = 1,
        border_width  = 1,
        shape = gears.shape.rounded_bar,
        bar_shape = gears.shape.rounded_bar,
        border_color  = beautiful.border_color,
        color         = beautiful.bg_focus,
        background_color = beautiful.bg_normal,
        widget        = wibox.widget.progressbar,
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
    awful.spawn.easy_async_with_shell("ponymix get-volume", function(stdout)
        -- TODO text concatenation
        volume.textbox.text = stdout
        volume.bar:set_value(tonumber(stdout))
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
        volume.textbox.text = "Muted"
        volume.bar:set_value(tonumber(stdout))
    end
end

update_volume()

-- TODO how to run update_volume on creation (below doesn't work)
--return setmetatable(volume, { __call = function(_, ...) return update_volume() end})
return volume
