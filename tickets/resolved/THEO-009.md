# THEO-009
## Scripture Cloaking Program

Type: STORY

### Description:
The goal of this ticket is to create a new application, which can be executed as follows:

love . CLOAK Ephesians 2:8-9 level=n

This will run the BIBLE app, but instead of printing the scripture to the screen, it first processes the text using level=n as a filter.
n indicates the maximum word size that is filtered out. By "filtered out", I mean, replaced by underscores.
When level=0, no change is made to the text.

Example:

love . CLOAK Philippians 1:1-6 "NASB 95" level=3

Result:

Philippians 1:1-6 (NASB 95)
---------------------------

	Philippians 1
	-------------
	1 Paul ___ Timothy, bond-servants __ Christ Jesus,
	__ ___ ___ saints __ Christ Jesus ___ ___ __ Philippi,
	including ___ overseers ___ deacons:

	2 Grace __ ___ ___ peace from ___ ___ Father ___ ___ Lord Jesus Christ.

	3 _ thank __ God __ ___ __ remembrance __ ___,
	4 always offering prayer with ___ __ __ every prayer ___ ___ ___,
	5 __ view __ your participation __ ___ gospel from ___ first ___ until ___.

	6 ___ _ __ confident __ this very thing,
	that __ ___ began _ good work __ ___ will perfect __ until ___ ___ __ Christ Jesus.

	Philippians 1:1-6 (NASB 95)

Please note that the title of the book and passage is not affected by the filter.
In addition, punctuation is never filtered out; word length is calculated treating the punctuation as if it doesn't exist.
For example: "now," qualifies as 3 characters, and the filtered result is "___," (see verse 5 above.)

### Acceptance Criteria:
- [X] Bible app refactored so that there is a function that can be called programmatically to return a passage of scripture, and a callable application which utilizes said function and prints it to the screen.
- [X] Working algorithm for filtering words in a string based upon word length; maximum word length for filtering is parameterizable.
- [X] Unit tests written for the filtering algorithm above.
- [X] Transformation function which takes scripture passage and filters the verses accordingly using the above algorithm.
- [X] Unit tests written for the transformation function above.
- [X] CLOAK application written which, given a scripture passage and a level, prints out the filtered passage on the screen based upon the level provided

**Story Points**: 3 <br/>
**Resolution**: RESOLVED <br/>
**Sprint**: FY26 Q1 Sprint 5 <br/>

**Dates**: <br/>
**Created**: 03/06/26 02:21 pm <br/>
**Completed**: 03/06/26 03:02 pm <br/>
