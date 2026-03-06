# THEO-010
## Enhancement to SCHEDULE program to incorporate cloaking

Type: STORY

### Description:
The SCHEDULE app now calls the CLOAK app instead of the BIBLE app.

In addition to the level stored in the trackingData file, we also need to store a filter field, which keeps track of the filter level for the CLOAK app. The filter level starts at 0.

Entries in the frequency table based upon level should now read as follows:
1. 1 minute
2. 2 minutes
3. 5 minutes
4. 10 minutes
5. 15 minutes
6. 30 minutes
7. 1 hour
8. 2 hours
9. 4 hours
10. 8 hours
11. 12 hours
12. 24 hours
13. 2 days
14. 3 days
15. 5 days
16. 7 days
17. 2 weeks
18. 4 weeks
19. 2 months
20. 3 months
21. 4 months
22. 6 months
23. 9 months
24. 1 year

Level should increase with calling of the SUCCESS app as before.

The filter field never automatically increases. However, there is a command line parameter for SUCCESS, "plus", which increases the value of the filter field.
For instance,

love . SUCCESS plus=1

increases the value of the filter field of the selected scripture by 1.
If the plus parameter is specified, the level field is NOT bumped up to the next level.

If the FAIL application is called, the filter field is decreased by 1 only if the nextDate of the scripture is already 0.

### Acceptance Criteria:
- [ ] SCHEDULE app calls CLOAK app (with a parameter of "level=0")
- [ ] Frequency table updated
- [ ] Filter fields are automatically added to the trackingData file with a value of 0 if they do not exist.
- [ ] Value of filter field is utilized when calling CLOAK
- [ ] "plus" command-line parameter added to SUCCESS
- [ ] FAIL application updated to decrease filter field by 1 if nextDate of scripture is already 0

**Story Points**: 2 <br/>
**Resolution**: UNRESOLVED <br/>
**Sprint**: FY26 Q1 Sprint 5 <br/>

**Dates**: <br/>
**Created**: 03/06/26 03:20 pm <br/>
**Completed**: --/--/-- --:-- -m <br/>
