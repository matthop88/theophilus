local PASSAGE_EXPANDER = require("app/lib/parse/passageExpander")
local ASSERT_EQUALS    = require("test/framework/assert/assertEquals")

return {
    getName = function(self) 
        return "Passage Expander tests"
    end,

    beforeAll = function(self)
        -- Do nothing
    end,

    before = function(self)
        -- Do nothing
    end,

    resultToString = function(self, result)
        local passageString = result.passage or "nil"
        local bookString    = "" .. (result.book or "nil")
        local chapterCountString = "" .. (result.chapterCount or "nil")
        local resultString = "{ book = " .. bookString .. ", chapterCount = " .. chapterCountString .. ", passage = " .. passageString
        
        if result.warning then resultString = resultString .. ", warning = " .. result.warning end
        if result.error   then resultString = resultString .. ", error = "   .. result.error   end
        if result.body    then 
            resultString = resultString .. ", body = {"
            for n, elt in ipairs(result.body) do
                resultString = resultString .. " { chapter = " .. elt.chapter .. ", verse = " .. elt.verse .. " },"
            end
            resultString = resultString .. " }"
        end
        
        return resultString .. " }"
    end,

    testExpansionPreexistingErrorFailure = function(self)
        local name = "Passage Expansion with Preexisting Error Message, Unhappy Path"

        local result = PASSAGE_EXPANDER:execute { error = "INSUFFICIENT ARGUMENTS: No Arguments Given" }
        local resultString = self:resultToString(result)
        return ASSERT_EQUALS(name, resultString, "{ book = nil, chapterCount = nil, passage = nil, error = INSUFFICIENT ARGUMENTS: No Arguments Given }")
    end,

    testExpansionSingleChapter = function(self)
        local name = "Passage Expansion with Single Chapter, Happy Path"

        local result = PASSAGE_EXPANDER:execute { book = "Philippians", passage = "3", chapterCount = 4 }
        local resultString = self:resultToString(result)
        return ASSERT_EQUALS(name, resultString, "{ book = Philippians, chapterCount = 4, passage = 3, body = { { chapter = 3, verse = 1-? }, } }")
    end,

    testExpansionSingleChapterForChapterlessBook = function(self)
        local name = "Passage Expansion with Single Value, Chapterless Volume"

        local result = PASSAGE_EXPANDER:execute { book = "Jude", passage = "3", chapterCount = 0 }
        local resultString = self:resultToString(result)
        return ASSERT_EQUALS(name, resultString, "{ book = Jude, chapterCount = 0, passage = 3, body = { { chapter = 0, verse = 3 }, } }")
    end,

    testExpansionSingleChapterInvalid = function(self)
        local name = "Passage Expansion with Bad Single Value, Unhappy Path"

        local result = PASSAGE_EXPANDER:execute { book = "Genesis", passage = "Three", chapterCount = 50 }
        local resultString = self:resultToString(result)
        return ASSERT_EQUALS(name, resultString, "{ book = Genesis, chapterCount = 50, passage = Three, error = INVALID VALUE: Three }")
    end,

    testExpansionChapterRange = function(self)
        local name = "Passage Expansion with Chapter Range, Happy Path"

        local result = PASSAGE_EXPANDER:execute { book = "Mark", passage = "1-3", chapterCount = 16 }
        local resultString = self:resultToString(result)
        return ASSERT_EQUALS(name, resultString, "{ book = Mark, chapterCount = 16, passage = 1-3, body = { { chapter = 1, verse = 1-? }, { chapter = 2, verse = 1-? }, { chapter = 3, verse = 1-? }, } }")
    end,
}
