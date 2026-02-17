local BOOK_NAME_EXTRACTOR = require("app/lib/parse/bookNameExtractor")
local BOOK_META_LOOKUP    = require("app/lib/lookup/bookMetaLookup")
local PASSAGE_EXPANDER    = require("app/lib/parse/passageExpander")
local VERSE_EXPANDER      = require("app/lib/parse/verseExpander")
local VERSE_LOOKUP        = require("app/lib/lookup/verseLookup")

local displayTable        = require("app/lib/display/displayTable")

local parseResult         = BOOK_NAME_EXTRACTOR:execute { args = __ARGS }
local lookupResult        = BOOK_META_LOOKUP:execute(parseResult)
local expandPassageResult = PASSAGE_EXPANDER:execute(lookupResult)
local expandVerseResult   = VERSE_EXPANDER:execute(expandPassageResult)
local lookupVerseResult   = VERSE_LOOKUP:execute(expandVerseResult)

local result = lookupVerseResult
if result.bookData then result.bookData = "(BOOK DATA)" end

displayTable(result)

love.event.quit()
