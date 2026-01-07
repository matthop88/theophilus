local DISCOVER_TEST_CLASSES   = require("test/framework/discovery/discoverTestClasses")
local DISCOVER_TEST_FUNCTIONS = require("test/framework/discovery/discoverTestFunctions")

local printCaption = function(str)
    print(str .. "\n" .. string.rep("-", string.len(str)))
end

local testClasses = DISCOVER_TEST_CLASSES()

print("\n")

for n, testClass in ipairs(testClasses) do
    printCaption(testClass:getName())

    local testFunctions = DISCOVER_TEST_FUNCTIONS(testClass)
    for testName, testFn in pairs(testFunctions) do
        testFn(testClass)
    end 
end

love.event.quit()
