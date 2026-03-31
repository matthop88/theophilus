local STRING_UTIL   = require("app/lib/util/stringUtil")
local TRACKING_DATA = require("app/lib/scheduling/trackingData")
local SESSION       = require("app/lib/scheduling/session")

local scheduleList = require("data/scheduling/scheduleList")

local data = TRACKING_DATA.load()
if not data then
    data = TRACKING_DATA.generate(scheduleList)
else
    data = TRACKING_DATA.sync(data, scheduleList)
end

local selected = TRACKING_DATA.select(data)

__ARGS         = STRING_UTIL:split(selected.reference, " ")
__SAVE_SESSION = true
table.insert(__ARGS, "level=" .. selected.filter)

require("app/cloak/cloakApp")
