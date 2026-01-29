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
        local bookDataString = "nil"
        if result.bookData then bookDataString = "(DATA)" end
        local bookString    = "" .. (result.book or "nil")
        local versionString = "" .. (result.version or "nil")
        local chapterCountString = "" .. (result.chapterCount or "nil")
        local resultString = "{ book = " .. bookString .. ", bookData = " .. bookDataString .. ", version = " .. versionString .. ", chapterCount = " .. chapterCountString .. ", passage = " .. passageString
        
        if result.warning then resultString = resultString .. ", warning = " .. result.warning end
        if result.error   then resultString = resultString .. ", error = "   .. result.error   end
        
        return resultString .. " }"
    end,

    testExpansionPreexistingErrorFailure = function(self)
        local name = "Passage Expansion with Preexisting Error Message, Unhappy Path"

        local result = PASSAGE_EXPANDER:execute { error = "INSUFFICIENT ARGUMENTS: No Arguments Given" }
        local resultString = self:resultToString(result)
        return ASSERT_EQUALS(name, resultString, "{ book = nil, bookData = nil, version = nil, chapterCount = nil, passage = nil, error = INSUFFICIENT ARGUMENTS: No Arguments Given }")
    end,
}
