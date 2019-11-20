local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")

client_popup = {}

screen.connect_signal("request::desktop_decoration", function(s)
    local si = s.index
    client_popup[si] = awful.popup { widget = awful.widget.tasklist {
            screen   = s, -- TODO see if this change is better
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
        screen       = s,
        shape        = gears.shape.rounded_rect
    }
end)

local function start_key()
    if #mouse.screen.clients > 1 then -- only do this for when we have more than 1 client
        awful.client.focus.history.disable_tracking()
        local s = mouse.screen.index
        client_popup[s].visible = true
    end
end

local function stop_key()
    if #mouse.screen.clients > 1 then -- only do this when we have more than 1 client
        awful.client.focus.history.enable_tracking()
        local s = mouse.screen.index
        client_popup[s].visible = false
    end
end

awful.keygrabber {
        keybindings = {
            awful.key {
                modifiers = {'Mod4'}, 
                key = 'Tab', 
                on_press = function() 
                    awful.client.focus.byidx(1)
                end,
                description = "Forward focus w/ tabber",
                group = "client"
            },
            awful.key {
                modifiers = {'Mod4', 'Shift'}, 
                key = 'Tab', 
                on_press = function() 
                    awful.client.focus.byidx(-1)
                end,
                description = "Reverse focus w/ tabber",
                group = "client"
            }
        },
    -- Note that it is using the key name and not the modifier name.
    stop_key           = 'Mod4',
    stop_event         = 'release',
    start_callback     = start_key,
    stop_callback      = stop_key,
    export_keybindings = true,
}
