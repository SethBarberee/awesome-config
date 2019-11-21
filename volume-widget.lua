local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require('naughty')

local muted = false -- Keep track of mute
local sink = ""

local volume_menu = {}
local table_len = 0 -- keep track of table length

-- TODO add volume icon
local volume = wibox.widget {
    {
        {
            id      = 'textbox',
            text    = "V: 50",
            halign  = 'center',
            valign  = 'center',
            widget  = wibox.widget.textbox
        },
        --id = 'margin',
        right = 2,
        left = 2,
        widget = wibox.container.margin,
    },
    {
        id                  = 'bar',
        maximum             = 100,
        value               = 50,
        forced_height       = 20,
        forced_width        = 100,
        bar_height          = 3,
        bar_active_color    = beautiful.bg_focus,
        bar_color           = beautiful.bg_normal,
        handle_color        = beautiful.bg_focus,
        widget              = wibox.widget.slider,
    },
    layout = wibox.layout.align.horizontal
}

local volume_t = awful.tooltip {
    objects = {volume.bar},
    timer_function = function()
        -- TODO this adds an extra line... gotta get rid of it
        awful.spawn.easy_async_with_shell("pamixer --list-sinks | cut -f 3- -d ' '", function(stdout)
            for s in stdout:gmatch("[^\r\n]+") do 
                if not volume_menu[s] then
                    volume_menu[s] = 0
                    table_len = table_len + 1
                else 
                    volume_menu[s] = volume_menu[s] + 1
                end
            end
            sink = stdout
        end)
        return sink
    end,
}

local function update_volume()
    awful.spawn.easy_async_with_shell("pamixer --get-volume-human", function(stdout)
        if not string.match(stdout, 'muted') then
            -- TODO move to parse number from previous output to save on another shell call
            awful.spawn.easy_async_with_shell("pamixer --get-volume", function(stdout)
                volume:get_children_by_id("textbox")[1].text = "V: " .. stdout
                volume:get_children_by_id("bar")[1].value    = tonumber(stdout)
            end)
            muted = false
        else 
            muted               = true
            volume:get_children_by_id("textbox")[1].text = "V: Muted"
        end
    end)
end

function volume.raise_volume()
    awful.spawn.with_shell("pamixer --increase 10")
    update_volume()
end

function volume.lower_volume()
    awful.spawn.with_shell("pamixer --decrease 10") 
    update_volume()
end

function volume.mute()
    muted = not muted -- toggle mute status
    update_volume()
end

volume:get_children_by_id("bar")[1]:connect_signal('property::value', function()
    awful.spawn.easy_async_with_shell("pamixer --set-volume " .. volume.bar.value, function()
        update_volume()
    end)
end)

volume:get_children_by_id("textbox")[1]:connect_signal('mouse::enter', function()
    -- Create the sink menu from the length - 1 (to get rid of "Sinks: " part)
    local volume_items = {}
    if table_len ~= 0 then -- check if we have enumerated the devices yet
        for s =1,(table_len - 1) do  -- same reason here for avoiding "Sink"
            local string = "Sink " .. s
            local cmd = "pamixer --sink " .. s
            table.insert(volume_items,  {string, function() awful.spawn(cmd) end} )
        end
        awful.menu(volume_items):toggle()
    end
end)

update_volume()

-- TODO how to run update_volume on creation (below doesn't work)
--return setmetatable(volume, { __call = function(_, ...) return update_volume() end})
return volume
