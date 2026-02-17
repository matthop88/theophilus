return function(bookData, chapterNum)
	for _, c in ipairs(bookData.chapters) do
		if c.chapter == chapterNum then
			return c
		end
	end
end
				
