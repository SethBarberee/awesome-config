local math = { ceil = math.ceil,
              floor = math.floor,
                max = math.max}
local screen = screen

local bstack = {name = "bstack"}
bstack.horizontal = {name = "bstack-horiz"}

local function do_stack(p, orientation)
    local t = p.tag or screen[p.screen].selected_tag
    local wa = p.workarea
    local cls = p.clients

    if #cls == 0 then return end

    local g = {}
    local mwfact = t.master_width_factor
    local nmaster = t.master_count

    -- Top half, fixed width and height

    if orientation == "normal" then
        -- Layout design
        --
        --      (1)              (2)              (3)
        -- +-----------+    +-----------+    +-----------+
        -- |           |    |     1     |    |     1     |
        -- |     1     | -> +-----------+ -> +-----+-----+
        -- |           |    |     2     |    |  2  |  3  |
        -- +-----------+    +-----------+    +-----+-----+
        if #cls == 1 then
            -- Only one so fullscreen it
            local c = cls[1]
            g.height = wa.height
            g.width = wa.width
            g.x = 0
            g.y = 0
            p.geometries[c] = g
        else
            local screen_half = math.floor(wa.height/2)
            local rem_clients = #cls - nmaster
            -- Set top half
            -- TODO account for mwfact
            for i = 1, nmaster, 1 do
                local a = cls[i]
                local g = {}
                g.width = wa.width / nmaster
                g.height = screen_half
                g.x = (i-1) * g.width
                g.y = 0
                p.geometries[a] = g
            end
            -- Divide bottom half for clients
            for i = #cls,nmaster+1,-1 do
                local a = cls[i]
                local g = {}
                -- TODO height should change with mwfact
                g.height = screen_half
                g.width = math.floor(wa.width/rem_clients)
                g.x = (i-nmaster-1) * g.width 
                g.y = screen_half
                p.geometries[a] = g
            end
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
