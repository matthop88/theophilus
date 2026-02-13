return {
	execute = function(self, params)
		if params.error then return params end
		
		local result = {}

		for _, requestPart in ipairs(params.request) do
			local resultPart = {
				chapter = requestPart.chapter,
				warning = requestPart.warning,
			}

			if not requestPart.warning then
				-- look up verse
			end

			table.insert(result, resultPart)
		end

		params.result = result
		return params
	end,

}
