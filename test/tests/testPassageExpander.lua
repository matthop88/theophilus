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
        return ASSERT_EQUALS(name, resultString, "{ book = Genesis, chapterCount = 50, passage = Three, error = INVALID VALUE in passage: Three }")
    end,

    testExpansionChapterRange = function(self)
        local name = "Passage Expansion with Chapter Range, Happy Path"

        local result = PASSAGE_EXPANDER:execute { book = "Mark", passage = "1-3", chapterCount = 16 }
        local resultString = self:resultToString(result)
        return ASSERT_EQUALS(name, resultString, "{ book = Mark, chapterCount = 16, passage = 1-3, body = { { chapter = 1, verse = 1-? }, { chapter = 2, verse = 1-? }, { chapter = 3, verse = 1-? }, } }")
    end,

    testExpansionChapterRangeForChapterlessBook = function(self)
        local name = "Passage Expansion with Chapter Range, Chapterless Volume"

        local result = PASSAGE_EXPANDER:execute { book = "Jude", passage = "1-3", chapterCount = 0 }
        local resultString = self:resultToString(result)
        return ASSERT_EQUALS(name, resultString, "{ book = Jude, chapterCount = 0, passage = 1-3, body = { { chapter = 0, verse = 1-3 }, } }")
    end,

    testExpansionChapterRangeInvalid = function(self)
        local name = "Passage Expansion with Bad Value in Range, Unhappy Path"

        local result = PASSAGE_EXPANDER:execute { book = "James", passage = "1:3-4a", chapterCount = 5 }
        local resultString = self:resultToString(result)
        return ASSERT_EQUALS(name, resultString, "{ book = James, chapterCount = 5, passage = 1:3-4a, error = INVALID VALUE in passage: 1:3-4a }")
    end,

    testExpansionNoPassage = function(self)
        local name = "Passage Expansion for No Passage, Happy Path"

        local result = PASSAGE_EXPANDER:execute { book = "John", passage = nil, chapterCount = 21 }
        local resultString = self:resultToString(result)
        local chaptersString = ""
        for i = 1, 21 do
            chaptersString = chaptersString .. "{ chapter = " .. i .. ", verse = 1-? }, "
        end
        return ASSERT_EQUALS(name, resultString, "{ book = John, chapterCount = 21, passage = nil, body = { " .. chaptersString .. "} }")
    end,
 
    testExpansionNoPassageChapterless = function(self)
        local name = "Passage Expansion for No Passage, Chapterless Volume, Happy Path"

        local result = PASSAGE_EXPANDER:execute { book = "Jude", passage = nil, chapterCount = 0 }
        local resultString = self:resultToString(result)
        return ASSERT_EQUALS(name, resultString, "{ book = Jude, chapterCount = 0, passage = nil, body = { { chapter = 0, verse = 1-? }, } }")
    end,

    testExpansionChapterRangeWithWildcard = function(self)
        local name = "Passage Expansion for Chapter Range with Wildcard, Happy Path"

        local result = PASSAGE_EXPANDER:execute { book = "Philippians", passage = "3-?", chapterCount = 4 }
        local resultString = self:resultToString(result)
        return ASSERT_EQUALS(name, resultString, "{ book = Philippians, chapterCount = 4, passage = 3-?, body = { { chapter = 3, verse = 1-? }, { chapter = 4, verse = 1-? }, } }")
    end,

    testExpansionChapterRangeWithInvalidRange = function(self)
        local name = "Passage Expansion for Invalid Chapter Range, Unhappy Path"

        local result = PASSAGE_EXPANDER:execute { book = "Philippians", passage = "5-?", chapterCount = 4 }
        local resultString = self:resultToString(result)
        return ASSERT_EQUALS(name, resultString, "{ book = Philippians, chapterCount = 4, passage = 5-?, error = INVALID RANGE: 5-4 }")
    end,

    testExpansionChapterRangeWithInvalidRangeExtra = function(self)
        local name = "Passage Expansion for Invalid Chapter Range Extra, Unhappy Path"

        local result = PASSAGE_EXPANDER:execute { book = "Philippians", passage = "2-3-4", chapterCount = 4 }
        local resultString = self:resultToString(result)
        return ASSERT_EQUALS(name, resultString, "{ book = Philippians, chapterCount = 4, passage = 2-3-4, error = INVALID RANGE: 2-3-4 }")
    end,

    testExpansionChapterAndVerse = function(self)
        local name = "Passage Expansion for Chapter and Verse, Happy Path"

        local result = PASSAGE_EXPANDER:execute { book = "John", passage = "3:16", chapterCount = 21 }
        local resultString = self:resultToString(result)
        return ASSERT_EQUALS(name, resultString, "{ book = John, chapterCount = 21, passage = 3:16, body = { { chapter = 3, verse = 16 }, } }")
    end,

    testExpansionChapterAndVerseBad = function(self)
        local name = "Passage Expansion for Chapter and Verse, Unhappy Path"

        local result = PASSAGE_EXPANDER:execute { book = "John", passage = "3:16Z", chapterCount = 21 }
        local resultString = self:resultToString(result)
        return ASSERT_EQUALS(name, resultString, "{ book = John, chapterCount = 21, passage = 3:16Z, error = INVALID VALUE in passage: 3:16Z }")
    end,

    testExpansionChapterAndMultipleVerses = function(self)
        local name = "Passage Expansion for Chapter and Multiple Verses, Happy Path"

        local result = PASSAGE_EXPANDER:execute { book = "Ephesians", passage = "2:8-9", chapterCount = 6 }
        local resultString = self:resultToString(result)
        return ASSERT_EQUALS(name, resultString, "{ book = Ephesians, chapterCount = 6, passage = 2:8-9, body = { { chapter = 2, verse = 8-9 }, } }")
    end,

    testExpansionChapterAndMultipleVersesBad = function(self)
        local name = "Passage Expansion for Chapter and Multiple Verses, Unhappy Path"

        local result = PASSAGE_EXPANDER:execute { book = "Ephesians", passage = "2:8-9b", chapterCount = 6 }
        local resultString = self:resultToString(result)
        return ASSERT_EQUALS(name, resultString, "{ book = Ephesians, chapterCount = 6, passage = 2Z:8-9, error = INVALID VALUE in passage: 2Z:8-9 }")
    end,

}
