local WORD_CLOAKER = require("app/lib/cloak/wordCloaker")

local cloakVerse = function(v, maxLength)
    local cloaked = { verse = v.verse, warning = v.warning }
    for i, fragment in ipairs(v) do
        cloaked[i] = WORD_CLOAKER.cloakString(fragment, maxLength)
    end
    return cloaked
end

local cloakChapter = function(ch, maxLength)
    local cloaked = { chapter = ch.chapter, verseCount = ch.verseCount, warning = ch.warning }
    for i, v in ipairs(ch) do
        cloaked[i] = cloakVerse(v, maxLength)
    end
    return cloaked
end

return {
    execute = function(self, params)
        local result    = params.result
        local maxLength = params.maxLength

        if result.error then return result end

        local cloaked = {
            book    = result.book,
            passage = result.passage,
            version = result.version,
            result  = {},
        }

        for i, ch in ipairs(result.result) do
            cloaked.result[i] = cloakChapter(ch, maxLength)
        end

        return cloaked
    end,
}
