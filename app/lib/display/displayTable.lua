-- XXX: This is overly simplistic, but works for now

return function(myTable)
	print("{")
	for k, v in pairs(myTable) do
		local valueString = v
		if type(v) == "table" then valueString = "(TABLE DATA)" end
		print("  " .. k .. " = \"" .. valueString .. "\",")
	end
	print("}")
end
