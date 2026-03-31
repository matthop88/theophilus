local SESSION = require("app/lib/scheduling/session")

local splitArgs = function(args)
    if not args or #args == 0 then return {} end
    local combined = table.concat(args, ",")
    local words = {}
    for word in combined:gmatch("[^,]+") do
        local trimmed = word:match("^%s*(.-)%s*$")
        if #trimmed > 0 then
            table.insert(words, trimmed)
        end
    end
    return words
end

local normalize = function(word)
    return word:lower()
end

local expected = SESSION.load()

if not expected then
    print("\nVERIFY: No session data found. Run SCHEDULE first.\n")
    love.event.quit()
    return
end

local given = splitArgs(__ARGS)

if #given ~= #expected then
    print(string.format(
        "\nINCORRECT — expected %d word(s) but got %d.\n",
        #expected, #given
    ))
    love.event.quit()
    return
end

local allCorrect   = true
local incorrectLines = {}

for i, exp in ipairs(expected) do
    local got     = given[i] or ""
    local correct = normalize(exp) == normalize(got)
    if not correct then
        allCorrect = false
        table.insert(incorrectLines, string.format("  [%d] expected \"%s\", got \"%s\"", i, exp, got))
    end
end

if allCorrect then
    print("\nCORRECT\n")
else
    print("\nINCORRECT")
    for _, line in ipairs(incorrectLines) do
        print(line)
    end
    print("")
end

love.event.quit()
