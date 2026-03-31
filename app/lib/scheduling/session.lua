local SESSION_FILE_PATH = "data/scheduling/session.lua"
local WORD_CLOAKER      = require("app/lib/cloak/wordCloaker")

local collectFromPassage = function(result, maxLength)
    local words = {}
    if result.error then return words end
    for _, ch in ipairs(result.result) do
        if not ch.warning then
            for _, v in ipairs(ch) do
                if not v.warning then
                    for _, fragment in ipairs(v) do
                        for _, word in ipairs(WORD_CLOAKER.collectCloakedWords(fragment, maxLength)) do
                            table.insert(words, word)
                        end
                    end
                end
            end
        end
    end
    return words
end

local save = function(words)
    local file = io.open(SESSION_FILE_PATH, "w")
    file:write("return {\n")
    for _, word in ipairs(words) do
        file:write(string.format("    \"%s\",\n", word))
    end
    file:write("}\n")
    file:close()
end

local loadSession = function()
    local chunk = ""
    local file = io.open(SESSION_FILE_PATH, "r")
    if not file then return nil end
    for line in file:lines() do
        chunk = chunk .. line .. "\n"
    end
    file:close()
    local objFn, err = load(chunk)
    if objFn then
        return objFn()
    else
        print("ERROR loading session: " .. err)
        return nil
    end
end

return {
    collectFromPassage = collectFromPassage,
    save               = save,
    load               = loadSession,
}
