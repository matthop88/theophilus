local STRING_UTIL = require("app/lib/util/stringUtil")

local lookupChapter = require("app/lib/lookup/util/lookupChapter")
local lookupVerse   = require("app/lib/lookup/util/lookupVerse")

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
				local verseRange = STRING_UTIL:split(requestPart.verse, "-")
				local fromVerse = verseRange[1]
				local toVerse   = verseRange[2] or fromVerse

				local chapterData = lookupChapter(params.bookData, requestPart.chapter)
				resultPart.verseCount = chapterData.verseCount
				
				for verseNum = tonumber(fromVerse), tonumber(toVerse) do
					local dstVersePart = {
						verse = verseNum,
					}

					local verseData   = lookupVerse(chapterData, verseNum)
					for _, srcVersePart in ipairs(verseData) do
						table.insert(dstVersePart, srcVersePart)
					end

					table.insert(resultPart, dstVersePart)
				end

			end

			table.insert(result, resultPart)
		end

		params.result = result
		return params
	end,

}
