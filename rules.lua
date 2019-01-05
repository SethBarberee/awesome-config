local awful = require("awful")
local beautiful = require("beautiful")
local bindings = require("bindings")


-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
local rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = bindings.keyboard.client,
                     buttons = bindings.mouse.client,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "copyq",  -- Includes session name in class.
        },
        class = {
          "Arandr",
          "Gpick",
          "Sxiv",
          "Wpa_gui",
          "pinentry",
          "xtightvncviewer"},

        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = true }
    },

    { rule = { class = "GLava" },
    properties = {titlebars_enabled = false }
    },

    -- Set Chromium to always map on the tag named "II" on screen 1
    { rule = { class = "Chromium" },
    properties = { screen = 1, tag = "II", floating = false } },

	-- Set Spotify to always map on the tag named "II" on screen 2
    { rule = { class = "Spotify" },
    properties = { screen = 1, tag = "III"} },
}

return rules
