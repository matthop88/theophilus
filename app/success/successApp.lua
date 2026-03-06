local TRACKING_DATA = require("app/lib/scheduling/trackingData")
local FREQUENCY     = require("app/lib/scheduling/frequency")

local parsePlus = function(args)
    if not args then return nil end
    for _, arg in ipairs(args) do
        local n = arg:match("^plus=(%d+)$")
        if n then return tonumber(n) end
    end
    return nil
end

local data = TRACKING_DATA.load()

if not data then
    print("\nSUCCESS: No tracking data found. Run SCHEDULE first.\n")
else
    local selected = TRACKING_DATA.select(data)
    local plus     = parsePlus(__ARGS)

    if plus then
        selected.filter = selected.filter + plus
        print("\nSUCCESS (+filter) recorded for: " .. selected.reference .. " — filter now at " .. selected.filter .. "\n")
    else
        selected.level    = math.min(selected.level + 1, 24)
        selected.nextDate = os.time() + FREQUENCY[selected.level]
        print("\nSUCCESS recorded for: " .. selected.reference .. " — now at level " .. selected.level .. "\n")
    end

    TRACKING_DATA.save(data)
end

love.event.quit()
