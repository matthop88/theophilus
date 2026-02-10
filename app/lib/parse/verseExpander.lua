local STRING_UTIL = require("app/lib/util/stringUtil")

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
			local outOfRangeVerses = {}
			local result = params

			for _, elt in ipairs(params.body) do
				local foundChapter = false
				for _, c in ipairs(params.bookData.chapters) do
					if c.chapter == elt.chapter then
						foundChapter = true
						if STRING_UTIL:endsWith(elt.verse, "?") then
							elt.verse = string.sub(elt.verse, 1, string.len(elt.verse) - 1) .. c.verseCount
						end
						local verses = STRING_UTIL:split(elt.verse, "-")
						local verseNum1 = tonumber(verses[1])
						local verseNum2 = tonumber(verses[2]) or verseNum1
						local maxVerseNum = math.max(verseNum1, verseNum2)

						if maxVerseNum > c.verseCount then
							local diff = maxVerseNum - c.verseCount
							if diff == 1 then
								table.insert(outOfRangeVerses, params.book .. " " .. elt.chapter .. ":" .. maxVerseNum)
							else
								table.insert(outOfRangeVerses, params.book .. " " .. elt.chapter .. ":" .. (c.verseCount + 1) .. "-" .. maxVerseNum)
							end
						end
					end
				end
				if not foundChapter then
					elt.warning = params.book .. " Chapter " .. elt.chapter .. " is missing from the dataset"
				end
			end

			if #outOfRangeVerses > 0 then
				result.error = "The following verses are out of range: " .. STRING_UTIL:join(outOfRangeVerses, ", ")
			end
			
			return result
		end
	end,
}
