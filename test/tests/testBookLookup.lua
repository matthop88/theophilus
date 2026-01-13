local BOOK_LOOKUP  = require("app/lib/lookup/bookLookup")
local ASSERT_EQUALS = require("test/framework/assert/assertEquals")

return {
    getName = function(self) 
        return "Book Lookup tests"
    end,

    beforeAll = function(self)
        -- Do nothing
    end,

    before = function(self)
        -- Do nothing
    end,

    testLookupBookNameSuccess = function(self)
        local name = "Book Lookup by name, Happy Path"

        local result = BOOK_LOOKUP:execute { book = "Philippians" }
        
        local bookDataString = "nil"
        if result.bookData then bookDataString = "(DATA)" end
        local resultString = "{ book = " .. result.book .. ", bookData = " .. bookDataString .. ", version = " .. result.version .. " }"
        return ASSERT_EQUALS(name, resultString, "{ book = Philippians, bookData = (DATA), version = KJV }")
    end,

    testLookupBookNameAndVersionSuccess = function(self)
        local name = "Book Lookup by name and version, Happy Path"

        local result = BOOK_LOOKUP:execute { book = "Philippians", version = "NASB 95" }
        
        local bookDataString = "nil"
        if result.bookData then bookDataString = "(DATA)" end
        local resultString = "{ book = " .. result.book .. ", bookData = " .. bookDataString .. ", version = " .. result.version .. " }"
        return ASSERT_EQUALS(name, resultString, "{ book = Philippians, bookData = (DATA), version = NASB 95 }")
    end,

    testLookupBookNameAndWrongVersion = function(self)
        local name = "Book Lookup by name and wrong version, Happy Path"

        local result = BOOK_LOOKUP:execute { book = "Philippians", version = "NIV" }
        
        local bookDataString = "nil"
        if result.bookData then bookDataString = "(DATA)" end
        local resultString = "{ book = " .. result.book .. ", bookData = " .. bookDataString .. ", version = " .. result.version .. " }"
        return ASSERT_EQUALS(name, resultString, "{ book = Philippians, bookData = (DATA), version = KJV }")
    end,

    testLookupBookNameUnhappyPath = function(self)
        local name = "Book Lookup by name, Unhappy Path"

        local result = BOOK_LOOKUP:execute { book = "Hesitations" }
        
        local bookDataString = "nil"
        if result.bookData then bookDataString = "(DATA)" end
        local resultString = "{ book = " .. result.book .. ", bookData = " .. bookDataString .. ", error = " .. result.error .. " }"
        return ASSERT_EQUALS(name, resultString, "{ book = Hesitations, bookData = nil, error = BOOK NOT FOUND: Hesitations }")
    end,

}
            
        
