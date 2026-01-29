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

return {
	execute = function(self, params)
		if params.error then
			return params
		else
			local result = params
			-- Do something to result

			return result
		end
	end,
}
