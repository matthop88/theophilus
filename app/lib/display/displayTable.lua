local printTable

printTable = function(t, indentString, prefaceString)
	print(indentString .. prefaceString .. "{")
	for k, v in pairs(t) do
		local valueString = v
		if type(valueString) == "string" then valueString = "\"" .. valueString .. "\"" end
		local keyString = k .. " = "
		if type(k) == "number" then keyString = "" end
		if type(v) == "table" then printTable(v, indentString .. "  ", keyString)
		else                       print(indentString .. "  " .. keyString .. valueString .. ",") end
	end
	if indentString == "" then print(indentString .. "}")
	else                       print(indentString .. "},") end
end

return function(myTable)
	printTable(myTable, "", "")
end
