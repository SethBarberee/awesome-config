local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")

local function rename_tag()
    awful.prompt.run {
        prompt       = "Rename tag to: ",
        textbox      = mouse.screen.mypromptbox.widget,
        exe_callback = function(new_name)
            if not new_name or #new_name == 0 then return end

            local t = awful.screen.focused().selected_tag
            if t then
                t.name = new_name
            end
        end
    }
end

local function add_tag()
    awful.prompt.run {
        prompt       = "New tag name: ",
        textbox      = mouse.screen.mypromptbox.widget,
        exe_callback = function(new_name)
            if not new_name or #new_name == 0 then return end
            awful.tag.add(new_name, {
                screen = awful.screen.focused(),
                layout = awful.layout.suit.floating }):view_only()
            end
    }
end

local function delete_tag()
    awful.prompt.run {
        prompt       = "Deleting tag: ",
        textbox      = mouse.screen.mypromptbox.widget,
        exe_callback = function(new_name)
            if not new_name or #new_name == 0 then return end
                local t = awful.tag.find_by_name(awful.screen.focused(), new_name)
                if not t then return end
                -- Delete tag and go to previous tag
                -- TODO find way to go back previously used tag... history would be a good idea
                t:delete()
                awful.tag.viewprev(awful.screen.focused())
            end
    }    
end

local tagadder = wibox.widget {
    text = "+",
    halign = 'center',
    valign = 'center',
    widget = wibox.widget.textbox
}

tagadder.buttons = {
    awful.button({ }, 1, function () add_tag() end),
    awful.button({ }, 2, function () rename_tag() end),
    awful.button({ }, 3, function () delete_tag() end)
}

return tagadder

