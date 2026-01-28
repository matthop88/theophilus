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

    resultToString = function(self, result)
        local passageString = result.passage or "nil"
        local bookDataString = "nil"
        if result.bookData then bookDataString = "(DATA)" end
        local bookString    = "" .. (result.book or "nil")
        local versionString = "" .. (result.version or "nil")
        local chapterCountString = "" .. (result.chapterCount or "nil")
        local resultString = "{ book = " .. bookString .. ", bookData = " .. bookDataString .. ", version = " .. versionString .. ", chapterCount = " .. chapterCountString .. ", passage = " .. passageString
        
        if result.warning then resultString = resultString .. ", warning = " .. result.warning end
        if result.error   then resultString = resultString .. ", error = "   .. result.error   end
        
        return resultString .. " }"
    end,

    testLookupBookMetaNameSuccessNoPassage = function(self)
        local name = "Book Meta Lookup by name w.o. passage, Happy Path"

        local result = BOOK_META_LOOKUP:execute { book = "Philippians" }
        local resultString = self:resultToString(result)
        return ASSERT_EQUALS(name, resultString, "{ book = Philippians, bookData = (DATA), version = KJV, chapterCount = 4, passage = nil }")
    end,

    testLookupBookMetaNameSuccessWithPassage = function(self)
        local name = "Book Meta Lookup by name with passage, Happy Path"

        local result = BOOK_META_LOOKUP:execute { book = "Philippians", passage = "4:4" }
        local resultString = self:resultToString(result)
        return ASSERT_EQUALS(name, resultString, "{ book = Philippians, bookData = (DATA), version = KJV, chapterCount = 4, passage = 4:4 }")
    end,

    testLookupBookMetaNameAndVersionSuccess = function(self)
        local name = "Book Meta Lookup by name and version, Happy Path"

        local result = BOOK_META_LOOKUP:execute { book = "Philippians", version = "NASB 95" }
        local resultString = self:resultToString(result)
        return ASSERT_EQUALS(name, resultString, "{ book = Philippians, bookData = (DATA), version = NASB 95, chapterCount = 4, passage = nil }")
    end,

    testLookupBookMetaNameAndWrongVersionSuccess = function(self)
        local name = "Book Meta Lookup by name and wrong version, Warning Path"

        local result = BOOK_META_LOOKUP:execute { book = "Philippians", version = "NIV" }
        local resultString = self:resultToString(result)
        return ASSERT_EQUALS(name, resultString, "{ book = Philippians, bookData = (DATA), version = KJV, chapterCount = 4, passage = nil, warning = VERSION NOT FOUND: Philippians NIV, instead found KJV }")
    end,

    testLookupBookMetaWrongNameFailure = function(self)
        local name = "Book Meta Lookup by wrong name, Unhappy Path"

        local result = BOOK_META_LOOKUP:execute { book = "Hesitations", passage = "3:16", version = "NASB 95" }
        local resultString = self:resultToString(result)
        return ASSERT_EQUALS(name, resultString, "{ book = Hesitations, bookData = nil, version = nil, chapterCount = nil, passage = 3:16, error = BOOK NOT FOUND: Hesitations }")
    end,

    testLookupBookMetaPreexistingErrorFailure = function(self)
        local name = "Book Meta Lookup with preexisting error, Unhappy Path"

        local result = BOOK_META_LOOKUP:execute { error = "INSUFFICIENT ARGUMENTS: No Arguments Given" }
        local resultString = self:resultToString(result)
        return ASSERT_EQUALS(name, resultString, "{ book = nil, bookData = nil, version = nil, chapterCount = nil, passage = nil, error = INSUFFICIENT ARGUMENTS: No Arguments Given }")
    end,

}
