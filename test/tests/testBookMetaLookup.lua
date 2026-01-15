local BOOK_META_LOOKUP  = require("app/lib/lookup/bookMetaLookup")
local ASSERT_EQUALS = require("test/framework/assert/assertEquals")

return {
    getName = function(self) 
        return "Book Meta Lookup tests"
    end,

    beforeAll = function(self)
        -- Do nothing
    end,

    before = function(self)
        -- Do nothing
    end,

    testLookupBookMetaNameSuccess = function(self)
        local name = "Book Meta Lookup by name, Happy Path"

        local result = BOOK_META_LOOKUP:execute { book = "Philippians" }
        
        local passageString = result.passage or "nil"
        local bookDataString = "nil"
        if result.bookData then bookDataString = "(DATA)" end
        local resultString = "{ book = " .. result.book .. ", bookData = " .. bookDataString .. ", version = " .. result.version .. ", chapterCount = " .. result.chapterCount .. ", passage = " .. passageString .. " }"
        return ASSERT_EQUALS(name, resultString, "{ book = Philippians, bookData = (DATA), version = KJV, chapterCount = 4, passage = nil }")
    end,

}
            
        
