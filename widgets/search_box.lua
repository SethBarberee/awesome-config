local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local search_text = wibox.widget.textbox()
search_text.text = 'Search'

local search_image = wibox.widget {
    {
        image = beautiful.awesome_icon, -- TODO change this
        widget = wibox.widget.imagebox
    },
    margins = 10,
    widget = wibox.container.margin,
}

local search_box = wibox.widget {
    {
        {
            {
                search_image,
                search_text,
                layout = wibox.layout.fixed.horizontal,
            },
            left = dpi(10),
            right = dpi(10),
            widget = wibox.container.margin,
        },
        bg = beautiful.border_focus,
        fg = beautiful.fg_focus,
        widget = wibox.container.background,
    },
    layout = wibox.layout.fixed.horizontal,
}
-- Lets me left click to pull up rofi
search_box:buttons(awful.util.table.join(
    awful.button({}, 1, function () 
        awful.spawn('rofi -combi-modi window,drun,run -show combi -modi combi') 
    end)
    )
)

return search_box
