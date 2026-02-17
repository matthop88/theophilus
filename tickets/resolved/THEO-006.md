# THEO-006
## Verse Lookup

Type: STORY

### Description:
Inside the app/lib/lookup directory, there should be a verseLookup.lua.

This takes the following parameters:
1. bookData
2. request (formerly known as body)

It expands the request into verses as follows:

GIVEN:
{ 
	book         = "Ephesians", 
	chapterCount = 6, 
	passage      = "1:22-23", 
	request      = { 
		{ 
			chapter = 1, 
			verse   = "22-23",
		},
	},
	bookData     = (BOOK_DATA),
}

RETURNS:
{ 
	book         = "Ephesians", 
	chapterCount = 6, 
	passage      = "1:22-23", 
	request      = { 
		{ 
			chapter = 1, 
			verse   = "22-23",
		},
	},
	result       = {
		{	chapter    = 1,
			verseCount = 23,
			{	verse  = 22,
				{
					"And He put all things in subjection under His feet,",
                    "and gave Him as head over all things to the church,", 
				},  
			},
			{	verse  = 23,
				{
					"which is His body, the fullness of Him who fills all in all.", 
				}
			},
		}
	},
	bookData     = (BOOK_DATA),
}

If there are missing verses, it looks like the following:

GIVEN:
{ 
	book         = "Ephesians", 
	chapterCount = 6, 
	passage      = "1:3-12", 
	request      = { 
		{ 
			chapter = 1, 
			verse   = "3-12",
		},
	},
	bookData     = (BOOK_DATA),
}

RETURNS:
{ 
	book         = "Ephesians", 
	chapterCount = 6, 
	passage      = "1:3-12", 
	request      = { 
		{ 
			chapter = 1, 
			verse   = "3-12",
		},
	},
	result       = {
		{	chapter    = 1,
			verseCount = 23,
			{	verse = 3,
				{
					"Blessed be the God and Father of our Lord Jesus Christ,",
                    "who has blessed us with every spiritual blessing in the heavenly places in Christ,",
				},
			},
			{	warning = "The following verses are missing: Ephesians 1:4-7"    },
			{	verse = 8,
				{
					"which He lavished on us.",
                    "In all wisdom and insight",
				},
			},
			{	warning = "The following verses are missing: Ephesians 1:9-11"    },
			{	verse = 12,
				{
					"to the end that we who were the first to hope in Christ would be to the praise of His glory." 
				},
			},
		},
	},
	bookData     = (BOOK_DATA),
}


### Acceptance Criteria:
- [X] Body renamed to request
- [X] Error progagation, with tests
- [X] Results for verse lookup, with tests
- [X] Results for missing verses, with tests
- [X] Integrate into main interface
- [X] Bonus: Specify version in as quoted cmd line argument

**Story Points**: 2 <br/>
**Resolution**: RESOLVED <br/>
**Sprint**: FY26 Q1 Sprint 4 <br/>

**Dates**: <br/>
**Created**: 02/10/26 1:38 pm <br/>
**Completed**: 02/17/26 11:08 sm <br/>
