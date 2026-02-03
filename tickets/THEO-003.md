# THEO-003
## Passage Expansion

Type: STORY

### Description:
Inside app/lib/parse, we have a passageExpander.lua. It does the following:

Takes a parameter list consisting of a book name, passage, and chapterCount.
1. If passage doesn't exist, expansion looks like the following:
{ body = {
   {  chapter = 1,
      verse   = "1-?",
   },
   {  chapter = 2,
      verse   = "1-?",
   },
   ... etc (for however many chapters there are in the book)
}}
2. If passage exists and is on a chapter level, it looks very similar:
e.g. passage = "2-3"
{ body = {
   {  chapter = 2,
      verse   = "1-?",
   },
   {  chapter = 3,
      verse   = "1-?",
   },
}}
NOTE: A book like Jude doesn't have chapters. Its chapter count is 0. In this case, a passage like 2-3 would be interpreted as:
{ body = {
   {  chapter = 0,
      verse   = "2-3",
   },
}}
3. If a passage exists and spans multiple chapters, it looks like this:
e.g. passage = "2:3-4:2"
{ body = {
   {  chapter = 2,
      verse   = "3-?",
   },
   {  chapter = 3,
      verse   = "1-?",
   },
   {  chapter = 4,
      verse   = "1-2",
   },
}}
4. The easiest scenario, obviously, is a specific passage that takes place in a single chapter.
e.g. passage = "3:16-17" 
{ body = {
   {  chapter = 3,
      verse   = "16-17",
   },
}}

The passage expander also validates whether the passages are in bounds (chapter-wise, anyway.)

If chapters are out of bounds, this error is added to the mix:

error = { CHAPTERS_NOT_FOUND { book = "{Book Name}", chapters = "x-y" } }

### Acceptance Criteria:
- [X] Error propagation
- [X] Expand passage with single chapter, no verses specified
- [X] Expand passage with single 'chapter' for 0-chapter volume
- [X] Corner case: single chapter w.o. verses, invalid number
- [X] Expand passage with range of chapters, no verses specified
- [X] Expand passage with range of 'chapters' for 0-chapter volume
- [X] Corner case: chapter range w.o. verses, invalid number as part of range
- [X] Expand passage when no passage is specified
- [X] Expand passage when no passage is specified for 0-chapter volume
- [X] Corner case: error when range makes no sense (i.e., 3:16-17-18, 3:17-16)
- [X] Expand passage with single chapter and 1 verse
- [X] Corner case: single chapter and 1 verse, invalid number specified
- [X] Expand passage with single chapter and multiple verses
- [ ] Corner case: single chapter and multiple verses, invalid number specified
- [ ] Expand passage with range spanning multiple chapters
- [ ] Chapter not found for a single chapter specified
- [ ] Chapter not found for 0-chapter volume
- [ ] Chapter not found for range of chapters
- [ ] Chapter not found for range spanning multiple chapters

**Story Points**: 2 <br/>
**Resolution**: UNRESOLVED <br/>
**Sprint**: FY26 Q1 Sprint 3 <br/>

**Dates**: <br/>
**Created**: 01/29/26 10:04 am <br/>
**Completed**: --/--/-- --:-- -m <br/>
