local VERSE_LOOKUP  = require("app/lib/lookup/verseLookup")
local ASSERT_EQUALS = require("test/framework/assert/assertEquals")

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
            resultString = resultString .. " }"
        end
        
        return resultString .. " }"
    end,

    testLookupVersePropagateErrorFailure = function(self)
        local name = "Verse Lookup, Error Propagation, Unhappy Path"

        local result = VERSE_LOOKUP:execute { error = "Gratuitous Error Here!" }
        
        local resultString = self:resultToString(result)
        return ASSERT_EQUALS(name, resultString, "{ book = nil, chapterCount = nil, passage = nil, error = Gratuitous Error Here! }")
    end,
}
