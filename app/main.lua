local BOOK_NAME_EXTRACTOR = require("app/lib/parse/bookNameExtractor")
local BOOK_META_LOOKUP    = require("app/lib/lookup/bookMetaLookup")
local PASSAGE_EXPANDER    = require("app/lib/parse/passageExpander")

local displayTable        = require("app/lib/display/displayTable")

local parseResult  = BOOK_NAME_EXTRACTOR:execute { args = __ARGS }
local lookupResult = BOOK_META_LOOKUP:execute(parseResult)
local expandResult = PASSAGE_EXPANDER:execute(lookupResult)

local result = expandResult
if result.bookData then result.bookData = "(BOOK DATA)" end

displayTable(expandResult)

love.event.quit()
