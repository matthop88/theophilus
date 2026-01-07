-- XXX: This is overly simplistic, but works for now

return function(myTable)
	print("{")
	for k, v in pairs(myTable) do
		print("  " .. k .. " = \"" .. v .. "\",")
	end
	print("}")
end
