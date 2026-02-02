STRING_UTIL = require("app/lib/util/stringUtil")

--[[
Takes a parameter list consisting of:
1. Book Name     (String)
2. Passage       (String, possibly colon and hyphen delimited)
3. Chapter Count (Number)

If the parameter list contains an ERROR, the parameter list is returned as is.

The parameter list is modified in place; the string passage is preserved, but a new parameter (body) is added.

body = {
	{ chapter = (Number),
	  verse   = (Hyphen-delimited String range),
	},
	...
}

]]

local parseRange = function(r)
	local range = STRING_UTIL:split(r, "-")
	if #range == 1 then
		return { startValue = range[1], endValue = range[1] }
	else
		return { startValue = range[1], endValue = range[2] }
	end
end

return {
	execute = function(self, params)
		if params.error then
			return params
		else
			local result = params
			local range = parseRange(params.passage)
			if params.chapterCount == 0 then
				result.body = { { chapter = 0, verse = params.passage } }
			else
				local numericStart = tonumber(range.startValue)
				local numericEnd   = tonumber(range.endValue)

				if numericStart == nil or numericEnd == nil then
					result.error = "INVALID VALUE in passage: " .. params.passage
				else
					result.body = {}
					for i = numericStart, numericEnd do
						table.insert(result.body, { chapter = i, verse = "1-?" })
					end
				end
			end

			return result
		end
	end,
}
