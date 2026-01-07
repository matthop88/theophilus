# THEO-002
## Book Meta Lookup

Type: STORY

### Description:
Inside app/lib/lookup, we have a bookLookup.lua. It does the following:

1. Takes a parameter list consisting of a book name and an optional version.
2. Looks up the book among all of the subdirectories in the data directory. There is no specific naming convention required; instead, it looks into the lua data files for the "book" parameter for its comparison.
3. Returns the following response:
   { book = "Genesis", bookData = (data object), version = (versionFound) }
4. If version is specified, will look for the version requested. If unable to find version, it returns the last successful book result.
5. If unable to find the book, the bookData will be nil (as well as the version.)

In addition, we have a bookMetaLookup.lua. This is a wrapper for bookLookup, and does the following:

1. Takes a parameter list consisting of a book name, passage and optional version.
2. Uses bookLookup to look up based upon book name and version.
3. If book isn't found, response is:
   { book = "Genesis", bookData = nil, error = { BOOK_NOT_FOUND { book = "Genesis" } }, }
4. If book is found, response is:
   { book = "Genesis", bookData = (data object), version = (versionFound), chapterCount = 50, passage = "1:1," }
5. If version isn't found, response is the same, but the following field is added:
   warning = VERSION_NOT_FOUND { book = "Genesis", requested = "NIV", found = "NASB 95" },

Important: both bookLookup and bookMetaLookup should be able to handle data structures with an error, in which case they simply return the data structure.

### Acceptance Criteria:
- [ ] Code to find a book written and tested
- [ ] Philippians data added with a different version
- [ ] Code to find a book with specific version written and tested
- [ ] bookLookup code with happy path 1 (only book name requested)
- [ ] bookLookup code with happy path 2 (book name and version requested)
- [ ] bookLookup code with happy path 3 (book name and unfindable version requested)
- [ ] bookLookup code with sad   path 1 (unfindable book name requested)
- [ ] bookLookup code with sad   path 2 (handed a data structure with an error)
- [ ] bookMetaLookup code, happy path 1 (only book name requested)
- [ ] bookMetaLookup code, happy path 2 (book name and version requested)
- [ ] bookMetaLookup code, warn  path   (book name and unfindable version requested)
- [ ] bookMetaLookup code, sad   path 1 (unfindable book name requested)
- [ ] bookMetaLookup code, sad   path 2 (handed a data structure with an error)
- [ ] Code in main to utilize bookMetaLookup. Awesome stuff!

**Story Points**: 3 <br/>
**Resolution**: UNRESOLVED <br/>
**Sprint**: FY26 Q1 Sprint 1 <br/>

**Dates**: <br/>
**Created**: 01/07/26 11:46 am <br/>
**Completed**: --/--/-- --:-- -m <br/>
