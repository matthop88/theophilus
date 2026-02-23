local printError = function(errorMessage)
	print("\nERROR: " .. errorMessage .. "\n")
end

local STRING_UTIL         = require("app/lib/util/stringUtil")
local BOOK_NAME_EXTRACTOR = require("app/lib/parse/bookNameExtractor")
local BOOK_META_LOOKUP    = require("app/lib/lookup/bookMetaLookup")
local PASSAGE_EXPANDER    = require("app/lib/parse/passageExpander")
local VERSE_EXPANDER      = require("app/lib/parse/verseExpander")
local VERSE_LOOKUP        = require("app/lib/lookup/verseLookup")

local displayTable        = require("app/lib/display/displayTable")
local displayCaption      = require("app/lib/display/displayCaption")

local parseResult         = BOOK_NAME_EXTRACTOR:execute { args = __ARGS }
local lookupResult        = BOOK_META_LOOKUP:execute(parseResult)
local expandPassageResult = PASSAGE_EXPANDER:execute(lookupResult)
local expandVerseResult   = VERSE_EXPANDER:execute(expandPassageResult)
local lookupVerseResult   = VERSE_LOOKUP:execute(expandVerseResult)

local result = lookupVerseResult
if result.bookData then result.bookData = "(BOOK DATA)" end

--[[
Here is what we want to see:

Philippians 1:1-6 (NASB 95)
---------------------------

Philippians 1
-------------
1 Paul and Timothy, bond-servants of Christ Jesus,
To all the saints in Christ Jesus who are in Philippi,
including the overseers and deacons:

2 Grace to you and peace from God our Father and the Lord Jesus Christ.

3 I thank my God in all my remembrance of you,
4 always offering prayer with joy in my every prayer for you all,
5 in view of your participation in the gospel from the first day until now.

6 For I am confident of this very thing,
that He who began a good work in you will perfect it until the day of Christ Jesus.

Philippians 1:1-6 (NASB 95)

Note: There are line breaks after periods, exclamation marks, question marks and colons.

TODO: I would like there to be more specificity given to the verses asked for.
For instance, when I request "Philippians",
it should respond "Philippians 1-4", showing that it is trying to give us all 4 chapters.
]]

if result.error then
	printError(result.error)
else
	local reference = result.book .. " " .. result.passage .. " (" .. result.version .. ")"
	displayCaption(reference)

	for _, ch in ipairs(result.result) do
		displayCaption(result.book .. " " .. ch.chapter)

		for _, v in ipairs(ch) do
			if v.warning then
				print("\nWARNING: " .. v.warning .. "\n")
			else
				for n, s in ipairs(v) do
					local ss = s
					if   STRING_UTIL:endsWith(s, ".")
					  or STRING_UTIL:endsWith(s, "?")
					  or STRING_UTIL:endsWith(s, "!")
					  or STRING_UTIL:endsWith(s, ":")
					then
						ss = ss .. "\n"
					end

					if n == 1 then print(v.verse .. " " .. ss)
					else print(ss)                         end
				end
			end
		end
	end

	print("\n" .. reference .. "\n")
end

love.event.quit()
