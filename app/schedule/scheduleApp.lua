local STRING_UTIL    = require("app/lib/util/stringUtil")
local TRACKING_DATA  = require("app/lib/scheduling/trackingData")

local scheduleList = require("data/scheduling/scheduleList")

local data = TRACKING_DATA.load()
if not data then
    data = TRACKING_DATA.generate(scheduleList)
end

local selected = TRACKING_DATA.select(data)

selected.nextDate = os.time() + 60
TRACKING_DATA.save(data)

__ARGS = STRING_UTIL:split(selected.reference, " ")

require("app/bible/bibleApp")
