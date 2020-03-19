------------------------------------------------------
-- Spotify widget that displays cover, title, artist
-- in a popup. I have a custom notification rule
-- that disables notifications and uses the popup 
-- which has media controls
------------------------------------------------------

local awful = require('awful')
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local ruled = require("ruled")

local spotify_widget = {}

local player = "qdbus org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2"
local cmd = player .. " org.mpris.MediaPlayer2.Player."

local action = {
    ["toggle"] = cmd .. "PlayPause",
    ["prev"] = cmd .. "Previous",
    ["next"] = cmd .. "Next",
    ["metadata"] = cmd .. "Metadata",
    ["status"] = cmd .. "PlaybackStatus"
}

--------------------------------------------------------
--               Widget Setup                         --
--------------------------------------------------------

local spotify_info = wibox.widget {
    {
        {
            id = 'cover',
            image = "/usr/share/awesome/themes/default/layouts/fairv.png",
            resize = false,
            widget = wibox.widget.imagebox
        },
        {
            {
                -- TODO maybe add a separator
                {
                    text = " Now Playing",
                    widget = wibox.widget.textbox
                },
                {
                    id = "artist",
                    text = "hello",
                    widget = wibox.widget.textbox
                },
                {
                    id = "song",
                    text = "hello",
                    widget = wibox.widget.textbox
                },
                layout = wibox.layout.flex.vertical,  
            },
            right = 5,
            widget = wibox.container.margin
        },
        layout = wibox.layout.align.horizontal
    },
    {
        {
            -- Textboxes that act as butons
            {
                id = "prev",
                text = "Prev",
                widget = wibox.widget.textbox
            },
            {
                id = "play",
                text = "Toggle",
                widget = wibox.widget.textbox
            },
            {
                id = "next",
                text = "Next",
                widget = wibox.widget.textbox
            },
            expand = "none",
            layout = wibox.layout.align.horizontal,
        },
        margins = 5,
        widget = wibox.container.margin
    },
    layout = wibox.layout.align.vertical
}

-- TODO mess with placement to put below player status instead of top right
local spotify_popup = awful.popup {
    widget = spotify_info,
    bg = beautiful.bg_focus,
    fg = "#ffffff",
    placement = awful.placement.top_right,
    shape = gears.shape.rounded_rect,
    visible = false,
    ontop = true
}

local spotify_widget = wibox.widget {
    {
        {
            id = "status",
            text = "hello",
            widget = wibox.widget.textbox
        },
        layout = wibox.layout.align.horizontal, 
    },
    right = 5, 
    widget = wibox.container.margin
}

--------------------------------------------------------
--               Helper Function                      --
--------------------------------------------------------

local function update_metadata()
   awful.spawn.easy_async_with_shell(action["status"], function(str, err)
       --naughty.notification { title = "DEBUG", message = "" .. err}
       if err == "" then
           -- TODO I need a better test for this
           local status = str:match("Playing")
           if str ~= nil then
               spotify_widget:get_children_by_id('status')[1].text = "Playing"
               awful.spawn.easy_async_with_shell(action["metadata"], function(str)
                   local song = str:match("xesam:title:(.*)xesam:trackNumber")
                   local artist = str:match("xesam:artist:(.*)xesam:autoRating")
                   -- TODO do something with the cover
                   local cover = str:match("mpris:artUrl:(.*)")
                   spotify_info:get_children_by_id('song')[1].text = song
                   spotify_info:get_children_by_id('artist')[1].text = artist
                   --spotify_info:get_children_by_id('cover')[1].image = "/tmp/awesomewm/seth/cover.png"
               end) 
           else
               spotify_info:get_children_by_id('song')[1].text = "Paused"
               spotify_info:get_children_by_id('artist')[1].text = "Paused"
               spotify_widget:get_children_by_id('status')[1].text = "Paused"
           end
       else
               spotify_info:get_children_by_id('song')[1].text = ""
               spotify_info:get_children_by_id('artist')[1].text = ""
               spotify_widget:get_children_by_id('status')[1].text = "Not Playing"
       end
   end)
end

--------------------------------------------------------
--               signal Setup                         --
--------------------------------------------------------

spotify_info:get_children_by_id('prev')[1]:connect_signal('button::press', function()
    awful.spawn.with_shell(action["prev"]) 
end)

spotify_info:get_children_by_id('play')[1]:connect_signal('button::press', function()
    awful.spawn.with_shell(action["toggle"]) 
end)

spotify_info:get_children_by_id('next')[1]:connect_signal('button::press', function()
    awful.spawn.with_shell(action["next"]) 
    update_metadata() -- force update widget
end)

spotify_widget:connect_signal('mouse::enter', function()
    spotify_popup.visible = true 
end)

spotify_popup:connect_signal('mouse::leave', function()
    spotify_popup.visible = false 
end)

gears.timer {
    timeout = 2,
    autostart = true,
    callback = function ()
        update_metadata()
    end
}

-- We're gonna have some fun with the notification rules by disabling 
-- AwesomeWM's notification for Spotify and using our popup
ruled.notification.append_rule {
    rule       = { app_name = 'Spotify' },
    properties = { 
        widget_template = {}, -- Disable our notifications and use the popup
        callback = function() 
            spotify_popup.visible = true 
            gears.timer {
                timeout = 3,
                autostart = true,
                single_shot = true,
                callback = function ()
                    spotify_popup.visible = false
                end
            } 
        end,
    }
}

return spotify_widget
