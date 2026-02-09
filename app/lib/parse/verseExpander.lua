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
			local result = params
			return result
		end
	end,
}
