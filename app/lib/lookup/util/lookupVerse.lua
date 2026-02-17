return function(chapterData, verseNum)
	for _, v in ipairs(chapterData.verses) do
		if v.verse == verseNum then
			return v
		end
	end
end
