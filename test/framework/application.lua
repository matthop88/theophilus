local DISCOVER_TEST_CLASSES   = require("test/framework/discovery/discoverTestClasses")
local DISCOVER_TEST_FUNCTIONS = require("test/framework/discovery/discoverTestFunctions")

local printCaption = function(str)
    print("\n" .. str .. "\n" .. string.rep("-", string.len(str)))
end

local testClasses = DISCOVER_TEST_CLASSES()

print()

for n, testClass in ipairs(testClasses) do
    printCaption(testClass:getName())

    local testFunctions = DISCOVER_TEST_FUNCTIONS(testClass)
    local testCount, successfulTests = 0, 0
    for testName, testFn in pairs(testFunctions) do
        testCount = testCount + 1
        local status, err = pcall(function() testFn(testClass) end)
        if status == true then
            successfulTests = successfulTests + 1
        else
            print()
            print("FAILED => " .. testName)
            print("          WITH ERROR: " .. err)
            print()
        end
    end 

    print()
    print("Tests succeeded: " .. successfulTests .. " out of " .. testCount)
end

print()

love.event.quit()
