local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local battery = require("awesome-upower-battery")
local tagadder = require("widgets.tagadder") -- tag manipulation widget
local brightness = require("widgets.brightness") -- tag manipulation widget
local volume = require("widgets.volume") -- tag manipulation widget
--local todo = require("widgets.todo") -- tag manipulation widget
local laptop = require("utils.laptop")

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

-- {{{ Widgets/Wibar
-- {{{ Battery widget
-- TODO I could do some more with a bar..
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
-- }}}
screen.connect_signal("request::desktop_decoration", function(s)

    s.mypromptbox = awful.widget.prompt()
    -- Each screen has its own tag table.
    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[2])
    -- {{{ Taglist widget
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
    s.taglist = awful.widget.taglist {
        screen  = s,
        style = {
            shape = gears.shape.rounded_bar
        },
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons,
        widget_template = {
            {
                {
                    {
                        {
                            {
                                id     = 'index_role',
                                widget = wibox.widget.textbox,
                            },
                            margins = 4,
                            widget  = wibox.container.margin,
                        },
                        bg     = '#dddddd',
                        shape  = gears.shape.circle,
                        widget = wibox.container.background,
                    },
                    {
                        {
                            id     = 'icon_role',
                            widget = wibox.widget.imagebox,
                        },
                        margins = 2,
                        widget  = wibox.container.margin,
                    },
                    {
                        id     = 'text_role',
                        widget = wibox.widget.textbox,
                    },
                    layout = wibox.layout.fixed.horizontal,
                },
                left  = 18,
                right = 18,
                widget = wibox.container.margin
            },
            id     = 'background_role',
            widget = wibox.container.background,
            -- Add support for hover colors and an index label
            -- TODO maybe add hover popup???
            create_callback = function(self, c3, index, objects) --luacheck: no unused args
                self:get_children_by_id('index_role')[1].markup = '<b> '..c3.index..' </b>'
                self:connect_signal('mouse::enter', function()
                    if self.bg ~= '#0000ff' then
                        self.backup     = self.bg
                        self.has_backup = true
                    end
                    self.bg = '#0000ff'
                end)
                self:connect_signal('mouse::leave', function()
                    if self.has_backup then self.bg = self.backup end
                end)
            end,
            update_callback = function(self, c3, index, objects) --luacheck: no unused args
                self:get_children_by_id('index_role')[1].markup = '<b> '..c3.index..' </b>'
            end,
        }, 
    }
    -- }}}
    -- {{{ Layoutbox widget 
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

    s.clock = wibox.widget.textclock()
    s.month_calendar = awful.widget.calendar_popup.month()
    s.month_calendar:attach( s.clock, "br" )
    -- }}}
    -- {{{ Wibar creation
    -- Create the wibars
    s.mywibox = awful.wibar({
        position = "bottom",
        screen = s,
        bg = "transparent",
        fg = beautiful.wibar_fg or "#ffffff",
        type = 'dock'
    })
    -- }}}
    -- {{{ Left layout for bottom bar
    local left_layout = wibox.widget {
        s.mylayoutbox,
        layout = wibox.layout.fixed.horizontal
    }
    if laptop.data.islaptop then
        left_layout:insert(2, bat.widget)
    end
    if laptop.data.islaptop then
        left_layout:insert(3, brightness)
    end
    -- }}}
    -- {{{ Bottom bar layout
    local center_layout = wibox.widget {
        --mylauncher,
        expand = "none",
        left_layout,
        {
            s.taglist,
            -- TODO some sort of spacer/margin
            tagadder,
            s.mypromptbox,
            layout = wibox.layout.fixed.horizontal
        },
        {
            layout = wibox.layout.fixed.horizontal,
            volume,
            s.clock,
            wibox.widget.systray(),
        },
        layout = wibox.layout.align.horizontal
    }
    s.mywibox:set_widget(center_layout)
    -- }}}
end)
-- }}}
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

    awful.titlebar(c): setup {
        { -- left
            awful.titlebar.widget.closebutton    (c),
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.minimizebutton(c),
            --awful.titlebar.widget.stickybutton   (c),
            --awful.titlebar.widget.ontopbutton    (c),
            layout = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c),
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- right
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        layout = wibox.layout.align.horizontal
    }
end)
--- }}}
-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80:foldmethod=marker:fdl=0
