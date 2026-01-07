require("app/main")

local DISCOVER_TEST_CLASSES   = require("test/framework/discovery/discoverTestClasses")
local DISCOVER_TEST_FUNCTIONS = require("test/framework/discovery/discoverTestFunctions")

local testClasses = DISCOVER_TEST_CLASSES()

for n, testClass in ipairs(testClasses) do
    print(n .. ": " .. testClass:getName())

    local testFunctions = DISCOVER_TEST_FUNCTIONS(testClass)
    for k, v in pairs(testFunctions) do
        print("  " .. k)
    end 
end
