local LOOKUP_FILES  = require("app/lib/lookup/util/lookup")
local ASSERT_EQUALS = require("test/framework/assert/assertEquals")

return {
    getName = function(self) 
        return "File Lookup tests"
    end,

    beforeAll = function(self)
        -- Do nothing
    end,

    before = function(self)
        -- Do nothing
    end,

    testLookupNewTestamentFiles = function(self)
        local name = "New Testament File Lookup"

        local dataObjs = LOOKUP_FILES("data/scriptures/newTestament")
        
        local resultString = "File Count: " .. #dataObjs .. ", book = { " .. dataObjs[1].book .. ", " .. dataObjs[2].book .. ", " .. dataObjs[3].book .. " }, version = { " .. dataObjs[1].version .. ", " .. dataObjs[2].version .. ", " .. dataObjs[3].version .. " }"
        return ASSERT_EQUALS(name, #dataObjs, 3)
    end,

    testLookupNewTestamentPhilippiansFiles = function(self)
        local name = "New Testament Philippians Lookup"

        local dataObjs = LOOKUP_FILES("data/scriptures/newTestament", function(data) return data.book == "Philippians" end)
        
        local resultString = "File Count: " .. #dataObjs .. ", book = { " .. dataObjs[1].book .. ", " .. dataObjs[2].book .. " }, version = { " .. dataObjs[1].version .. ", " .. dataObjs[2].version .. " }"
        return ASSERT_EQUALS(name, resultString, "File Count: 2, book = { Philippians, Philippians }, version = { KJV, NASB 95 }")
    end,

    testLookupNewTestamentPhilippiansNASB95Files = function(self)
        local name = "New Testament Philippians NASB 95 Lookup"

        local dataObjs = LOOKUP_FILES("data/scriptures/newTestament", function(data) return data.book == "Philippians" and data.version == "NASB 95" end)
        
        local resultString = "File Count: " .. #dataObjs .. ", book = " .. dataObjs[1].book .. ", version = " .. dataObjs[1].version
        return ASSERT_EQUALS(name, resultString, "File Count: 1, book = Philippians, version = NASB 95")
    end,
}
            
        
