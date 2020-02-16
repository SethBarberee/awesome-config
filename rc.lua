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
local battery = require("awesome-upower-battery")
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
local tagadder = require("tagadder") -- tag manipulation widget
local laptop = require("utils.laptop")
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init(gears.filesystem.get_configuration_dir() .. "themes/windows/theme.lua")

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
   { "manual", terminal .. " -e man awesome" },
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
volume = require("volume-widget") -- custom volume widget
brightness = require("brightness-widget") -- custom volume widget

-- Create battery widget
-- TODO Add icon
local bat = battery (
    {
        settings = function()
            if bat_now.status == "Discharging" then
                widget:set_markup(string.format("%3d", bat_now.perc) .. "% ")
                return
            end
            -- We must be on AC
            --baticon:set_image(beautiful.ac)
            widget:set_markup(bat_now.status .. " " .. bat_now.time .. " ")
        end
    }
    )

screen.connect_signal("request::wallpaper", function(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end)

screen_table = {} -- table of all my monitors

screen.connect_signal("request::desktop_decoration", function(s)

    -- Set up the table for each monitor
    local index = s.index
    screen_table[index] = {}
    local si = screen_table[index]

    -- Each screen has its own tag table.
    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[2])

    -- Create a textclock widget
    s.mytextclock = wibox.widget.textclock()
    s.month_calendar = awful.widget.calendar_popup.month()
    s.month_calendar:attach( s.mytextclock, "tr" )

    -- Create a wibox for each screen and add it
    local taglist_buttons = {
        awful.button({ }, 1, function(t) t:view_only() end),
        awful.button({ modkey }, 1, function(t)
            if client.focus then
                client.focus:move_to_tag(t)
            end
        end),
        awful.button({ }, 3, awful.tag.viewtoggle),
        awful.button({ modkey }, 3, function(t)
            if client.focus then
                client.focus:toggle_tag(t)
            end
        end),
        awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
        awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end),
    }

    -- Create a taglist widget
    si.taglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons,
        widget_template = {
          {
            {
              {
                {
                  {
                    id = "text_role",
                    widget = wibox.widget.textbox
                  },
                  layout = wibox.layout.fixed.horizontal
                },
                left = 2,
                right = 2,
                widget = wibox.container.margin
              },
              id = "background_role",
              widget = wibox.container.background
            },
            bottom = 2,
            color = beautiful.bg_normal,
            widget = wibox.container.margin,
            id = "current_tag"
          },
          left = 3,
          right = 3,
          layout = wibox.container.margin,
          create_callback = function(self, t, index, objects)
            local col = t.selected and beautiful.border_focus or beautiful.bg_normal
            local current_tag = self:get_children_by_id("current_tag")[1]

            current_tag.color = col

            t:connect_signal("property::urgent", function()
                current_tag.color = beautiful.fg_urgent
              end
            )
          end,
          update_callback = function(self, t, index, objects)
            local col = t.selected and beautiful.border_focus or beautiful.bg_normal
            self:get_children_by_id("current_tag")[1].color = col
          end
      }
    }

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox {
        screen = s,
        buttons = {
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end),
        }
    }
    -- Create all my widget layouts for my top wibar
    local left_layout = wibox.layout
    {
        layout = wibox.layout.fixed.horizontal,
        mylauncher,
        si.taglist,
        tagadder, -- TODO multi-monitor magic
        s.mypromptbox,
    }
    local right_layout = wibox.layout {
        layout = wibox.layout.fixed.horizontal
    }
    if laptop.data.islaptop then
        right_layout:add(brightness)
    end
    right_layout:add(volume)
    if laptop.data.islaptop then
        right_layout:add(bat.widget)
    end
    right_layout:add(s.mylayoutbox)

    -- Create the wibars
    si.mywibox = awful.wibar({
        position = "top",
        screen = s,
        bg = "transparent",
        fg = beautiful.wibar_fg or "#ffffff",
        type = 'dock'
    })
    --- {{{ Top wibar layout/setup
    -- Add widgets to the wibox
    si.mywibox.widget = {
        -- Taken from https://www.reddit.com/r/unixporn/comments/c5sc6b/awesome_nebula_blaze
        layout = wibox.layout.manual,
        { -- Left widget space setup
            point = { x = 0, y = 0 },
            forced_width = s.geometry.width/2 - 70,
            forced_height = 50,
            widget = wibox.container.background,
            -- bg = "#33ff8800",
            {
                layout = wibox.layout.fixed.horizontal,
                {
                    widget = wibox.container.margin,
                    top = 3,
                    bottom = 3,
                    left = 5,
                    left_layout,
                }
            },
        },
        { -- Middle widget space setup
            point = { x = s.geometry.width/2 - 70, y = 0 },
            forced_width = 140,
            forced_height = 50,
            widget = wibox.container.background,
            -- bg = "#ff008800",
            {
                top = 3,
                widget = wibox.container.margin,
                {
                    widget = wibox.container.place,
                    {
                        layout = wibox.layout.fixed.horizontal,
                        s.mytextclock,
                    },
                },
            },
        },
        { -- Right widget space setup
            point = { x = s.geometry.width/2 + 70, y = 0 },
            forced_width = s.geometry.width/2 - 70,
            forced_height = 50,
            widget = wibox.container.background,
            -- bg = "#00880000",
            {
                widget = wibox.container.margin,
                top = 3,
                bottom  = 3,
                right = 5,
                {
                    widget = wibox.container.place,
                    halign = "right",
                    right_layout,
                },
            },
        },
    }
    --- }}}
end)
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

-- {{{ Titlebar Setup
-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = {
        awful.button({ }, 1, function()
            c:activate { context = "titlebar", action = "mouse_move"  }
        end),
        awful.button({ }, 3, function()
            c:activate { context = "titlebar", action = "mouse_resize"}
        end),
    }

    awful.titlebar(c, {position = "left"}): setup {
        { -- Right
            awful.titlebar.widget.closebutton    (c),
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.minimizebutton(c),
            --awful.titlebar.widget.stickybutton   (c),
            --awful.titlebar.widget.ontopbutton    (c),
            layout = wibox.layout.fixed.vertical()
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c),
                visible = false
            },
            buttons = buttons,
            layout  = wibox.layout.flex.vertical
        },
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.vertical
        },
        layout = wibox.layout.align.vertical
    }
end)
--- }}}

--- {{{ Include files 
dofile(gears.filesystem.get_configuration_dir() .. "tag_notify.lua")
require("tabber")
require("rules")
require("keybindings")
require("mousebindings")
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
