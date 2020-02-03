local ruled = require("ruled")
local awful = require("awful")

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
ruled.client.connect_signal("request::rules", function()
    -- All clients will match this rule.
    ruled.client.append_rule {
        id         = "global",
        rule       = { },
        properties = {
            focus     = awful.client.focus.filter,
            raise     = true,
            screen    = awful.screen.preferred,
            placement = awful.placement.no_overlap+awful.placement.no_offscreen
        }
    }

    -- Floating clients.
    ruled.client.append_rule {
        id       = "floating",
        rule_any = {
            instance = { "copyq", "pinentry" },
            class    = {
                "Arandr", "Blueman-manager", "Gpick", "Kruler", "Sxiv",
                "Tor Browser", "Wpa_gui", "veromix", "xtightvncviewer"
            },
            -- Note that the name property shown in xprop might be set slightly after creation of the client
            -- and the name shown there might not match defined rules here.
            name    = {
                "Event Tester",  -- xev.
            },
            role    = {
                "AlarmWindow",    -- Thunderbird's calendar.
                "ConfigManager",  -- Thunderbird's about:config.
                "pop-up",         -- e.g. Google Chrome's (detached) Developer Tools.
            }
        },
        properties = { floating = true }
    }

    -- Add titlebars to normal clients and dialogs
    ruled.client.append_rule {
        id         = "titlebars",
        rule_any   = { type = { "normal", "dialog" } },
        properties = { titlebars_enabled = true      }
    }

    -- Picture in Picture need to be floaty
    ruled.client.append_rule {
        id          = "Picture",
        rule_any    = {
            name = {
                "Picture-in-Picture"
            }
        },
        properties = {
            floating = true,
            ontop = true
        }
    }

    -- Minecraft
    ruled.client.append_rule {
        id          = "Minecraft",
        rule_any    = {
            class = {
                "Minecraft Launcher",
                "net-minecraft-launcher-Main", -- Launcher
                "Minecraft 1.13.2",
                "Minecraft 1.15",
            },
            instance = {
                "Minecraft Launcher"
            }
        },
        properties = {
            maximized = true
        }
    }
end)
-- }}}
