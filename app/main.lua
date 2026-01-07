local BOOK_NAME_EXTRACTOR = require("app/lib/parse/bookNameExtractor")
local displayTable        = require("app/lib/display/displayTable")

local result = BOOK_NAME_EXTRACTOR:execute { args = __ARGS }

displayTable(result)

love.event.quit()
