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

        local files = LOOKUP_FILES("data/scriptures/newTestament")
        
        for _, file in ipairs(files) do
            print(file)
        end
        
        return ASSERT_EQUALS(name, #files, 2)
    end,
}
            
        
