--[[
Takes a parameter list consisting of:
1. Book Data  (Table)
2. Body       (Table)

If the parameter list contains an ERROR, the parameter list is returned as is.

... More specifications go here

]]

return {
	execute = function(self, params)
		if params.error then
			return params
		else
			for _, elt in ipairs(params.body) do
				local foundChapter = false
				for _, c in ipairs(params.bookData.chapters) do
					if c.chapter == elt.chapter then
						foundChapter = true
					end
				end
				if not foundChapter then
					elt.warning = params.book .. " Chapter " .. elt.chapter .. " is missing from the dataset"
				end
			end
			local result = params
			return result
		end
	end,
}
