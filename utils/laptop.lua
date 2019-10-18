local awful = require("awful")

laptop = {
    islaptop = false,
    touch = false
}

-- List of laptop names w/o touch
local laptop_names = {

}

-- List of laptops with touch
local touch_names  = {
    "Athena"
}

-- Util function to check if we are on a laptop
local hostname
local function check_laptop()
    awful.spawn.easy_async_with_shell("cat /etc/hostname", function(out)
        hostname = out
    end)
    -- Highest priority to check if we have a touch screen
    for key,value in pairs(touch_names) do
        if value == hostname then
            laptop.islaptop = true
            laptop.touch = true
            return true -- found a match!
        end
    end
    -- Next, we'll check if we even have a laptop
    for key,value in pairs(laptop_names) do
        if value == hostname then
            laptop.islaptop = true
            return true -- found a match!
        end
    end
    -- Yep, it's a desktop
    return false
end

check_laptop()

return laptop

