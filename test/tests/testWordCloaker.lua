local WORD_CLOAKER  = require("app/lib/cloak/wordCloaker")
local ASSERT_EQUALS = require("test/framework/assert/assertEquals")

return {
    getName = function(self)
        return "Word Cloaker Tests"
    end,

    beforeAll = function(self) end,
    before    = function(self) end,

    testLevel0NoChange = function(self)
        local name = "Level 0 — no words cloaked"
        return ASSERT_EQUALS(name,
            WORD_CLOAKER.cloakString("For by grace you have been saved through faith;", 0),
            "For by grace you have been saved through faith;")
    end,

    testCloakShortWords = function(self)
        local name = "Level 2 — words up to 2 chars cloaked"
        return ASSERT_EQUALS(name,
            WORD_CLOAKER.cloakString("For by grace you have been saved through faith;", 2),
            "For __ grace you have been saved through faith;")
    end,

    testCloakWithPunctuation = function(self)
        local name = "Punctuation preserved, not counted in word length"
        return ASSERT_EQUALS(name,
            WORD_CLOAKER.cloakString("now,", 3),
            "___,")
    end,

    testCloakWordExactLength = function(self)
        local name = "Word exactly at max length is cloaked"
        return ASSERT_EQUALS(name,
            WORD_CLOAKER.cloakWord("the", 3),
            "___")
    end,

    testCloakWordAboveMaxNotCloaked = function(self)
        local name = "Word above max length is not cloaked"
        return ASSERT_EQUALS(name,
            WORD_CLOAKER.cloakWord("grace", 3),
            "grace")
    end,

    testCloakWordWithTrailingComma = function(self)
        local name = "Word with trailing comma — punctuation kept"
        return ASSERT_EQUALS(name,
            WORD_CLOAKER.cloakWord("you,", 3),
            "___,")
    end,

    testCloakWordWithTrailingPeriod = function(self)
        local name = "Word with trailing period — punctuation kept"
        return ASSERT_EQUALS(name,
            WORD_CLOAKER.cloakWord("God.", 3),
            "___.") 
    end,

    testCloakLevel3Sample = function(self)
        local name = "Level 3 sample — matches ticket example"
        return ASSERT_EQUALS(name,
            WORD_CLOAKER.cloakString("Paul and Timothy, bond-servants of Christ Jesus,", 3),
            "Paul ___ Timothy, bond-servants __ Christ Jesus,")
    end,
}
