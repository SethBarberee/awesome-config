-- Standard awesome library
local gears = require("gears")
local timer = require("gears.timer")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
local vicious = require("vicious")
local lain = require("lain")
local markup = lain.util.markup
local separators = lain.util.separators
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup").widget
local radical = require("radical")
-- Revelation library
local revelation = require("revelation")
-- Alt tab preview
local cyclefocus = require("cyclefocus")
-- Utilites lua for useful functions
local utilities = require("utilities")
-- Common library
local common = require("awful.widget.common")
-- Enable VIM help for hotkeys widget when client with matching name is opened:
require("awful.hotkeys_popup.keys.vim")

local config_path = awful.util.get_configuration_dir()

dofile(config_path .. "error-handling.lua")

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init(config_path.. "themes/algae/theme.lua")
revelation.init({charorder = "1234567890jkluiopyhnmfdsatgvcewqzx"})

-- Wallpapers: [1] = morning, [2] = daytime, [3] = evening, [4] = night
wallpapers = {
    config_path.."themes/algae/wallpapers/morning.jpg",
    config_path.."themes/algae/wallpapers/day.png",
    config_path.."themes/algae/wallpapers/evening.jpg",
    config_path.."themes/algae/wallpapers/night.jpg"
}




-- This is used later as the default terminal and editor to run.
terminal = "urxvt"
editor = os.getenv("EDITOR") or "nvim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod1"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
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
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}
-- }}}

-- {{{ Helper functions
local function client_menu_toggle_fn()
    local instance = nil

    return function ()
        if instance and instance.wibox.visible then
            instance:hide()
            instance = nil
        else
            instance = awful.menu.clients({ theme = { width = 250 } })
        end
    end
end
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
   { "hotkeys", function() return false, hotkeys_popup.show_help end},
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end}
}

myappmenu = {
   { "Spotify", "spotify"},
   { "Discord", "discord"},
   { "Osu!",	"osu-lazer"},
   { "Chromium", "chromium"}
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
								    { "Applications", myappmenu},
                                    { "Terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
menubar.menu_gen.all_menu_dirs = { "/usr/share/applications", ".local/share/applications" }
--- }}}

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- Create a textclock widget
local calendaricon = wibox.widget.imagebox(beautiful.calendar_icon)
local mytextclock = wibox.widget.textclock("<span foreground=\"white\"> %m.%d.%y %H:%M </span>")
mytextclock.font="Monospace 10"

local calendar = lain.widget.calendar({
	cal = "/usr/bin/env TERM=linux /usr/bin/cal --color=always",
	followtag = true,
	attach_to = {mytextclock},
	notification_preset={
	  font = beautiful.taglist_font,
	  fg = beautiful.fg_normal,
	  bg = beautiful.bg_normal
	}

})
-- Create the cpu usage widget
local cpuicon = wibox.widget.imagebox(beautiful.cpu_icon)
local cpuwidget = lain.widget.cpu({
    settings = function()
        widget:set_markup(markup.font("Monospace 10", " " .. cpu_now.usage .. "% "))
    end

})

-- Create CPU freq widget
cpufreq = wibox.widget.textbox()
vicious.register(cpufreq, vicious.widgets.cpufreq, 
 function(widget,args)
  return string.format("%s GHz ", args[2])
 end,5,"cpu0")

-- Create CPU temp widget
local tempicon = wibox.widget.imagebox(beautiful.temp_icon)
local cputemp = lain.widget.temp({
     tempfile = "/sys/class/thermal/thermal_zone2/temp",
     settings = function()
        widget:set_markup(markup.fontfg("Monospace 10", "#ffffff", " " .. coretemp_now .. " °C "))
    end
})


local function disptemp()
    local f, infos
    local capi = {
        mouse = mouse,
        screen = screen
    }

    f = io.popen("sensors | grep Package && sensors | grep Core")
    infos = f:read("*all")
    f:close()

    showtempinfo = naughty.notify( {
        text    = infos,
        title   = "CPU Temperatures",
        timeout = 0,
        hover_timeout = 0.5,
        position = "top_right",
        margin = 8,
        height = 110,
        width = 460,
        opacity = 0.94,
        screen  = capi.mouse.screen })
end


tempicon:connect_signal('mouse::enter', function () disptemp(path) end)
tempicon:connect_signal('mouse::leave', function () naughty.destroy(showtempinfo)
 end)

-- Create redshift widget
local markup = lain.util.markup

local myredshift = wibox.widget{
    checked      = false,
    check_color  = "#EB8F8F",
    border_color = "#EB8F8F",
    border_width = 1,
    shape        = gears.shape.circle,
    widget       = wibox.widget.checkbox
}

local myredshift_text = wibox.widget{
    align  = "center",
    widget = wibox.widget.textbox,
}

local myredshift_stack = wibox.widget{
    myredshift,
    myredshift_text,
    layout = wibox.layout.stack
}

lain.widget.contrib.redshift:attach(
    myredshift,
    function (active)
        if active then
            myredshift_text:set_markup(markup(beautiful.bg_normal, "<b>R</b>"))
        else
            myredshift_text:set_markup(markup(beautiful.fg_normal, "R"))
        end
        myredshift.checked = active
    end
)

-- Create the package widget
local pkgicon = wibox.widget.imagebox(beautiful.pkg_icon)
pkgwidget = wibox.widget.textbox()
vicious.cache(vicious.widgets.pkg)
vicious.register(pkgwidget, vicious.widgets.pkg, '$1 Updates ', 15, "Arch C")

-- Seperator
local arrow = separators.arrow_left
local first = wibox.widget.textbox('<span font="Monospace 10"> </span>')
local arrl_dl = separators.arrow_left("alpha", "alpha")
local arrl_ld = separators.arrow_left("alpha", beautiful.bg_focus)
local arrl_right = separators.arrow_right(beautiful.bg_focus,"alpha")

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
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
	awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

local tasklist_buttons = gears.table.join(
    awful.button({ }, 1, function (c)
        if c == client.focus then
				c.minimized = true
        else
				-- Without this, the following
				-- :isvisible() makes no sense
                c.minimized = false
				
				if not c:isvisible() and c.first_tag then
						c.first_tag:view_only()
				end
				-- This will also un-minimize
                -- the client, if needed
                client.focus = c
                c:raise()
        end
    end),
    awful.button({ }, 3, client_menu_toggle_fn()),
	awful.button({ }, 4, function ()
		awful.client.focus.byidx(1)
    end),
    awful.button({ }, 5, function ()
        awful.client.focus.byidx(-1)
    end))

local function set_wallpaper(s)
    local hr = tonumber(string.sub(os.date("%R"), 1, 2))
    if hr >= 0 and hr <= 5 then --night
        gears.wallpaper.maximized(wallpapers[4], s, true)
		awful.spawn.with_shell("wal/wal -n -q -i" .. wallpapers[4])
    elseif hr >= 6 and hr <= 10 then -- morning
        gears.wallpaper.maximized(wallpapers[1], s, true)
		awful.spawn.with_shell("wal/wal -x -n -q -i" .. wallpapers[1])
    elseif hr >= 11 and hr <= 15 then -- day
        gears.wallpaper.maximized(wallpapers[2], s, true)
		awful.spawn.with_shell("wal/wal -x -n -q -i" .. wallpapers[2])
    elseif hr >= 16 and hr <= 18 then -- evening
        gears.wallpaper.maximized(wallpapers[3], s, true)
		awful.spawn.with_shell("wal/wal -x -n -q -i" .. wallpapers[3])
    elseif hr >= 19 and hr <= 23 then -- night
        gears.wallpaper.maximized(wallpapers[4], s, true)
		awful.spawn.with_shell("wal/wal -n -q -i" .. wallpapers[4])
    end
end

--local function set_wallpaper(s)
    -- Wallpaper
 --   if beautiful.wallpaper then
--        local wallpaper = beautiful.wallpaper
--        -- If wallpaper is a function, call it with the screen
--        if type(wallpaper) == "function" then
--            wallpaper = wallpaper(s)
--        end
--        gears.wallpaper.maximized(wallpaper, s, true)
--    end
--end
local wlpr_timer = timer({timeout = 60})
wlpr_timer:connect_signal("timeout", function() set_wallpaper(1) end)
wlpr_timer:start()

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    awful.tag({ "I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX" }, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons)

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "bottom", screen = s })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
        layout = wibox.layout.fixed.horizontal,
        mylauncher,
        s.mytaglist,
		first,
		arrl_ld,
		s.mylayoutbox,
		arrl_right,
        s.mypromptbox,
		first,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
        layout = wibox.layout.fixed.horizontal,
        mykeyboardlayout,
		first,
		arrow("alpha","#ff0000"),
		wibox.container.background(wibox.container.margin(wibox.widget {myredshift_stack, layout = wibox.layout.align.horizontal }, 3, 4), "#ff0000"),
		arrow("#ff0000","#FF79C6"),
		wibox.container.background(wibox.container.margin(wibox.widget {pkgicon, pkgwidget, layout = wibox.layout.align.horizontal }, 3, 4), "#FF79C6"),
	    arrow("#FF79C6","#777E76"),
		wibox.container.background(wibox.container.margin(wibox.widget {cpuicon, cpufreq, layout = wibox.layout.align.horizontal }, 3, 4), "#777E76"),
		arrow("#777E76", "#4B696D"),
        wibox.container.background(wibox.container.margin(wibox.widget {cpuicon, cpuwidget.widget, layout = wibox.layout.align.horizontal }, 3, 4), "#4B696D"),
	    arrow("#4B696D", "#4B3B51"),
		wibox.container.background(wibox.container.margin(wibox.widget {tempicon, cputemp.widget, layout = wibox.layout.align.horizontal }, 3, 4), "#4B3B51"),
	    arrow("#4B3B51",beautiful.bg_urgent),
		wibox.container.background(wibox.container.margin(wibox.widget {calendaricon, mytextclock, layout = wibox.layout.align.horizontal }, 3, 4), beautiful.bg_urgent),
        wibox.widget.systray(),
        },
    }
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),
    awful.key({ modkey,		 }, "e", revelation,
              {description = "Toggle Revelation", group="plugins"}),
    awful.key({}, "XF86AudioPlay", function() awful.spawn.with_shell("playerctl play-pause") end,
		      {description = "Toggle Music Player", group="media"}),
	awful.key({}, "XF86AudioPrev", function() awful.spawn.with_shell("playerctl previous") end,
	          {description = "Go to Previous Song", group="media"}),
	awful.key({}, "XF86AudioNext", function() awful.spawn.with_shell("playerctl next") end,
	          {description = "Go to Next Song", group="media"}),
	awful.key({}, "XF86AudioStop", function() awful.spawn.with_shell("playerctl stop") end,
	          {description = "Stop Music", group="media"}),
	awful.key({}, "XF86AudioMute", function() awful.spawn.with_shell("ponymix toggle") end,
	          {description = "Toggle Mute", group="media"}),
    awful.key({}, "XF86AudioRaiseVolume", function() awful.spawn.with_shell("ponymix increase 10") end,
              {description = "Increase Volume", group="media"}),
    awful.key({}, "XF86AudioLowerVolume", function() awful.spawn.with_shell("ponymix decrease 10") end,                {description = "Decrease Volume", group="media"}),                                         

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end,
              {description = "show main menu", group = "awesome"}),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "jump to urgent client", group = "client"}),
    -- Standard program
    awful.key({ modkey, "Shift" }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Shift" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),

    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                      client.focus = c
                      c:raise()
                  end
              end,
              {description = "restore minimized", group = "client"}),

    -- Prompt
    awful.key({ modkey },            "r",     function () awful.screen.focused().mypromptbox:run() end,
              {description = "run prompt", group = "launcher"}),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"}),
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end,
              {description = "show the menubar", group = "launcher"}),
    awful.key({ modkey, "Shift" }, "p", function() awful.spawn("rofi -show run") end, 
	          {description = "show rofi", group = "launcher"})
)

clientkeys = gears.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "(un)maximize", group = "client"}),
    awful.key({ modkey, "Control" }, "m",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        {description = "(un)maximize vertically", group = "client"}),
    awful.key({ modkey, "Shift"   }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        {description = "(un)maximize horizontally", group = "client"}),
-- modkey+Tab: cycle through all clients.
    awful.key({ modkey }, "Tab", function(c)
        cyclefocus.cycle({modifier="Super_L"})
    end,
              {description = "Client Switcher", group = "plugins"}),
-- modkey+Shift+Tab: backwards
    awful.key({ modkey, "Shift" }, "Tab", function(c)
        cyclefocus.cycle({modifier="Super_L"})
    end,
               {description = "Client Switcher in reverse", group = "plugins"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "copyq",  -- Includes session name in class.
        },
        class = {
          "Arandr",
          "Gpick",
          "Sxiv",
          "Wpa_gui",
          "pinentry",
          "xtightvncviewer"},

        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = true }
    },

    -- Set Chromium to always map on the tag named "II" on screen 1
    { rule = { class = "Chromium" },
    properties = { screen = 1, tag = "II", floating = false } },

	-- Set Spotify to always map on the tag named "II" on screen 2
	{ rule = { class = "Spotify" },
	properties = { screen = 1, tag = "III"} },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

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
            client.focus = c
            c:raise()
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            client.focus = c
            c:raise()
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
utilities.run_once("ckb",nil)
utilities.run_once("thunar --daemon")
utilities.run_once("light-locker")
-- }}}
