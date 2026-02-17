local STRING_UTIL = require("app/lib/util/stringUtil")

local lookupChapter = require("app/lib/lookup/util/lookupChapter")
local lookupVerse   = require("app/lib/lookup/util/lookupVerse")

local MISSING_VERSES = {
	fromVerse = nil,
	toVerse   = nil,

	add = function(self, verseNum)
		if self.fromVerse == nil then
			self.fromVerse = verseNum
		end
		self.toVerse = verseNum
	end,

	hasData = function(self)
		return self.fromVerse ~= nil
	end,

	clear = function(self)
		self.fromVerse = nil
		self.toVerse   = nil
	end,

	toString = function(self, bookName, chapterNum)
		if self.fromVerse == self.toVerse then
			return "The following verse is missing: " .. bookName .. " " .. chapterNum .. ":" .. self.fromVerse
		else
			return "The following verses are missing: " .. bookName .. " " .. chapterNum .. ":" .. self.fromVerse .. "-" .. self.toVerse
		end
	end, 
}

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
				
				MISSING_VERSES:clear()

				for verseNum = tonumber(fromVerse), tonumber(toVerse) do
					local dstVersePart = {
						verse = verseNum,
					}

					local verseData   = lookupVerse(chapterData, verseNum)
					if verseData == nil then
						MISSING_VERSES:add(verseNum)
					else
						if MISSING_VERSES:hasData() then
							table.insert(resultPart, { warning = MISSING_VERSES:toString(params.book, requestPart.chapter) })
							MISSING_VERSES:clear()
						end
						for _, srcVersePart in ipairs(verseData) do
							table.insert(dstVersePart, srcVersePart)
						end
						table.insert(resultPart, dstVersePart)
					end
				end

				if MISSING_VERSES:hasData() then
					table.insert(resultPart, { warning = MISSING_VERSES:toString(params.book, requestPart.chapter) })
					MISSING_VERSES:clear()
				end

			end

			table.insert(result, resultPart)
		end

		params.result = result
		return params
	end,

}
