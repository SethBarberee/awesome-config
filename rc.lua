-- Standard awesome library
local gears = require("gears")
local timer = require("gears.timer")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
-- Revelation library
local revelation = require("revelation")
-- Alt tab preview
local cyclefocus = require("cyclefocus")
cyclefocus.debug_use_naughty_notify = 0
-- Utilites lua for useful functions
local global = require("global")
local bindings = require("bindings")
local rules = require("rules")
-- Common library
local common = require("awful.widget.common")

local config_path = awful.util.get_configuration_dir()

-- Add the custom tags manually
dofile(config_path .. "/util/tag.lua")

-- {{{ Theme checks
-- Ensure theme is a valid theme, if not default to algae theme
if awful.util.checkfile(config_path .. "themes/" .. global.theme .. "/theme.lua") then
    beautiful.init(config_path.. "themes/".. global.theme .. "/theme.lua")
else
    beautiful.init(config_path.. "themes/algae/theme.lua")
end
revelation.init({charorder = "1234567890jkluiopyhnmfdsatgvcewqzx"})
-- }}}



-- Notifications
naughty.config.defaults['icon_size'] = beautiful.notification_icon_size or 128


-- Menubar configuration
menubar.utils.terminal = global.terminal -- Set the terminal for applications that require it
menubar.menu_gen.all_menu_dirs = { "/usr/share/applications", ".local/share/applications" }
--- }}}

-- {{{ Wibar

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        else
            gears.wallpaper.maximized(wallpaper, s, true)
        end
    end
end

local wlpr_timer = timer({timeout = 60})
wlpr_timer:connect_signal("timeout", function() set_wallpaper(1) end)
wlpr_timer:start()

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)
    beautiful.at_screen_connect(s)
end)
-- }}}


-- Set keys
root.keys(bindings.keyboard.global)
root.buttons(bindings.mouse.global)

awful.rules.rules = rules

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end
    c.shape = gears.shape.rounded_rect -- round all the shapes!!
    if awesome.startup and
      not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
        and awful.client.focus.filter(c) then
        client.focus = c
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- {{{ Autostart section
--util.utilities.run_once("ckb")
--util.utilities.run_once("radeon-profile")
--util.utilities.run_once("thunar --daemon")
--util.utilities.run_once("light-locker")
-- }}}
