local beautiful = require("beautiful")
local naughty = require("naughty")
local ruled = require("ruled")
local awful = require("awful")

ruled.notification.connect_signal("request::rules", function()
    -- All notifications will match this rule.
    ruled.notification.append_rule {
        rule       = { },
        properties = {
            screen           = awful.screen.preferred,
            implicit_timeout = 5,
        }
    }
    -- Add a red background for urgent notifications.
    ruled.notification.append_rule {
        rule       = { urgency = "critical" },
        properties = { fg = "#FF0000", timeout = 0 }
    }

    ruled.notification.append_rule {
        rule       = { urgency = "normal" },
        properties = { 
            fg = beautiful.notification_fg,
            border_width = beautiful.notification_border_width,
        }
    }

    ruled.notification.append_rule {
        rule       = { app_name = 'Spotify' },
        properties = { 
            append_actions = {
                naughty.action {
                    name = "Back",
                    selected = false
                },
                naughty.action {
                    name = "Play/Pause",
                    selected = false
                },
                naughty.action {
                    name = "Next",
                    selected = false
                },
            }
        }
    }
end)

-- TODO how do I make this work to skip songs for spotify
--naughty.connect_signal("property::selected", function(n)
--    naughty.notification { title = "DEBUG", message = " " .. n}
--end)

naughty.connect_signal("request::display", function(n)
    naughty.layout.box { notification = n }
end)
