---------------------------
-- Algae awesome theme --
-- Author: Seth Barberee --
---------------------------

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local gears = require("gears")
local dpi = xresources.apply_dpi

local gfs = require("gears.filesystem")
local algae_path = os.getenv("HOME") .. "/.config/awesome/themes/algae/"
local themes_dir = os.getenv("HOME") .. "/.config/awesome/themes/"
local lain_icons = os.getenv("HOME") .."/.config/awesome/lain/icons/layout/default/"

local theme = {}

theme.font          = "xft: Hack 9"

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
theme.tooltip_fg = theme.fg_normal

-- Hotkey Settings
theme.hotkeys_bg = theme.bg_normal
theme.hotkeys_fg = theme.fg_normal
theme.hotkeys_border_color = theme.border_focus

-- Notification Settings
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]
theme.notification_font = theme.font
theme.notification_bg = theme.bg_normal
theme.notification_fg = theme.fg_urgent
theme.notification_border_color = theme.border_tooltip
theme.notification_border_width = theme.border_width
theme.notification_shape = gears.shape.rounded_rect
theme.notification_opacity = 0.94

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = themes_dir.."default/submenu.png"
theme.menu_height = dpi(15)
theme.menu_width  = dpi(100)

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
theme.layout_termfair    = lain_icons .. "termfair.png"
theme.layout_centerfair  = lain_icons .. "centerfair.png"  -- termfair.center
theme.layout_cascade     = lain_icons .. "cascade.png"
theme.layout_cascadetile = lain_icons .. "cascadetile.png" -- cascade.tile
theme.layout_centerwork  = lain_icons .. "centerwork.png"
theme.layout_centerhwork = lain_icons .. "centerworkh.png" -- centerwork.horizontal

-- Icons for widgets
theme.calendar_icon = algae_path .. "icons/calendar.png"
theme.cpu_icon = algae_path .. "icons/cpu.png"
theme.temp_icon = algae_path .. "icons/temp.png"
theme.pkg_icon = algae_path .. "icons/pacman.png"
theme.vol_icon = algae_path .. "icons/volume.png"


-- Wallpaper if not using wallpaper setter
theme.wallpaper = algae_path .. "background.png"


-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(
    theme.menu_height, theme.bg_focus, theme.fg_focus
)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = "HighContrast"

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
