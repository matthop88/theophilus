local TRACKING_DATA = require("app/lib/scheduling/trackingData")

local data = TRACKING_DATA.load()

if not data then
    print("\nFAIL: No tracking data found. Run SCHEDULE first.\n")
else
    local selected = TRACKING_DATA.select(data)

    if selected.nextDate == 0 then
        selected.filter = math.max(selected.filter - 1, 0)
        print("\nFAIL recorded for: " .. selected.reference .. " — filter decreased to " .. selected.filter .. "\n")
    else
        selected.level    = 1
        selected.nextDate = 0
        print("\nFAIL recorded for: " .. selected.reference .. " — level reset, scheduled immediately.\n")
    end

    TRACKING_DATA.save(data)
end

love.event.quit()
