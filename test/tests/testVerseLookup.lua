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

local PHILIPPIANS = {
    book         = "Philippians",
    chapterCount = 4,
    version      = "NASB 95",
    chapters     = {
        {   chapter    = 1,
            verseCount = 30,
            verses = {
                {   verse = 1,
                    "Paul and Timothy, bond-servants of Christ Jesus,",
                    "To all the saints in Christ Jesus who are in Philippi, including the overseers and deacons:",
                },
                {   verse = 2,
                    "Grace to you and peace from God our Father and the Lord Jesus Christ.",
                },
                {   verse = 6,
                    "For I am confident of this very thing,",
                    "that He who began a good work in you will perfect it until the day of Christ Jesus.",
                },
                {   verse = 7,
                    "For it is only right for me to feel this way about you all, because I have you in my heart,",
                    "since both in my imprisonment and in the defense and confirmation of the gospel, you all are partakers of grace with me.",
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
            if verse.warning then
                resultString = resultString .. "{ warning = " .. verse.warning .. " "
            else
                resultString = resultString .. "{ verse = " .. verse.verse .. ", "
                for _, fragment in ipairs(verse) do
                    resultString = resultString .. "\"" .. fragment .. "\", "
                end
            end
            resultString = resultString .. "}, "
        end
        return resultString .. "} }"
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
        return ASSERT_EQUALS(name, resultString, "{ book = Ephesians, chapterCount = 6, passage = 1:22-23, request = { { chapter = 1, verse = 22-23 }, result = { { chapter = 1, verseCount = 23, { verse = 22, \"And He put all things in subjection under His feet,\", \"and gave Him as head over all things to the church,\", }, { verse = 23, \"which is His body, the fullness of Him who fills all in all.\", }, } } }")
    end,

    testLookupMissingVersesHappyPath = function(self)
        local name = "Missing Verse Lookup, Happy Path"

        local data = {
            book = "Philippians",
            passage = "1:1-9",
            chapterCount = 4,
            bookData = PHILIPPIANS,
            request = { { chapter = 1, verse = "1-9", }, },
        }

        local result = VERSE_LOOKUP:execute(data)
        local resultString = self:resultToString(result)
        return ASSERT_EQUALS(name, resultString, "{ book = Philippians, chapterCount = 4, passage = 1:1-9, request = { { chapter = 1, verse = 1-9 }, result = { { chapter = 1, verseCount = 30, { verse = 1, \"Paul and Timothy, bond-servants of Christ Jesus,\", \"To all the saints in Christ Jesus who are in Philippi, including the overseers and deacons:\", }, { verse = 2, \"Grace to you and peace from God our Father and the Lord Jesus Christ.\", }, { warning = The following verses are missing: Philippians 1:3-5 }, { verse = 6, \"For I am confident of this very thing,\", \"that He who began a good work in you will perfect it until the day of Christ Jesus.\", }, { verse = 7, \"For it is only right for me to feel this way about you all, because I have you in my heart,\", \"since both in my imprisonment and in the defense and confirmation of the gospel, you all are partakers of grace with me.\", }, { warning = The following verses are missing: Philippians 1:8-9 }, } } }")
    end,
}
