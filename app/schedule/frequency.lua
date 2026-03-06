local MINUTE = 60
local HOUR   = 60 * MINUTE
local DAY    = 24 * HOUR
local WEEK   =  7 * DAY
local MONTH  = 30 * DAY

return {
    [1]  =  1 * MINUTE,
    [2]  =  2 * MINUTE,
    [3]  =  5 * MINUTE,
    [4]  = 10 * MINUTE,
    [5]  = 15 * MINUTE,
    [6]  = 30 * MINUTE,
    [7]  =  1 * HOUR,
    [8]  =  2 * HOUR,
    [9]  =  4 * HOUR,
    [10] =  8 * HOUR,
    [11] = 12 * HOUR,
    [12] = 24 * HOUR,
    [13] =  2 * DAY,
    [14] =  3 * DAY,
    [15] =  5 * DAY,
    [16] =  1 * WEEK,
    [17] =  2 * WEEK,
    [18] =  4 * WEEK,
    [19] =  2 * MONTH,
    [20] =  3 * MONTH,
    [21] =  4 * MONTH,
    [22] =  6 * MONTH,
    [23] =  9 * MONTH,
    [24] = 12 * MONTH,
}
