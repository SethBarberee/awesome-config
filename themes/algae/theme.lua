---------------------------
-- Algae awesome theme --
-- Author: Seth Barberee --
---------------------------
local theme = {}

local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local naughty = require("naughty")
local vicious = require("vicious")
local lain = require("lain")
local separators = lain.util.separators
local lain_markup = lain.util.markup
local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local os, math, string, awesome, client = os, math, string, awesome, client

local algae_path = os.getenv("HOME") .. "/.config/awesome/themes/algae/"
local themes_dir = os.getenv("HOME") .. "/.config/awesome/themes/"
local lain_icons = os.getenv("HOME") .."/.config/awesome/lain/icons/layout/default/"

local laptop = require("util.laptop")
local battery = nil

--Wallpapers: [1] = morning, [2] = daytime, [3] = evening, [4] = night
local wallpapers = {
        algae_path .. "wallpapers/morning.jpg",
        algae_path .. "wallpapers/day.jpg",
        algae_path .. "wallpapers/evening.jpg",
        algae_path .. "wallpapers/night.jpg"
}

theme.font          = "xft: Knack Nerd Font Mono 11"

-- Background Settings
theme.bg_normal     = "#282A36"
theme.bg_focus      = theme.bg_normal
theme.bg_urgent     = "#ff0000"
theme.bg_minimize   = "#444444"
theme.bg_systray    = theme.bg_normal

-- Foreground Settings
theme.fg_normal     = "#F8F8F8"
theme.fg_focus      = "#50FA7B"
theme.fg_urgent     = "#ffffff"
theme.fg_minimize   = "#ffffff"

theme.useless_gap   = dpi(4)

-- Window Border Settings
theme.border_width  = dpi(3)
theme.border_normal = "#000000"
theme.border_focus  = "#50FA7B"
theme.border_marked = "#91231c"

-- Window Tooltip Settings
theme.tooltip_border_color = theme.border_normal
theme.tooltip_bg = theme.bg_normal
theme.tooltip_fg = theme.fg_focus
theme.tooltip_shape = gears.shape.rounded_rect

-- Hotkey Settings
theme.hotkeys_bg = theme.bg_normal
theme.hotkeys_fg = theme.fg_normal
theme.hotkeys_border_color = theme.border_focus
theme.hotkeys_shape = gears.shape.rounded_rect

-- Notification Settings
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]
theme.notification_font = theme.font
theme.notification_bg = theme.bg_normal
theme.notification_fg = theme.fg_focus
theme.notification_border_color = theme.border_tooltip
theme.notification_border_width = theme.border_width
theme.notification_shape = gears.shape.rounded_rect
theme.notification_opacity = 0.94

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = themes_dir.."default/submenu.png"
theme.menu_height = dpi(16)
theme.menu_width  = dpi(130)

-- Titlebar icons
theme.titlebar_close_button_normal = themes_dir.."default/titlebar/close_normal.png"
theme.titlebar_close_button_focus  = themes_dir.."default/titlebar/close_focus.png"

theme.titlebar_minimize_button_normal = themes_dir.."default/titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus  = themes_dir.."default/titlebar/minimize_focus.png"

theme.titlebar_ontop_button_normal_inactive = themes_dir.."default/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive  = themes_dir.."default/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = themes_dir.."default/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active  = themes_dir.."default/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = themes_dir.."default/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive  = themes_dir.."default/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = themes_dir.."default/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active  = themes_dir.."default/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = themes_dir.."default/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive  = themes_dir.."default/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = themes_dir.."default/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active  = themes_dir.."default/titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = themes_dir.."default/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = themes_dir.."default/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = themes_dir.."default/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active  = themes_dir.."default/titlebar/maximized_focus_active.png"

-- Recolor titlebar icons to be more algae
theme = theme_assets.recolor_titlebar_normal(theme, theme.fg_normal)
theme = theme_assets.recolor_titlebar_focus(theme, theme.fg_focus)
theme = theme_assets.recolor_layout(theme, theme.fg_normal)

-- Tasklist Options
theme.tasklist_align = "center"
theme.tasklist_disable_icon = true
theme.tasklist_bg_focus = theme.fg_focus
theme.tasklist_fg_focus = theme.bg_normal
theme.tasklist_shape = gears.shape.rounded_rect


-- Widget specific stuff
theme.progressbar_bg = theme.bg_normal
theme.progressbar_fg = theme.fg_focus
theme.progressbar_border_color = theme.border_focus

-- Layout Icon Settings
theme.layout_fairh = themes_dir.."default/layouts/fairhw.png"
theme.layout_fairv = themes_dir.."default/layouts/fairvw.png"
theme.layout_floating  = themes_dir.."default/layouts/floatingw.png"
theme.layout_magnifier = themes_dir.."default/layouts/magnifierw.png"
theme.layout_max = themes_dir.."default/layouts/maxw.png"
theme.layout_fullscreen = themes_dir.."default/layouts/fullscreenw.png"
theme.layout_tilebottom = themes_dir.."default/layouts/tilebottomw.png"
theme.layout_tileleft   = themes_dir.."default/layouts/tileleftw.png"
theme.layout_tile = themes_dir.."default/layouts/tilew.png"
theme.layout_tiletop = themes_dir.."default/layouts/tiletopw.png"
theme.layout_spiral  = themes_dir.."default/layouts/spiralw.png"
theme.layout_dwindle = themes_dir.."default/layouts/dwindlew.png"
theme.layout_cornernw = themes_dir.."default/layouts/cornernww.png"
theme.layout_cornerne = themes_dir.."default/layouts/cornernew.png"
theme.layout_cornersw = themes_dir.."default/layouts/cornersww.png"
theme.layout_cornerse = themes_dir.."default/layouts/cornersew.png"

-- Lain Layout Icon Settings
theme.layout_termfair    = lain_icons .. "termfairw.png"
theme.layout_centerfair  = lain_icons .. "centerfairw.png"  -- termfair.center
theme.layout_cascade     = lain_icons .. "cascadew.png"
theme.layout_cascadetile = lain_icons .. "cascadetilew.png" -- cascade.tile
theme.layout_centerwork  = lain_icons .. "centerworkw.png"
theme.layout_centerhwork = lain_icons .. "centerworkhw.png" -- centerwork.horizontal

-- Icons for widgets
theme.calendar_icon = algae_path .. "icons/calendar.png"
theme.cpu_icon = algae_path .. "icons/cpu.png"
theme.temp_icon = algae_path .. "icons/temp.png"
theme.pkg_icon = algae_path .. "icons/pacman.png"
theme.vol_icon = algae_path .. "icons/volume.png"


-- Wallpaper if not using wallpaper setter
-- theme.wallpaper = algae_path .. "background.png"

-- TODO write function that condenses wal and betterlockscreen
-- Maybe with a number argument??
theme.wallpaper = function(s)
    local hr = tonumber(string.sub(os.date("%R"), 1, 2))
    if hr >= 0 and hr <= 5 then --night
        gears.wallpaper.maximized(wallpapers[4], s, true)
        awful.spawn.with_shell("~/wal/wal -n -q -i" .. wallpapers[4])
        awful.spawn.with_shell("~/betterlockscreen/betterlockscreen -u " .. wallpapers[4])
    elseif hr >= 6 and hr <= 10 then -- morning
        gears.wallpaper.maximized(wallpapers[1], s, true)
        awful.spawn.with_shell("~/wal/wal -x -n -q -i" .. wallpapers[1])
        awful.spawn.with_shell("~/betterlockscreen/betterlockscreen -u " .. wallpapers[1])
    elseif hr >= 11 and hr <= 15 then -- day
        gears.wallpaper.maximized(wallpapers[2], s, true)
        awful.spawn.with_shell("~/wal/wal -x -n -q -i" .. wallpapers[2])
        awful.spawn.with_shell("~/betterlockscreen/betterlockscreen -u " .. wallpapers[2])
    elseif hr >= 16 and hr <= 18 then -- evening
        gears.wallpaper.maximized(wallpapers[3], s, true)
        awful.spawn.with_shell("~/wal/wal -n -q -i" .. wallpapers[3])
        awful.spawn.with_shell("~/betterlockscreen/betterlockscreen -u " .. wallpapers[3])
    elseif hr >= 19 and hr <= 23 then -- night
        gears.wallpaper.maximized(wallpapers[4], s, true)
        awful.spawn.with_shell("~/wal/wal -n -q -i" .. wallpapers[4])
        awful.spawn.with_shell("~/betterlockscreen/betterlockscreen -u " .. wallpapers[4])
    end
end

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(
    theme.menu_height, theme.bg_focus, theme.fg_focus
)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = "HighContrast"


--Create the volume widget
local volicon = wibox.widget.imagebox(theme.vol_icon)

theme.volume = lain.widget.pulse {
   settings = function()
        vlevel = " " .. volume_now.left .. "% | " .. volume_now.device
        if volume_now.muted == "yes" then
            vlevel = vlevel .. " M"
        end
        widget:set_markup(lain.util.markup(theme.fg_normal, vlevel))
    end
}
-- Buttons actions for when interacting with the volume widget
theme.volume.widget:buttons(awful.util.table.join(
    awful.button({}, 1, function() -- left click
        awful.spawn("pavucontrol")
    end),
    awful.button({}, 2, function() -- middle click
        awful.spawn("ponymix set-volume 100")
        theme.volume.update()
    end),
    awful.button({}, 3, function() -- right click
        awful.spawn("ponymix toggle")
        theme.volume.update()
    end),
    awful.button({}, 4, function() -- scroll up
        awful.spawn("ponymix increase 1")
        theme.volume.update()
    end),
    awful.button({}, 5, function() -- scroll down
        awful.spawn("ponymix decrease 1")
        theme.volume.update()
    end)
))
local volume = wibox.container.background(wibox.container.margin(wibox.widget {volicon, theme.volume.widget, layout = wibox.layout.align.horizontal }, 10, 10), "#BD7533", gears.shape.rounded_rect)


-- Create the cpu usage widget
local cpuicon = wibox.widget.imagebox(theme.cpu_icon)
local cpu = lain.widget.cpu({
    settings = function()
        widget:set_markup(lain_markup.font(theme.font, " " .. cpu_now.usage .. "% "))
    end

})
local cpu_usage = wibox.container.background(wibox.container.margin(wibox.widget {cpuicon, cpu.widget, layout = wibox.layout.align.horizontal }, 10, 10), "#4B696D", gears.shape.rounded_rect)


-- Create CPU freq widget
local cpufreq = wibox.widget.textbox()
vicious.register(cpufreq, vicious.widgets.cpufreq,
 function(widget,args)
     local speed = tonumber(string.format("%3.3f",args[2]))
  return string.format("%s GHz ", speed)
 end,5,"cpu0")

local cpu_speed = wibox.container.background(wibox.container.margin(wibox.widget {cpuicon, cpufreq, layout = wibox.layout.align.horizontal }, 10, 10), "#777E76", gears.shape.rounded_rect)


-- Create CPU temp widget
local tempicon = wibox.widget.imagebox(theme.temp_icon)
local cputemp = lain.widget.temp({
     tempfile = "/sys/class/thermal/thermal_zone2/temp",
     settings = function()
        widget:set_markup(lain_markup.fontfg(theme.font, "#ffffff", " " .. coretemp_now .. " °C "))
    end
})


local function disptemp()
    local capi = {
        mouse = mouse,
        screen = screen
    }

    local f = "sensors | grep Core"
    awful.spawn.easy_async_with_shell(f, function(stdout, stderr, reason, exit_code)
        showtempinfo = naughty.notify( {
            text    = stdout,
            title   = "CPU Temperatures",
            icon    = "/usr/share/icons/HighContrast/32x32/devices/computer.png",
            timeout = 0,
            hover_timeout = 0.5,
            position = "top_right",
            margin = 8,
            height = 120,
            width = 520,
            screen  = capi.mouse.screen })
    end)
end


tempicon:connect_signal('mouse::enter', function () disptemp(path) end)
tempicon:connect_signal('mouse::leave', function () naughty.destroy(showtempinfo)end)
local cpu_temp = wibox.container.background(wibox.container.margin(wibox.widget {tempicon, cputemp.widget, layout = wibox.layout.align.horizontal }, 10, 10), "#4B3B51", gears.shape.rounded_rect)


-- Create a textclock widget
local calendaricon = wibox.widget.imagebox(theme.calendar_icon)
local mytextclock = wibox.widget.textclock("<span foreground=\"white\">  %m.%d.%y %H:%M </span>")

local calendar = lain.widget.calendar({
	cal = "/usr/bin/env TERM=linux /usr/bin/cal --color=always",
	followtag = true,
	attach_to = {mytextclock},
	notification_preset={
	  font = "Monospace 10",
          fg = theme.fg_focus,
	  bg = theme.bg_normal
	}

})
local calendar_date = wibox.container.background(wibox.container.margin(wibox.widget {calendaricon, mytextclock, layout = wibox.layout.align.horizontal }, 10, 10), theme.bg_urgent, gears.shape.rounded_rect)

-- I really don't want all this crap showing on my laptop but I do want the
-- battery module
if laptop then
    cpu_usage = nil
    cpu_speed = nil
    cpu_temp = nil
    battery = require("util.battery")
end

-- Seperator
local spacer = wibox.widget.textbox('<span font="Monospace 10">  </span>')
local spacer_small = wibox.widget.textbox(' ')

function theme.at_screen_connect(s)
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
    local layout = wibox.container.background(wibox.container.margin(wibox.widget {s.mylayoutbox, layout = wibox.layout.align.horizontal }, 10, 10), "#F99E6C", gears.shape.rounded_rect)

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.noempty, awful.util.taglist_buttons)

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, awful.util.tasklist_buttons)

    s.mywibox = awful.wibar({ position = "bottom", screen = s, shape = gears.shape.rounded_rect})
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        {
	-- Left widgets
        layout = wibox.layout.fixed.horizontal,
                mylauncher,
                s.mytaglist,
                s.mypromptbox,
		spacer_small,
        },
        s.mytasklist, -- Middle widget
        {
	-- Right widgets
        layout = wibox.layout.fixed.horizontal,
                layout,
                volume,
                cpu_usage,
                cpu_speed,
                cpu_temp,
                calendar_date,
                battery,
                wibox.widget.systray(),
        },
    }
end

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
