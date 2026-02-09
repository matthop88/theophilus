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
                resultString = resultString .. " { chapter = " .. elt.chapter .. ", verse = " .. elt.verse .. " },"
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


}
