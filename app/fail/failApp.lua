local TRACKING_DATA = require("app/lib/scheduling/trackingData")

local data = TRACKING_DATA.load()

if not data then
    print("\nFAIL: No tracking data found. Run SCHEDULE first.\n")
else
    local selected = TRACKING_DATA.select(data)
    selected.level    = 1
    selected.nextDate = 0
    TRACKING_DATA.save(data)
    print("\nFAIL recorded for: " .. selected.reference .. " — level reset, scheduled immediately.\n")
end

love.event.quit()
