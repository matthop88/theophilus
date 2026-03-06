local MINUTE = 60
local HOUR   = 60 * MINUTE
local DAY    = 24 * HOUR
local WEEK   =  7 * DAY
local MONTH  = 30 * DAY

return {
    [1]  =  1 * HOUR,
    [2]  =  2 * HOUR,
    [3]  =  4 * HOUR,
    [4]  = 12 * HOUR,
    [5]  =  1 * DAY,
    [6]  =  2 * DAY,
    [7]  =  4 * DAY,
    [8]  =  1 * WEEK,
    [9]  =  2 * WEEK,
    [10] =  1 * MONTH,
    [11] =  2 * MONTH,
    [12] =  3 * MONTH,
    [13] =  4 * MONTH,
    [14] =  6 * MONTH,
    [15] =  1 * (12 * MONTH),
}
