-- Custom tag config

local awful = require("awful")
local lain = require("lain")
local util = require("util")

 -- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
      awful.layout.suit.floating,
      awful.layout.suit.tile,
      awful.layout.suit.tile.left,
      awful.layout.suit.tile.bottom,
      awful.layout.suit.tile.top,
      awful.layout.suit.fair,
      awful.layout.suit.fair.horizontal,
      awful.layout.suit.spiral,
      awful.layout.suit.spiral.dwindle,
      awful.layout.suit.max,
      awful.layout.suit.max.fullscreen,
      awful.layout.suit.magnifier,
      awful.layout.suit.corner.nw,
      -- awful.layout.suit.corner.ne,
      -- awful.layout.suit.corner.sw,
      -- awful.layout.suit.corner.se,
      -- lain.layout.termfair,
      -- lain.layout.termfair.center,
      -- lain.layout.cascade,
      -- lain.layout.cascade.tile,
      lain.layout.centerwork,
      util.bstack,
      -- lain.layout.centerwork.horizontal,
  }

awful.tag.add("I", {
    --icon ="",
    layout = util.bstack,
    screen = s,
    selected = true,
})

awful.tag.add("II", {
    --icon = ,
    layout = awful.layout.suit.tile,
    screen = s,
	gap_single_client = false
})

awful.tag.add("III", {
    --icon = "/path/to/icon2.png",
    layout = awful.layout.suit.tile,
    screen = s,
})

awful.tag.add("IV", {
    --icon = "/path/to/icon2.png",
    layout = awful.layout.suit.tile,
    screen = s,
})

awful.tag.add("V", {
    --icon = "/path/to/icon2.png",
    layout = awful.layout.suit.tile,
    screen = s,
})

awful.tag.add("VI", {
    --icon = "/path/to/icon2.png",
    layout = awful.layout.suit.tile,
    screen = s,
})

awful.tag.add("VII", {
    --icon = "/path/to/icon2.png",
    layout = awful.layout.suit.tile,
    screen = s,
})

awful.tag.add("VIII", {
    --icon = "/path/to/icon2.png",
    layout = awful.layout.suit.tile,
    screen = s,
})

awful.tag.add("IX", {
    --icon = "/path/to/icon2.png",
    layout = awful.layout.suit.tile,
    screen = s,
})
