local math = { ceil = math.ceil,
              floor = math.floor,
                max = math.max}
local screen = screen
local tonumber = tonumber
local beautiful = require("beautiful")

local bstack = {name = "bstack"}
bstack.horizontal = {name = "bstack-horiz"}

local function do_stack(p, orientation)
    local t = p.tag or screen[p.screen].selected_tag
    local wa = p.workarea
    local cls = p.clients

    if #cls == 0 then return end

    local c = cls[1]
    local g = {}

    -- Top half, fixed width and height
    local mwfact = t.master_width_factor

    if orientation == "normal" then
        -- Layout design
        --
        --      (1)              (2)              (3)
        -- +-----------+    +-----------+    +-----------+
        -- |           |    |     1     |    |     1     |
        -- |     1     | -> +-----------+ -> +-----+-----+
        -- |           |    |     2     |    |  2  |  3  |
        -- +-----------+    +-----------+    +-----+-----+
        g.width = wa.width
        g.x = 0
        g.y = 0
        if #cls == 1 then
            g.height = wa.height
        else
            g.height = math.floor(wa.height/2)
            g.y = g.y + g.height
        end
        p.geometries[c] = g
        if #cls <= 1 then
            return
        end
    elseif orientation == "horizontal" then

    end
end

function bstack.horizontal.arrange(p)
    return do_stack(p, "horizontal")
end

function bstack.arrange(p)
    return do_stack(p, "normal")
end

return bstack
