-- Custom tag config

local awful = require("awful")

awful.tag.add("I", {
    --icon ="",
    layout = awful.layout.suit.floating,
    screen = s,
    selected = true,
})

awful.tag.add("II", {
    --icon = ,
    layout = awful.layout.suit.tile,
    screen = s,
})

awful.tag.add("III", {
    --icon = "/path/to/icon2.png",
    layout = awful.layout.suit.fair,
    screen = s,
})

awful.tag.add("IV", {
    --icon = "/path/to/icon2.png",
    layout = awful.layout.suit.magnifier,
    screen = s,
})

awful.tag.add("V", {
    --icon = "/path/to/icon2.png",
    layout = awful.layout.suit.max,
    screen = s,
})

awful.tag.add("VI", {
    --icon = "/path/to/icon2.png",
    layout = awful.layout.suit.max,
    screen = s,
})

awful.tag.add("VII", {
    --icon = "/path/to/icon2.png",
    layout = awful.layout.suit.max,
    screen = s,
})

awful.tag.add("VIII", {
    --icon = "/path/to/icon2.png",
    layout = awful.layout.suit.max,
    screen = s,
})

awful.tag.add("IX", {
    --icon = "/path/to/icon2.png",
    layout = awful.layout.suit.max,
    screen = s,
})

awful.tag.add("X", {
    --icon = "/path/to/icon2.png",
    layout = awful.layout.suit.max,
    screen = s,
})

