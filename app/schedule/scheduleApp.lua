local STRING_UTIL = require("app/lib/util/stringUtil")

local scheduleList = require("data/scheduling/scheduleList")

local firstEntry = scheduleList[1]
__ARGS = STRING_UTIL:split(firstEntry, " ")

require("app/bible/bibleApp")
