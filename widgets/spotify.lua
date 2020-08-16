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
            id = "buttons",
            -- Textboxes that act as butons
            -- TODO make these more pretty
            {
                id = "prev",
                text = "Prev",
                align = "center",
                widget = wibox.widget.textbox
            },
            {
                id = "play",
                text = "Toggle",
                align = "center",
                widget = wibox.widget.textbox
            },
            {
                id = "next",
                text = "Next",
                align = "center",
                widget = wibox.widget.textbox
            },
            layout = wibox.layout.flex.horizontal,
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

local update_cover = function()

	local get_art_url = [[
	dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get \
	string:'org.mpris.MediaPlayer2.Player' string:'Metadata' | 
	grep -A 1 "artUrl"| grep -v "artUrl" | awk -F '"' '{print $2}' |
	sed -e 's/open.spotify.com/i.scdn.co/g'
	]]

	awful.spawn.easy_async_with_shell(
		get_art_url,
		function(link)
			
			local download_art = [[
			tmp_dir="/tmp/awesomewm/${USER}/"
			tmp_cover_path=${tmp_dir}"cover.jpg"
			if [ ! -d $tmp_dir ]; then
				mkdir -p $tmp_dir;
			fi
			if [ -f $tmp_cover_path]; then
				rm $tmp_cover_path
			fi
			wget -O $tmp_cover_path ]] ..link .. [[
			echo $tmp_cover_path
			]]

			awful.spawn.easy_async_with_shell(
				download_art,
				function(stdout)

					local album_icon = stdout:gsub('%\n', '')

					--song_image:set_image(gears.surface.load_uncached(album_icon))
                                        spotify_info:get_children_by_id('cover')[1]:set_image(gears.surface.load_uncached(album_icon))
				end
			)
		end
	)
end

local function update_metadata()
   awful.spawn.easy_async_with_shell(action["status"], function(str, err)
       --naughty.notification { title = "DEBUG", message = "" .. err}
       if err == "" then
           -- TODO I need a better test for this
           local status = str:match("Playing")
           if str ~= nil then
               update_cover()
               spotify_widget:get_children_by_id('status')[1].text = "Playing"
               awful.spawn.easy_async_with_shell(action["metadata"], function(str)
                   local song = str:match("xesam:title:(.*)xesam:trackNumber")
                   local artist = str:match("xesam:artist:(.*)xesam:autoRating")
                   -- TODO do something with the cover
                   local cover = str:match("mpris:artUrl:(.*)")
                   spotify_info:get_children_by_id('song')[1].text = song
                   spotify_info:get_children_by_id('artist')[1].text = artist
                   spotify_info:get_children_by_id('cover')[1].image = "/tmp/awesomewm/" .. os.getenv("USER") .. "/cover.png"
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
