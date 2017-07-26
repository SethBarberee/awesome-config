---------------------------
-- Algae awesome theme --
---------------------------

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local gears = require("gears")
local dpi = xresources.apply_dpi

local gfs = require("gears.filesystem")
local algae_path = os.getenv("HOME") .. "/.config/awesome/themes/algae/"
local themes_dir = os.getenv("HOME") .. "/.config/awesome/themes/"

local theme = {}

theme.font          = "xft: Font Awesome 9"

theme.bg_normal     = "#282A36"
theme.bg_focus      = "#50FA7B"
theme.bg_urgent     = "#ff0000"
theme.bg_minimize   = "#444444"
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = "#F8F8F8"
theme.fg_focus      = "#000000"
theme.fg_urgent     = "#ffffff"
theme.fg_minimize   = "#ffffff"

theme.useless_gap   = dpi(5)
theme.border_width  = dpi(3)
theme.border_normal = "#000000"
theme.border_focus  = "#50FA7B"
theme.border_marked = "#91231c"

theme.tooltip_border_color = theme.border_normal
theme.tooltip_bg = theme.bg_normal
theme.tooltip_fg = theme.fg_normal

theme.hotkeys_bg = theme.bg_normal
theme.hotkeys_fg = theme.fg_normal
theme.hotkeys_border_color = theme.border_focus

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]
-- Example:
--theme.taglist_bg_focus = "#ff0000"

-- Generate taglist squares:
--theme.taglist_squares_sel = theme_path .. "taglist/squarefw.png"
--theme.taglist_squares_unsel = theme_path .. "taglist/squarew.png"


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

-- Define the image to load
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

-- You can use your own layout icons like this:
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

-- Icons
theme.calendar_icon = algae_path .. "icons/calendar.png"
theme.cpu_icon = algae_path .. "icons/cpu.png"
theme.temp_icon = algae_path .. "icons/temp.png"
theme.pkg_icon = algae_path .. "icons/pacman.png"
theme.vol_icon = algae_path .. "icons/volume.png"


-- Wallpaper
theme.wallpaper = algae_path .. "background.png"


-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(
    theme.menu_height, theme.bg_focus, theme.fg_focus
)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
