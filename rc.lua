-- awesome_mode: api-level=4:screen=on
-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- {{{ Import Modules
-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
local revelation = require("revelation")
-- }}}

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notification {
        preset  = naughty.config.presets.critical,
        title   = "Oops, there were errors during startup!",
        message = awesome.startup_errors
    }
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notification {
            preset  = naughty.config.presets.critical,
            title   = "Oops, an error happened!",
            message = tostring(err)
        }

        in_error = false
    end)
end
-- }}}

-- {{{ User Modules
-- Waiting to now to require so I can get the startup errors
local autostart = require("autostart") -- my autostart programs
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
local theme_name = "tag_bar"
beautiful.init(gears.filesystem.get_configuration_dir() .. "themes/" .. theme_name .. "/theme.lua")

revelation.init()

-- This is used later as the default terminal and editor to run.
terminal = "kitty"
editor = os.getenv("EDITOR") or "nvim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
tag.connect_signal("request::default_layouts", function()
    awful.layout.append_default_layouts({
        awful.layout.suit.floating,
        awful.layout.suit.tile,
        awful.layout.suit.tile.left,
        awful.layout.suit.tile.bottom,
        awful.layout.suit.tile.top,
        awful.layout.suit.fair,
        awful.layout.suit.fair.horizontal,
        awful.layout.suit.spiral,
        awful.layout.suit.spiral.dwindle,
        awful.layout.suit.max,
        awful.layout.suit.max.fullscreen,
        awful.layout.suit.magnifier,
        awful.layout.suit.corner.nw,
    })
end)
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end },
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Widgets/Wibar
require("bars/" .. theme_name)
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("request::manage", function (c)

    if not awesome.startup then
        -- Set as slave instead of master
        awful.client.setslave(c)
    end

    -- Icon overrides (TODO make this better)
    -- Thanks Reddit (https://www.reddit.com/r/awesomewm/comments/b5rmeo/how_to_add_fallback_icon_to_the_tasklist)
    local t = {}
    t["Slack"] = os.getenv("HOME").."/.local/share/icons/hicolor/24x24/apps/steam_icon_287980.png"
    local icon = t[c.class]
    if not icon then
        return
    end
    icon = gears.surface(icon)
    c.icon = icon and icon._native or nil
end)
-- }}}
--- {{{ Include files 
dofile(gears.filesystem.get_configuration_dir() .. "tag_notify.lua")
require("tabber")
require("rules")
require("keybindings")
require("mousebindings")
require("notifications")
--- }}}
--- {{{ Special Focus Rules
awful.permissions.add_activate_filter(function(c)
    if c.class == "Onboard" then return false end
end)

-- From #2982
-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:activate { context = "mouse_enter", raise = false }
end)

--- }}}

--- vim: foldmethod=marker fdl=0
