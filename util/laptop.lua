local awful = require("awful")
laptop = {}
local hostname = awful.spawn("cat /etc/hostname")
local laptop_names = {
    "Ares",
    "Hermes", -- IDK I just added this to show how this would work
}

local function update_hostname()
    hostname = awful.spawn("cat /etc/hostname")
end

local function check_laptop(hostname)
    update_hostname()
    for key,value in pairs(laptop_names) do
        if value == hostname then
            return true -- found a match!
        end
    end
    return false
end

return check_laptop
