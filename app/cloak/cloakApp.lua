local GET_PASSAGE     = require("app/lib/bible/getPassage")
local PASSAGE_CLOAKER = require("app/lib/cloak/passageCloaker")
local displayPassage  = require("app/lib/display/displayPassage")

local parseArgs = function(args)
    local passageArgs = {}
    local maxLength   = 0

    for _, arg in ipairs(args) do
        local level = arg:match("^level=(%d+)$")
        if level then
            maxLength = tonumber(level)
        else
            table.insert(passageArgs, arg)
        end
    end

    return passageArgs, maxLength
end

local passageArgs, maxLength = parseArgs(__ARGS)

local result  = GET_PASSAGE(passageArgs)
local cloaked = PASSAGE_CLOAKER:execute { result = result, maxLength = maxLength }

displayPassage(cloaked)

love.event.quit()
