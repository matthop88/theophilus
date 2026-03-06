local PUNCTUATION = "[\\.\\,\\;\\:\\!\\?\\-\\'\\\"\\(\\)]"

local stripPunctuation = function(word)
    return word:gsub(PUNCTUATION, "")
end

local cloakWord = function(word, maxLength)
    local clean  = stripPunctuation(word)
    if #clean == 0 or #clean > maxLength then return word end

    local suffix = word:match(PUNCTUATION .. "*$") or ""
    return string.rep("_", #clean) .. suffix
end

local cloakString = function(str, maxLength)
    if maxLength == 0 then return str end
    return (str:gsub("%S+", function(word)
        return cloakWord(word, maxLength)
    end))
end

return {
    cloakWord   = cloakWord,
    cloakString = cloakString,
}
