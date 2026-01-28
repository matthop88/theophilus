local LOOKUP_FILES  = require("app/lib/lookup/util/lookup")

return {
	execute = function(self, params)
		if params.error then return params end
		
		local dataObjs = LOOKUP_FILES("data/scriptures", function(data) return data.book == params.book end)

		if #dataObjs == 0 then
			return {
				book = params.book, bookData = nil, error = "BOOK NOT FOUND: " .. params.book
			}
		else
			local bookData = dataObjs[1]
			if params.version then
				for _, dataObj in ipairs(dataObjs) do
					if dataObj.version == params.version then bookData = dataObj end
				end
			end

			return {
				book = bookData.book, bookData = bookData, version = bookData.version
			}
		end
	end,

}
