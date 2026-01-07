local BOOK_NAME_EXTRACTOR = require("app/lib/parse/bookNameExtractor")
local ASSERT_EQUALS       = require("test/framework/assert/assertEquals")

return {
    getName = function(self) 
        return "Book Name Extractor Tests"
    end,

    beforeAll = function(self)
        -- Do nothing
    end,

    before = function(self)
        -- Do nothing
    end,

    runExtractor = function(self, params)
        local result = BOOK_NAME_EXTRACTOR:execute(params)

        if     result.error   then return "error = " .. result.error
        elseif result.passage then return "book = "  .. result.book .. ", passage = " .. result.passage
        else                       return "book = "  .. result.book                                     end
    end,
    
    testSingleArgumentBookName = function(self)
        local name = "Single Argument Book Name, Happy Path"

        local result = self:runExtractor { args = { "Genesis", "1:1" } }
        
        return ASSERT_EQUALS(name, result, "book = Genesis, passage = 1:1")
    end,

    testTwoArgumentBookName = function(self)
        local name = "Two Argument Book Name, Happy Path"

        local result = self:runExtractor { args = { "1", "John", "3:16" } }

        return ASSERT_EQUALS(name, result, "book = 1 John, passage = 3:16")
    end,

    testNoPassage = function(self)
        local name = "No Passage, Happy Path"

        local result = self:runExtractor { args = { "Philippians" } }

        return ASSERT_EQUALS(name, result, "book = Philippians")
    end,

    testZeroArgumentBookNameError = function(self)
        local name = "Zero Argument Book Name, Error Path"

        local result = self:runExtractor { args = {} }

        return ASSERT_EQUALS(name, result, "error = INSUFFICIENT ARGUMENTS: No Arguments Given")
    end,

    testSingleArgumentBookNameError = function(self)
        local name = "SingleArgument Book Name, Error Path"

        local result = self:runExtractor { args = { "1" } }

        return ASSERT_EQUALS(name, result, error = "INSUFFICIENT ARGUMENTS: '1' -> Book Name Expected")
    end,
}
            
        
