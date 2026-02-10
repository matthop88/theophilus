# THEO-004
## Verse Expansion

Type: STORY

### Description:
Inside app/lib/parse, we have verseExpander.lua.
It does the following:

Takes a parameter list consisting of bookData and body.

For each chapter/verse block in body:
1. If chapter is not in dataset, adds a warning to the block saying that the chapter is missing.
2. If chapter exists, replaces all ending wildcards in verse range with the number of verses.
3. If any of the verses are out of range, creates an error block in the outermost scope, which details all invalid chapter/verse combinations.

Example #1:
{
  body = {
    {
      verse = "8-9",
      chapter = 2,
    },
  },
  book = "Ephesians",
  passage = "2:8-9",
  chapterCount = 6,
  bookData = "(BOOK DATA)",
  version = "NASB 95",
}

If Ephesians Chapter 2 is missing from dataset, result will be:

{
  body = {
    {
      verse = "8-9",
      chapter = 2,
      warning = "Ephesians Chapter 2 is missing from the dataset.",
    },
  },
  book = "Ephesians",
  passage = "2:8-9",
  chapterCount = 6,
  bookData = "(BOOK DATA)",
  version = "NASB 95",
}

Example #2:
{
  book = "Philippians",
  passage = "1-2:5",
  chapterCount = 4,
  version = "KJV",
  bookData = "(BOOK DATA)",
  body = {
    {
      verse = "1-?",
      chapter = 1,
    },
    {
      verse = "1-5",
      chapter = 2,
    },
  },
}

If chapter 1 is in the dataset, result will be 

{
  book = "Philippians",
  passage = "1-2:5",
  chapterCount = 4,
  version = "KJV",
  bookData = "(BOOK DATA)",
  body = {
    {
      verse = "1-30",
      chapter = 1,
    },
    {
      verse = "1-5",
      chapter = 2,
    },
  },
}

Here, the wildcard in verse (1-?) for the 1st chapter is resolved to 1-30.

Example #3:
{
  book = "Philippians",
  passage = "1:39-2:35",
  chapterCount = 4,
  version = "KJV",
  bookData = "(BOOK DATA)",
  body = {
    {
      verse = "39-?",
      chapter = 1,
    },
    {
      verse = "1-35",
      chapter = 2,
    },
  },
}

If both Philippians chapter 1 and 2 are intact in the dataset, result will be

{
  book = "Philippians",
  passage = "1:39-2:35",
  chapterCount = 4,
  version = "KJV",
  bookData = "(BOOK DATA)",
  body = {
    {
      verse = "39-30",
      chapter = 1,
    },
    {
      verse = "1-35",
      chapter = 2,
    },
  },
  error = "The following verses are out of range: Philippians 1:39, Philippians 2:31-35",
}

### Acceptance Criteria:
- [X] Verse Expander implemented, propagates errors
- [X] Test for error propagation
- [X] Implement addition of warnings for missing chapters
- [X] Test for 1 warning
- [X] Verse Expander fills in wildcards
- [X] Test for 1 wildcard
- [X] Test for multiple wildcards
- [X] Test for multiple warnings
- [X] Verse Expander adds error
- [X] Test for 1 error, single verse
- [X] Test for 1 error, multiple verses
- [X] Test for multiple errors
- [X] Integrated into main interface


**Story Points**: 2 <br/>
**Resolution**: RESOLVED <br/>
**Sprint**: FY26 Q1 Sprint 3 <br/>

**Dates**: <br/>
**Created**: 02/04/26 11:34 am <br/>
**Completed**: 02/09/26 04:35 pm <br/>
