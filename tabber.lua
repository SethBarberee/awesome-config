local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")

local client_popup = awful.popup {
    widget = awful.widget.tasklist {
        screen   = awful.screen.focused(),
        filter   = awful.widget.tasklist.filter.currenttags,
        buttons  = tasklist_buttons,
        style    = {
            shape = gears.shape.rounded_rect,
        },
        layout   = {
            spacing = 5,
            forced_num_rows = 1, -- wanna mirror windows
            layout = wibox.layout.grid.horizontal
        },
        widget_template = {
            {
                {
                    id     = 'clienticon',
                    widget = awful.widget.clienticon,
                },
                margins = 4,
                widget  = wibox.container.margin,
            },
            id              = 'background_role',
            forced_width    = 48,
            forced_height   = 48,
            widget          = wibox.container.background,
            create_callback = function(self, c, index, objects) --luacheck: no unused
                self:get_children_by_id('clienticon')[1].client = c
            end,
        },
    },
    border_color = beautiful.border_focus,
    border_width = 2,
    ontop        = true,
    visible      = false, -- don't show on startup
    placement    = awful.placement.centered,
    shape        = gears.shape.rounded_rect
}

local function start_key()
    -- TODO only show when we have more than 1 client
    awful.client.focus.history.disable_tracking()
    client_popup.visible = true
end

local function stop_key()
    -- TODO only show when we have more than 1 client
    awful.client.focus.history.enable_tracking()
    client_popup.visible = false
end

awful.keygrabber {
    keybindings = {
        {{'Mod4'         }, 'Tab', function() awful.client.focus.byidx(1)end},
        {{'Mod4', 'Shift'}, 'Tab', function() awful.client.focus.byidx(-1)end},
    },
    -- Note that it is using the key name and not the modifier name.
    stop_key           = 'Mod4',
    stop_event         = 'release',
    start_callback     = start_key,
    stop_callback      = stop_key,
    export_keybindings = true,
}
