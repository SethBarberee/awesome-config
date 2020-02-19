local awful = require('awful')
local dbus = dbus
local wibox = require("wibox")

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

spotify_widget = wibox.widget {
    {
        {
            text = "S:",
            widget = wibox.widget.textbox
        },
        -- TODO change this to imagebox
        {
            id = "status",
            text = "hello",
            widget = wibox.widget.textbox
        },
        {
            id = "song",
            text = "hello",
            widget = wibox.widget.textbox
        },
        layout = wibox.layout.align.horizontal, 
    },
    right = 5, 
    widget = wibox.container.margin
}

local function update() function 
    --TODO fix this
   --awful.spawn.easy_async(action["status"], function(str)
       --TODO do something
   --end) 
end

return spotify_widget
