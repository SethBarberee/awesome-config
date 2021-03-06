local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")

-- {{{ Widgets/Wibar
volume = require("volume-widget") -- custom volume widget
brightness = require("brightness-widget") -- custom volume widget
local battery = require("awesome-upower-battery")
local tagadder = require("tagadder") -- tag manipulation widget
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

-- {{{ Notiification Wibar
local notif_wb = awful.wibar {
    position = 'bottom',
    height   = 48,
    ontop = true,
    visible  = #naughty.active > 0,
}

notif_wb:setup {
    nil,
    {
        base_layout = wibox.widget {
            spacing_widget = wibox.widget {
                orientation = 'vertical',
                span_ratio  = 0.5,
                widget      = wibox.widget.separator,
            },
            forced_height = 30,
            spacing       = 3,
            layout        = wibox.layout.flex.horizontal
        },
        widget_template = {
            {
                naughty.widget.icon,
                {
                    naughty.widget.title,
                    naughty.widget.message,
                    {
                        layout = wibox.widget {
                            -- Adding the wibox.widget allows to share a
                            -- single instance for all spacers.
                            spacing_widget = wibox.widget {
                                orientation = 'vertical',
                                span_ratio  = 0.9,
                                widget      = wibox.widget.separator,
                            },
                            spacing = 3,
                            layout  = wibox.layout.flex.horizontal
                        },
                        widget = naughty.list.widgets,
                    },
                    layout = wibox.layout.align.vertical
                },
                spacing = 10,
                fill_space = true,
                layout  = wibox.layout.fixed.horizontal
            },
            margins = 5,
            widget  = wibox.container.margin
        },
        widget = naughty.list.notifications,
    },
    -- Add a button to dismiss all notifications, because why not.
    {
        {
            text   = 'Dismiss all',
            align  = 'center',
            valign = 'center',
            widget = wibox.widget.textbox
        },
        buttons = {
            awful.button({ }, 1, function() naughty.destroy_all_notifications() end)
        },
        forced_width       = 75,
        shape              = gears.shape.rounded_bar,
        shape_border_width = 1,
        shape_border_color = theme.bg_highlight,
        widget = wibox.container.background
    },
    layout = wibox.layout.align.horizontal
}

-- We don't want to have that bar all the time, only when there is content.
naughty.connect_signal('property::active', function()
    notif_wb.visible = #naughty.active > 0
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
