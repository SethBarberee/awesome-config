-- Custom battery module written in lua
-- Author: Seth Barberee

local awful = require("awful")
local lain = require("lain")
local beautiful = require("beautiful")
local wibox = require("wibox")
local naughty = require("naughty")
local gears = require("gears")
local timer = require("gears.timer")
local io = io
local battery = {}

local capacity = 10
local batteryIndicator
local icon_path = os.getenv("HOME").. "/.config/awesome/themes/algae/icons/battery.png"

local pic = gears.color.recolor_image(icon_path, "#00ff00")

local function battery_check()
    local f = io.open("/sys/class/power_supply/BAT0/capacity","r")
    io.input(f)
    capacity = tonumber(io.read())
    if capacity < 5 then
        pic = gears.color.recolor_image(icon_path, "#ff0000")
        naughty.notify({
            icon = pic,
            title = "Battery critical!",
            text = "Less than 5% of battery remaining! Plug in the laptop to an outlet now!",
            timeout = 5
        })
    elseif capacity < 10 then
        pic = gears.color.recolor_image(icon_path, "#ffff00")
        naughty.notify({
            icon = pic,
            title = "Battery low!",
            text = "Less than 10% of battery remaining! Plug in the laptop to an outlet soon...",
            timeout = 5
        })
    end
    io.close(f)
    -- Make sure that batteryIndicator exists. If not, don't set value
    if batteryIndicator then
        batteryIndicator:set_value(capacity)
    end
end

battery_check()

batteryIndicator = wibox.widget {
        max_value = 100,
        value = capacity,
        forced_height = 20,
        forced_width = 100,
        shape = gears.shape.rounded_bar,
        border_width = 1,
        border_color = beautiful.border_color,
        widget = wibox.widget.progressbar,
}

batteryIndicator:connect_signal("mouse::enter", function ()
         options = { icon = pic, title = "Battery status:", text = "Remaining: " .. capacity .. " %",
                 timeout = 0, hover_timeout = 0.5
                }
        widget.hover = naughty.notify(options) end)
batteryIndicator:connect_signal("mouse::leave", function () naughty.destroy(widget.hover) end)

local battery_timer = timer({timeout = 120})
battery_timer:connect_signal("timeout", function() battery_check() end)
battery_timer:start()

return batteryIndicator
