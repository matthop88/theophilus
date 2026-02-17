local VERSE_LOOKUP  = require("app/lib/lookup/verseLookup")
local ASSERT_EQUALS = require("test/framework/assert/assertEquals")

local EPHESIANS = {
    book = "Ephesians",
    chapterCount = 6,
    version      = "NASB 95",
    chapters     = {   
        {   chapter    = 1,
            verseCount = 23,
            verses     = { 
                {   verse = 22,
                    "And He put all things in subjection under His feet,",
                    "and gave Him as head over all things to the church,",
                },
                {   verse = 23,
                    "which is His body, the fullness of Him who fills all in all.", 
                },
            },
        },
    },
}

return {
    getName = function(self) 
        return "Verse Lookup tests"
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
            resultString = resultString .. " result = " .. self:lookupResultToString(result.result)
        end
        
        return resultString .. " }"
    end,

    lookupResultToString = function(self, lookupResult)
        local firstResult = lookupResult[1]
        local resultString = "{ { chapter = " .. firstResult.chapter .. ", verseCount = " .. firstResult.verseCount .. ", "
        for _, verse in ipairs(firstResult) do
            resultString = resultString .. "{ verse = " .. verse.verse .. ", "
            for _, fragment in ipairs(verse) do
                resultString = resultString .. "\"" .. fragment .. "\", "
            end
            resultString = resultString .. "}, "
        end
        return resultString .. " } }"
    end,

    testLookupVersePropagateErrorFailure = function(self)
        local name = "Verse Lookup, Error Propagation, Unhappy Path"

        local result = VERSE_LOOKUP:execute { error = "Gratuitous Error Here!" }
        
        local resultString = self:resultToString(result)
        return ASSERT_EQUALS(name, resultString, "{ book = nil, chapterCount = nil, passage = nil, error = Gratuitous Error Here! }")
    end,

    testLookupVersesHappyPath = function(self)
        local name = "Verse Lookup, Happy Path"

        local data = {
            book = "Ephesians",
            passage = "1:22-23",
            chapterCount = 6,
            bookData = EPHESIANS,
            request = { { chapter = 1, verse = "22-23", }, },
        }

        local result = VERSE_LOOKUP:execute(data)
        local resultString = self:resultToString(result)
        return ASSERT_EQUALS(name, resultString, "{ book = Ephesians, chapterCount = 6, passage = 1:22-23, request = { { chapter = 1, verse = 22-23 }, result = { { chapter = 1, verseCount = 23, { verse = 22, \"And He put all things in subjection under His feet,\", \"and gave Him as head over all things to the church,\", }, { verse = 23, \"which is His body, the fullness of Him who fills all in all.\", },  } } }")
    end,
}
