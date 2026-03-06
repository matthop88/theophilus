local GET_PASSAGE      = require("app/lib/bible/getPassage")
local displayPassage   = require("app/lib/display/displayPassage")

local result = GET_PASSAGE(__ARGS)

displayPassage(result)

love.event.quit()
