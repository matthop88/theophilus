local BOOK_NAME_EXTRACTOR = require("app/lib/parse/bookNameExtractor")
local BOOK_META_LOOKUP    = require("app/lib/lookup/bookMetaLookup")
local displayTable        = require("app/lib/display/displayTable")

local parseResult  = BOOK_NAME_EXTRACTOR:execute { args = __ARGS }
local lookupResult = BOOK_META_LOOKUP:execute(parseResult)

displayTable(lookupResult)

love.event.quit()
