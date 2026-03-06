local PASSAGE_CLOAKER = require("app/lib/cloak/passageCloaker")
local ASSERT_EQUALS   = require("test/framework/assert/assertEquals")

local makeResult = function(fragments)
    return {
        book    = "Ephesians",
        passage = "2:8-9",
        version = "NASB 95",
        result  = {
            {   chapter    = 2,
                verseCount = 22,
                {   verse = 8,
                    fragments[1],
                    fragments[2],
                },
                {   verse = 9,
                    fragments[3],
                },
            },
        },
    }
end

return {
    getName = function(self)
        return "Passage Cloaker Tests"
    end,

    beforeAll = function(self) end,
    before    = function(self) end,

    testLevel0NoChange = function(self)
        local name = "Level 0 — cloaked passage unchanged"
        local result = makeResult {
            "For by grace you have been saved through faith;",
            "and that not of yourselves, it is the gift of God;",
            "not as a result of works, so that no one may boast.",
        }
        local cloaked = PASSAGE_CLOAKER:execute { result = result, maxLength = 0 }
        return ASSERT_EQUALS(name,
            cloaked.result[1][1][1],
            "For by grace you have been saved through faith;")
    end,

    testLevel2CloaksShortWords = function(self)
        local name = "Level 2 — short words cloaked in returned passage"
        local result = makeResult {
            "For by grace you have been saved through faith;",
            "and that not of yourselves, it is the gift of God;",
            "not as a result of works, so that no one may boast.",
        }
        local cloaked = PASSAGE_CLOAKER:execute { result = result, maxLength = 2 }
        return ASSERT_EQUALS(name,
            cloaked.result[1][1][1],
            "For __ grace you have been saved through faith;")
    end,

    testOriginalUnchanged = function(self)
        local name = "Original result is not mutated"
        local result = makeResult {
            "For by grace you have been saved through faith;",
            "and that not of yourselves, it is the gift of God;",
            "not as a result of works, so that no one may boast.",
        }
        PASSAGE_CLOAKER:execute { result = result, maxLength = 2 }
        return ASSERT_EQUALS(name,
            result.result[1][1][1],
            "For by grace you have been saved through faith;")
    end,

    testErrorPassedThrough = function(self)
        local name = "Error result passed through unchanged"
        local result = { error = "Some error" }
        local cloaked = PASSAGE_CLOAKER:execute { result = result, maxLength = 3 }
        return ASSERT_EQUALS(name, cloaked.error, "Some error")
    end,

    testMultipleFragmentsCloaked = function(self)
        local name = "Level 3 — all fragments in verse cloaked"
        local result = makeResult {
            "For by grace you have been saved through faith;",
            "and that not of yourselves, it is the gift of God;",
            "not as a result of works, so that no one may boast.",
        }
        local cloaked = PASSAGE_CLOAKER:execute { result = result, maxLength = 3 }
        return ASSERT_EQUALS(name,
            cloaked.result[1][1][2],
            "___ that ___ __ yourselves, __ __ ___ gift __ ___;")
    end,
}
