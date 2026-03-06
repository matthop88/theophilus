local TRACKING_DATA = require("app/lib/scheduling/trackingData")

local data = TRACKING_DATA.load()

if not data then
    print("\nSUCCESS: No tracking data found. Run SCHEDULE first.\n")
else
    local selected = TRACKING_DATA.select(data)
    selected.level    = math.min(selected.level + 1, 15)
    selected.nextDate = os.time() + 60
    TRACKING_DATA.save(data)
    print("\nSUCCESS recorded for: " .. selected.reference .. " — now at level " .. selected.level .. "\n")
end

love.event.quit()
