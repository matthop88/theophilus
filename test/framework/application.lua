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
    local failedTests = {}
    for testName, testFn in pairs(testFunctions) do
        testCount = testCount + 1
        local testResult = nil
        local status, err = pcall(function() testResult = testFn(testClass) end)
        if status ~= true then
            table.insert(failedTests, testName)
            print()
            print("FAILED => " .. testName)
            print("          WITH ERROR: " .. err)
            print()
        end
        if testResult then 
            if testResult.succeeded then successfulTests = successfulTests + 1
            else                         table.insert(failedTests, testResult.name)  end
        end
    end 

    print()
    print("Tests succeeded: " .. successfulTests .. " out of " .. testCount)
    if #failedTests > 0 then
        print()
        print("The following tests have failed:")
        print("--------------------------------")
        for n, t in ipairs(failedTests) do
            print(n .. ". " .. t)
        end
    end
end

print()

love.event.quit()
