local awful = require("awful")
laptop = {}
local hostname
local laptop_names = {
    "Ares",
    "Hermes", -- IDK I just added this to show how this would work
}


local function check_laptop(hostname)
    awful.spawn.easy_async_with_shell("cat /etc/hostname", function(out)
        hostname = out
    end)
    for key,value in pairs(laptop_names) do
        if value == hostname then
            return true -- found a match!
        end
    end
    return false
end

return check_laptop
