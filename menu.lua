local awful = require("awful")
local beautiful = require("beautiful")
local global = require("global")

local awesome = _G.awesome

local menu = {}

-- {{{ Menu
-- Create a launcher widget and a main menu
local myawesomemenu = {
   { "manual", global.terminal .. " -e man awesome" },
   { "edit config", global.editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end}
}

local myappmenu = {
   { "Spotify", "spotify"},
   { "Discord", "discord"},
   { "Osu!",	"osu-lazer"},
   { "Chromium", "chromium"}
}

menu.main = awful.menu({
    items = {
        { "awesome", myawesomemenu, beautiful.awesome_icon },
		{ "Applications", myappmenu},
        { "Terminal", global.terminal }
    }
})


return menu
