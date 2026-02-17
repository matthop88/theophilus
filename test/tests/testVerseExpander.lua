local VERSE_EXPANDER = require("app/lib/parse/verseExpander")
local ASSERT_EQUALS    = require("test/framework/assert/assertEquals")

local PHILIPPIANS = {
    book         = "Philippians",
    chapterCount = 4,
    version      = "NASB 95",
    chapters     = {
        {   chapter    = 1,
            verseCount = 30,
            verses = { },
        },
    },
}

local EPHESIANS = {
    book = "Ephesians",
    chapterCount = 6,
    version      = "NASB 95",
    chapters     = {   
        {   chapter    = 1,
            verseCount = 23,
            verses     = { },
        },
        {  
            chapter    = 2,
            verseCount = 22,
            verses     = { },
        },
        {  
            chapter    = 3,
            verseCount = 21,
            verses     = { },
        },
    },
}

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
        if result.request    then 
            resultString = resultString .. ", request = {"
            for n, elt in ipairs(result.request) do
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
            book = "Philippians",
            passage = "4:4",
            chapterCount = 4,
            bookData = PHILIPPIANS,
            request = { { chapter = 4, verse = 4, }, },
        }

        local result = VERSE_EXPANDER:execute(data)
        local resultString = self:resultToString(result)
        return ASSERT_EQUALS(name, resultString, "{ book = Philippians, chapterCount = 4, passage = 4:4, request = { { chapter = 4, verse = 4, warning = Philippians Chapter 4 is missing from the dataset }, } }")
    end,

    testExpansionSingleWildcardSuccess = function(self)
        local name = "Verse Expansion with Single Wildcard, Happy Path"

        local data = {
            book = "Ephesians",
            passage = "1:18-2:9",
            chapterCount = 6,
            bookData = EPHESIANS,
            request = { { chapter = 1, verse = "18-?", }, { chapter = 2, verse = "1-9", }, },
        }

        local result = VERSE_EXPANDER:execute(data)
        local resultString = self:resultToString(result)
        return ASSERT_EQUALS(name, resultString, "{ book = Ephesians, chapterCount = 6, passage = 1:18-2:9, request = { { chapter = 1, verse = 18-23 }, { chapter = 2, verse = 1-9 }, } }")
    end,

    testExpansionMultipleWildcardSuccess = function(self)
        local name = "Verse Expansion with Multiple Wildcards, Happy Path"

        local data = {
            book = "Ephesians",
            passage = "1:18-3:3",
            chapterCount = 6,
            bookData = EPHESIANS,
            request = { { chapter = 1, verse = "18-?", }, { chapter = 2, verse = "1-?", }, { chapter = 3, verse = "1-3", }, },
        }

        local result = VERSE_EXPANDER:execute(data)
        local resultString = self:resultToString(result)
        return ASSERT_EQUALS(name, resultString, "{ book = Ephesians, chapterCount = 6, passage = 1:18-3:3, request = { { chapter = 1, verse = 18-23 }, { chapter = 2, verse = 1-22 }, { chapter = 3, verse = 1-3 }, } }")
    end,

    testExpansionMultipleWarningsSuccess = function(self)
        local name = "Verse Expansion with Multiple Warnings, Happy Path"

        local data = {
            book = "Philippians",
            passage = "3:5-4:4",
            chapterCount = 4,
            bookData = PHILIPPIANS,
            request = { { chapter = 3, verse = "5-?", }, { chapter = 4, verse = "1-4", }, },
        }

        local result = VERSE_EXPANDER:execute(data)
        local resultString = self:resultToString(result)
        return ASSERT_EQUALS(name, resultString, "{ book = Philippians, chapterCount = 4, passage = 3:5-4:4, request = { { chapter = 3, verse = 5-?, warning = Philippians Chapter 3 is missing from the dataset }, { chapter = 4, verse = 1-4, warning = Philippians Chapter 4 is missing from the dataset }, } }")
    end,

    testExpansionOutOfRangeVerseFailure = function(self)
        local name = "Verse Expansion with Single Verse Out of Range Error, Unhappy Path"

        local data = {
            book = "Ephesians",
            passage = "1:24",
            chapterCount = 6,
            bookData = EPHESIANS,
            request = { { chapter = 1, verse = "24", } },
        }

        local result = VERSE_EXPANDER:execute(data)
        local resultString = self:resultToString(result)
        return ASSERT_EQUALS(name, resultString, "{ book = Ephesians, chapterCount = 6, passage = 1:24, error = The following verses are out of range: Ephesians 1:24, request = { { chapter = 1, verse = 24 }, } }") 
    end,

    testExpansionOutOfRangeClosingVerseFailure = function(self)
        local name = "Verse Expansion with Multiple Verses Out of Range Closing Verse Error, Unhappy Path"

        local data = {
            book = "Ephesians",
            passage = "1:16-27",
            chapterCount = 6,
            bookData = EPHESIANS,
            request = { { chapter = 1, verse = "16-27", } },
        }

        local result = VERSE_EXPANDER:execute(data)
        local resultString = self:resultToString(result)
        return ASSERT_EQUALS(name, resultString, "{ book = Ephesians, chapterCount = 6, passage = 1:16-27, error = The following verses are out of range: Ephesians 1:24-27, request = { { chapter = 1, verse = 16-27 }, } }") 
    end,

    testExpansionOutOfRangeOpeningVerseFailure = function(self)
        local name = "Verse Expansion with Multiple Verses Out of Range Opening Verse Error, Unhappy Path"

        local data = {
            book = "Ephesians",
            passage = "1:29",
            chapterCount = 6,
            bookData = EPHESIANS,
            request = { { chapter = 1, verse = "29", } },
        }

        local result = VERSE_EXPANDER:execute(data)
        local resultString = self:resultToString(result)
        return ASSERT_EQUALS(name, resultString, "{ book = Ephesians, chapterCount = 6, passage = 1:29, error = The following verses are out of range: Ephesians 1:24-29, request = { { chapter = 1, verse = 29 }, } }") 
    end,

    testExpansionOutOfRangeMultipleErrorsFailure = function(self)
        local name = "Verse Expansion with Multiple Errors, Unhappy Path"

        local data = {
            book = "Ephesians",
            passage = "1:25-2:27",
            chapterCount = 6,
            bookData = EPHESIANS,
            request = { { chapter = 1, verse = "25-?", }, { chapter = 2, verse = "1-27", } },
        }

        local result = VERSE_EXPANDER:execute(data)
        local resultString = self:resultToString(result)
        return ASSERT_EQUALS(name, resultString, "{ book = Ephesians, chapterCount = 6, passage = 1:25-2:27, error = The following verses are out of range: Ephesians 1:24-25, Ephesians 2:23-27, request = { { chapter = 1, verse = 25-23 }, { chapter = 2, verse = 1-27 }, } }") 
    end,
}
