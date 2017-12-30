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

local function battery_check()
    local f = io.open("/sys/class/power_supply/BAT0/capacity","r")
    io.input(f)
    capacity = tonumber(io.read())
    if capacity < 10 then
        naughty.notify({
            title = "Battery low!",
            timeout = 5
        })
    end
    io.close(f)
end

battery_check()

-- Determine color for progressbar based off of capacity
local function find_color(number)
    if number < 10 then
        return "#ff0000"
    elseif number < 50 then
        return "#ffff00"
    else
        return "#00ff00"
    end
end

batteryIndicator = wibox.widget {
        max_value = 100,
        value = capacity,
        color = find_color(capacity),
        forced_height = 20,
        forced_width = 100,
        shape = gears.shape.rounded_bar,
        border_width = 1,
        border_color = beautiful.border_color,
        widget = wibox.widget.progressbar,
}

batteryIndicator:connect_signal("mouse::enter", function ()
     options = { title = "Battery status:", text = "Remaining: " .. capacity .. " %",
                 timeout = 0, hover_timeout = 0.5
                }
     widget.hover = naughty.notify(options) end)
batteryIndicator:connect_signal("mouse::leave", function () naughty.destroy(widget.hover) end)

local battery_timer = timer({timeout = 60})
battery_timer:connect_signal("timeout", function() battery_check() batteryIndicator:emit_signal("widget::redraw_needed") end)
battery_timer:start()

return batteryIndicator
