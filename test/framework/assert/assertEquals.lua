local ASTERISKS = require("test/framework/const/asterisks")

local passedResult = function(name)
	print("PASSED => " .. name)
	return true
end

local failedResult = function(name, actual, expected)
	print("\n" .. ASTERISKS .. "FAILED => " .. name)
    print("  Expected: ", expected)
    print("  Actual: ",   actual)
    print(ASTERISKS)
    return false
end

return function(name, actual, expected)
	if expected == actual then
		return passedResult(name)
	else
		return failedResult(name, actual, expected)
	end
end
