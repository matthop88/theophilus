local VERSE_EXPANDER = require("app/lib/parse/verseExpander")
local ASSERT_EQUALS    = require("test/framework/assert/assertEquals")

return {
    getName = function(self) 
        return "Verse Expander tests"
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
                resultString = resultString .. " { chapter = " .. elt.chapter .. ", verse = " .. elt.verse
                    if elt.warning then resultString = resultString .. ", warning = " .. elt.warning end
                resultString = resultString .. " },"
            end
            resultString = resultString .. " }"
        end
        
        return resultString .. " }"
    end,

    testExpansionPreexistingErrorFailure = function(self)
        local name = "Verse Expansion with Preexisting Error Message, Unhappy Path"

        local result = VERSE_EXPANDER:execute { error = "INSUFFICIENT ARGUMENTS: No Arguments Given" }
        local resultString = self:resultToString(result)
        return ASSERT_EQUALS(name, resultString, "{ book = nil, chapterCount = nil, passage = nil, error = INSUFFICIENT ARGUMENTS: No Arguments Given }")
    end,

    testExpansionSingleWarningSuccess = function(self)
        local name = "Verse Expansion with Missing Chapter, Single Warning, Happy Path"

        local data = {
            body = {
                {
                    verse = "8-9",
                    chapter = 2,
                },
            },
            book = "Ephesians",
            passage = "2:8-9",
            chapterCount = 6,
            bookData = {
                book = "Ephesians",
                chapterCount = 6,
                version      = "NASB 95",
                chapters     = { }
            },
        }

        local result = VERSE_EXPANDER:execute(data)
        local resultString = self:resultToString(result)
        return ASSERT_EQUALS(name, resultString, "{ book = Ephesians, chapterCount = 6, passage = 2:8-9, body = { { chapter = 2, verse = 8-9, warning = Ephesians Chapter 2 is missing from the dataset }, } }")
    end,

    testExpansionSingleWildcardSuccess = function(self)
        local name = "Verse Expansion with Single Wildcard, Happy Path"

        local data = {
            body = {
                {
                    chapter = 1,
                    verse = "18-?",
                },
                {  
                    chapter = 2,
                    verse = "1-9",
                },
            },
            book = "Ephesians",
            passage = "1:18-2:9",
            chapterCount = 6,
            bookData = {
                book = "Ephesians",
                chapterCount = 6,
                version      = "NASB 95",
                chapters     = {   
                    {   
                        chapter    = 1,
                        verseCount = 23,
                        verses     = { },
                    },
                    {  
                        chapter    = 2,
                        verseCount = 23,
                        verses     = { },
                    },
                },
            },
        }

        local result = VERSE_EXPANDER:execute(data)
        local resultString = self:resultToString(result)
        return ASSERT_EQUALS(name, resultString, "{ book = Ephesians, chapterCount = 6, passage = 1:18-2:9, body = { { chapter = 1, verse = 18-23 }, { chapter = 2, verse = 1-9 }, } }")
    end,

}
