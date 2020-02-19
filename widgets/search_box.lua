local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

local search_text = wibox.widget.textbox()
search_text.text = 'Search'

local search_box = wibox.widget {
    {
        {
            {
                -- TODO add iconbox here
                search_text,
                layout = wibox.layout.fixed.horizontal,
            },
            left = 3,
            right = 3,
            widget = wibox.container.margin,
        },
        bg = beautiful.border_focus,
        fg = beautiful.fg_focus,
        widget = wibox.container.background,
    },
    layout = wibox.layout.fixed.horizontal,
    buttons = {
        awful.button({}, 1, function () awful.spawn('rofi -combi-modi window,drun,run -show combi -modi combi') end) 
    }
}

return search_box
