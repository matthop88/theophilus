# THEO-001
## Book Name Extractor

Type: STORY

### Description:
Inside app/lib/parse, we have a bookNameExtractor.lua. It does the following:

1. Takes an argument list as a single parameter: args = { a, b, c, etc. }
2. If the first arg is a number, book name is concatenated from the first 2 args. Otherwise, book name is the 1st arg.
3. Passage is either the 2nd or 3rd arg, depending upon how book name is constructed.
4. Data format is as follows (this is for the example BOOK_NAME_EXTRACTOR:execute { args = { "1", "John", "3:16" } })
   { book    = "1 John",
     passage = "3:16",
   }
5. If there are not enough arguments to construct a book name, returns an error in the following format:
   { error = INSUFFICIENT_ARGUMENTS(args) }

To test this, we need a testing framework, which should test book names of 1 and 2 argument size, as well as the insufficient arguments error.

### Acceptance Criteria:
- [X] Testing Framework written
- [X] Code in outer main to run tests
- [X] Test for 1 argument book name passes
- [X] Test for 2 argument book name passes
- [X] Test for 0 argument book name passes (error test)
- [ ] Test for 1 argument book name passes (where argument 1 is a number; error test)
- [ ] Code in main to parse arguments and return the book and passage data structure

**Story Points**: 3 <br/>
**Resolution**: UNRESOLVED <br/>
**Sprint**: FY26 Q1 Sprint 1 <br/>

**Dates**: <br/>
**Created**: 01/06/26 03:58 pm <br/>
**Completed**: --/--/-- --:-- -m <br/>
