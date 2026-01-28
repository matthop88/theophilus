local BOOK_LOOKUP = require("app/lib/lookup/bookLookup")

--[[

1. Takes a parameter list consisting of a book name, passage and optional version.
2. Uses bookLookup to look up based upon book name and version.
3. If book isn't found, response is:
   { book = "Genesis", bookData = nil, error = { BOOK_NOT_FOUND { book = "Genesis" } }, }
4. If book is found, response is:
   { book = "Genesis", bookData = (data object), version = (versionFound), chapterCount = 50, passage = "1:1," }
5. If version isn't found, response is the same, but the following field is added:
   warning = VERSION_NOT_FOUND { book = "Genesis", requested = "NIV", found = "NASB 95" },

]]

return {
	execute = function(self, params)
		if params.error then 
			return params
		else
			local result = BOOK_LOOKUP:execute(params)

			result.passage = params.passage
			if not result.error then 
				result.chapterCount = result.bookData.chapterCount
				
				if params.version and result.version ~= params.version then
					result.warning = "VERSION NOT FOUND: " .. params.book .. " " .. params.version .. ", instead found " .. result.version
				end
			end
				
			return result
		end
	end,
}
