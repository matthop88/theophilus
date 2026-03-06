# THEO-008
## Scripture Scheduling Program

Type: STORY

### Description:
Given a file listing Scriptures:
    {
      "Ephesians 2:8-9",
      "Deuteronomy 6:5-7",
      "Romans 12:1-2",
    }

Running the scheduling program will execute the BIBLE program, printing out the scripture for each entry in turn.
The program will keep track of timestamps and continually select the scripture that was accessed least recently.

Two other applications, SUCCESS and FAIL, send feedback.

A success causes a scripture to move to a higher rung (lower frequency).
Each scripture has a next date associated with it.

The frequency intervals are:
1. 1 hour
2. 2 hours
3. 4 hours
4. 12 hours
5. 1 day
6. 2 days
7. 4 days
8. 1 week
9. 2 weeks
10. 1 month
11. 2 months
12. 3 months
13. 4 months
14. 6 months
15. 1 year

A single failure causes a scripture to drop to the highest frequency (starting over).

### Acceptance Criteria:
- [X] Program reads 1st entry in file and displays that scripture
- [ ] Program generates a data tracking file from file and displays most recent scripture not used.
- [ ] Program updates tracking file dynamically.
- [ ] Program generates a nextDate which is always 1 minute ahead.
- [ ] SUCCESS and FAIL apps. SUCCESS does nothing, but FAIL sets nextDate to be immediate.
- [ ] Track level
- [ ] SUCCESS increments level. FAIL sets level back to first
- [ ] Frequency is a function of level.

**Story Points**: 3 <br/>
**Resolution**: UNRESOLVED <br/>
**Sprint**: FY26 Q1 Sprint 5 <br/>

**Dates**: <br/>
**Created**: 03/04/26 10:42 am <br/>
**Completed**: --/--/-- --:-- -m <br/>
