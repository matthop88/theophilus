local BOOK_NAME_EXTRACTOR = require("app/lib/parse/bookNameExtractor")
local BOOK_META_LOOKUP    = require("app/lib/lookup/bookMetaLookup")
local PASSAGE_EXPANDER    = require("app/lib/parse/passageExpander")
local VERSE_EXPANDER      = require("app/lib/parse/verseExpander")
local VERSE_LOOKUP        = require("app/lib/lookup/verseLookup")

return function(args)
    local parseResult         = BOOK_NAME_EXTRACTOR:execute { args = args }
    local lookupResult        = BOOK_META_LOOKUP:execute(parseResult)
    local expandPassageResult = PASSAGE_EXPANDER:execute(lookupResult)
    local expandVerseResult   = VERSE_EXPANDER:execute(expandPassageResult)
    return VERSE_LOOKUP:execute(expandVerseResult)
end
