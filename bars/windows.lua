local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

-- {{{ Widgets/Wibar
local volume = require("widgets.volume") -- custom volume widget
local brightness = require("widgets.brightness") -- custom volume widget
local battery = require("awesome-upower-battery")
local tagadder = require("widgets.tagadder") -- tag manipulation widget
local spotify = require("widgets.spotify")
local search_box = require("widgets.search_box")
local laptop = require("utils.laptop")

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

local screen_table = {} -- table of all my monitors

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
        style   = {
            shape = gears.shape.powerline
        },
        layout   = {
            spacing = -12,
            spacing_widget = {
                color  = '#dddddd',
                shape  = gears.shape.powerline,
                widget = wibox.widget.separator,
            },
            layout  = wibox.layout.fixed.horizontal
        },
        widget_template = {
            {
                {
                    {
                        id = "text_role",
                        widget = wibox.widget.textbox
                    },
                    layout = wibox.layout.fixed.horizontal
                },
                left = 18,
                right = 18,
                widget = wibox.container.margin
            },
            id = "background_role",
            widget = wibox.container.background,
          -- Add support for hover colors
          create_callback = function(self, c3, index, objects) --luacheck: no unused args
              self:connect_signal('mouse::enter', function()
                  if not c3.selected then
                      if self.bg ~= beautiful.bg_focus then
                          self.backup     = self.bg
                          self.has_backup = true
                      end
                      self.bg = beautiful.bg_focus
                  end
              end)
              self:connect_signal('mouse::leave', function()
                  if self.has_backup and not c3.selected then
                      self.bg = self.backup
                  end
              end)
          end,
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
    local left_top_layout = wibox.layout
    {
        layout = wibox.layout.align.horizontal,
        mylauncher,
        si.taglist,
        tagadder, -- TODO multi-monitor magic
        s.mypromptbox,
    }
    local right_layout = wibox.layout {
        spotify,
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
        left_top_layout,
        s.mytextclock,
        right_layout,
        expand = "none",
        layout = wibox.layout.align.horizontal,
    }
    --- }}}
end)
-- }}}
---{{{ Tasklist buttons
local tasklist_buttons = {
    awful.button({ }, 1, function (c)
        c:activate { context = "tasklist", action = "toggle_minimization" }
    end),
    awful.button({ }, 3, function()
        awful.menu.client_list({ beautiful = { width = 250 } })
    end),
    awful.button({ }, 4, function ()
        awful.client.focus.byidx(1)
    end),
    awful.button({ }, 5, function ()
        awful.client.focus.byidx(-1)
    end)
}
--- }}} 
--- {{{ Widget bar setup
screen.connect_signal("request::desktop_decoration", function(s)
    local notif_wb = awful.wibar {
        position = 'bottom',
        height   = dpi(48),
        type = 'dock',
        bg = 'transparent',
        screen = s,
    }

    -- {{{ Tasklist wibar
    local mytasklist = awful.widget.tasklist {
        screen   = s,
        filter   = awful.widget.tasklist.filter.currenttags,
        buttons  = tasklist_buttons,
        layout   = {
            spacing_widget = {
                {
                    forced_width  = dpi(5),
                    forced_height = dpi(24),
                    thickness     = dpi(1),
                    color         = '#777777',
                    widget        = wibox.widget.separator
                },
                valign = 'center',
                halign = 'center',
                widget = wibox.container.place,
            },
            spacing = dpi(1),
            layout  = wibox.layout.fixed.horizontal
        },
        -- Notice that there is *NO* wibox.wibox prefix, it is a template,
        -- not a widget instance.
        widget_template = {
            {
                wibox.widget.base.make_widget(),
                forced_height = dpi(5),
                id            = 'background_role',
                widget        = wibox.container.background,
            },
            {
                {
                    id = 'clienticon',
                    widget = awful.widget.clienticon,
                },
                margins = dpi(5),
                widget  = wibox.container.margin
            },
            nil,
            layout = wibox.layout.align.vertical,
            -- TODO is there a click callback???
            create_callback = function(self, c, index, objects) --luacheck: no unused args
                local tooltip = awful.tooltip({
                    objects = { self },
                    timer_function = function()
                        return c.name
                    end,
                })
                self:get_children_by_id('clienticon')[1].client = c
            end,
            update_callback = function(self, c, index, objects) --luacheck: no unused args
                -- TODO use this to count and combine
                -- TODO somehow will use multiple backgrounds
                    --naughty.notification { title = "DEBUG", message = "" .. index .. ": " .. c.class}
            end,
        },
    }

    --- {{{ Wibar setup
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(search_box)

    local layout = wibox.widget {
        {
            left_layout,
            {
                mytasklist,
                content_fill_horizontal = true,
                widget = wibox.container.place,
            },
            wibox.widget.systray(),
            layout = wibox.layout.align.horizontal,
        },
        top = beautiful.border_width,
        color = beautiful.border_focus,
        widget = wibox.container.margin,
    }
    notif_wb:set_widget(layout)
    --- }}}
end)
--- }}}
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
-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80:foldmethod=marker:fdl=0
