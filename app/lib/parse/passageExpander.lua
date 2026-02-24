STRING_UTIL = require("app/lib/util/stringUtil")

--[[
Takes a parameter list consisting of:
1. Book Name     (String)
2. Passage       (String, possibly colon and hyphen delimited)
3. Chapter Count (Number)

If the parameter list contains an ERROR, the parameter list is returned as is.

The parameter list is modified in place; the string passage is preserved, but a new parameter (request) is added.

request = {
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
		return { startValue = range[1], endValue = range[2], extra = range[3] }
	end
end

local parseHM = function(h)
	local hm = STRING_UTIL:split(h, ":")
	if #hm == 1 then
		return { v = hm[1] }
	else
		return { h = hm[1], m = hm[2], x = hm[3] }
	end
end

local parsePassage = function(p)
	local range = parseRange(p)
	
	local startPosition = parseHM(range.startValue)
	local startingChapter, startingVerse
	if startPosition.v then startingChapter = startPosition.v
	else                    startingChapter, startingVerse = startPosition.h, startPosition.m end

	local endPosition = parseHM(range.endValue)
	if endPosition == nil then endPosition = startPosition end

	local endingChapter, endingVerse
	if endPosition.v then 
		if startPosition.v then endingChapter = endPosition.v
		else                    endingChapter, endingVerse = startingChapter, endPosition.v end
	else                  
		endingChapter, endingVerse = endPosition.h, endPosition.m 
	end

	local result =  { 
		startingChapter = startingChapter,
		startingVerse   = startingVerse,
		endingChapter   = endingChapter,
		endingVerse     = endingVerse,
	}

	if range.extra or startPosition.x or endPosition.x then
		result.error = "INVALID RANGE: " .. p
	end

	return result
end

local validateChapterRange = function(data)
	if not data.error then
		local missingChapterRange = { lo = nil, hi = nil }

		for _, chapterVerse in ipairs(data.request) do
			if chapterVerse.chapter > data.chapterCount then
				if missingChapterRange.lo == nil then missingChapterRange.lo = chapterVerse.chapter end
				missingChapterRange.hi = chapterVerse.chapter
			end
		end

		if missingChapterRange.lo ~= nil then
			if missingChapterRange.lo == missingChapterRange.hi then
				data.error = "INVALID CHAPTER: " .. missingChapterRange.lo
			else
				data.error = "INVALID CHAPTERS: " .. missingChapterRange.lo .. "-" .. missingChapterRange.hi
			end
			data.request = nil
		end
	end

	return data
end

return {
	execute = function(self, params)
		if params.error then
			return params
		else
			local result   = params
			local passage  = params.passage or "1-" .. params.chapterCount
			result.passage = passage
			local passageAttributes = parsePassage(passage)
			if passageAttributes.error then
				result.error = passageAttributes.error
			else
				if params.chapterCount == 0 then
					if passageAttributes.startingVerse or passageAttributes.endingVerse then
						result.error = "INVALID RANGE: " .. passage .. " not applicable for chapterless volume"
					else
						result.request = { { chapter = 0, verse = passage } }
					end
				else
					local startingChapterNum = tonumber(passageAttributes.startingChapter)
					local endingChapterNum   = tonumber(passageAttributes.endingChapter)

					local startingVerseNum = tonumber(passageAttributes.startingVerse)
					local endingVerseNum   = tonumber(passageAttributes.endingVerse)

					if   startingChapterNum == nil or endingChapterNum == nil 
					  or (startingVerseNum == nil and passageAttributes.startingVerse ~= nil)
					  or (endingVerseNum   == nil and passageAttributes.endingVerse   ~= nil) then
						result.error = "INVALID VALUE in passage: " .. passage
					elseif startingChapterNum > endingChapterNum then
						result.error = "INVALID RANGE: " .. startingChapterNum .. "-" .. endingChapterNum
					else
						if startingVerseNum == nil then startingVerseNum = 1 end
						if endingVerseNum   == nil then endingVerseNum = "?" end

						result.request = {}
						for i = startingChapterNum, endingChapterNum do
							local s, e = 1, "?"
							if i == startingChapterNum then s = startingVerseNum end
							if i == endingChapterNum   then e = endingVerseNum   end

							local verse = "" .. s .. "-" .. e
							if s == e then verse = "" .. s end
							table.insert(result.request, { chapter = i, verse = verse })
						end
					end
				end
			end

			return validateChapterRange(result)
		end
	end,
}
