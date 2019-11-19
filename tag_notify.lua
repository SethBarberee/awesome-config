-- Purpose of this file is to configure popups 
-- that happen on the change of the tag or layout
-- on said tag

local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local naughty = require("naughty")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

-- Base imagebox with the layout for the tag
local icon = wibox.widget {
    align = 'center',
    valign = 'center',
    image = beautiful.layout_floating,
    forced_height = dpi(180),
    forced_width = dpi(180),
    widget = wibox.widget.imagebox,
}

local text_tag = wibox.widget {
    markup = 'floating',
    align = 'center',
    valign = 'center',
    widget = wibox.widget.textbox,
}

local popup = awful.popup {
    widget = wibox.widget {
        {
            icon,
            text_tag,
            layout = wibox.layout.fixed.vertical,
        },
        margins = dpi(10),
        widget = wibox.container.margin,
    },
    x = awful.screen.focused().geometry.height / 2 + dpi(300),
    y = (awful.screen.focused().geometry.width / 2) - (dpi(1000) / 2),
    shape = gears.shape.rounded_rect,
    type = "dock",
    ontop = true,
    visible = false,
}

local timer_die = gears.timer { timeout = 1.5 }

local function show(layout_name)
    if timer_die.started then
        timer_die:again()
    else
        timer_die:start()
    end
    text_tag:set_markup(layout_name)
    icon.image = beautiful["layout_" .. layout_name]
    popup.visible = true
end

-- Destroy popup on timeout from the timer
timer_die:connect_signal("timeout", function()
    popup.visible = false
    if timer_die.started then
        timer_die:stop()
    end
end)

-- Test sending popups on tag layout change
awful.tag.attached_connect_signal(s, "property::layout", function ()
    local l = awful.layout.get(s)
    -- Revelation has two names so check for both
    local t_rev = awful.tag.find_by_name(s, "Revelation")
    local t_rev2 = awful.tag.find_by_name(s, "Revelation_zoom")
    -- account for revelation and don't send popup
    if not t_rev and not t_rev2 then
        if l then
            local name = awful.layout.getname(l)
            -- Show nice popup with layout name and icon
            show(name)
        end
    end
end)

awful.tag.attached_connect_signal(s, "property::urgent", function (t)
    naughty.notification { title = "Urgent client:", message = "Tag ".. t.index}
    local c_table = t:clients() -- get a table of all clients
    for k, v in pairs(c_table) do
        -- iterate over the table and determine what is urgent
        if v.urgent then
            naughty.notification { title = "Urgent client:", message = v.instance .. ": " .. v.name}
        end
    end
end)

tag.connect_signal("property::selected", function (t)
    if t.selected then
        -- Pad a little to visually tell it's selected
        t.name = " " .. t.name .. " "
    else
        t.name = t.name:gsub("^[ ]*",""):gsub("[ ]*$","")
    end
end)
