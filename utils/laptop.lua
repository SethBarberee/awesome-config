local laptop = {
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
local function check_laptop()
    -- Highest priority to check if we have a touch screen
    for key,value in pairs(touch_names) do
        if value == awesome.hostname then
            laptop.islaptop = true
            laptop.touch = true
            return true
        end
    end
    -- Next, we'll check if we even have a laptop
    for key,value in pairs(laptop_names) do
        if value == awesome.hostname then
            laptop.islaptop = true
            return true
        end
    end
    -- Yep, it's a desktop
end

return setmetatable(laptop, { __call = function(_, ...) check_laptop() return laptop end})

