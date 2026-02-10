local DISCOVER_TEST_CLASSES   = require("test/framework/discovery/discoverTestClasses")
local DISCOVER_TEST_FUNCTIONS = require("test/framework/discovery/discoverTestFunctions")

local printCaption = function(str)
    print("\n" .. str .. "\n" .. string.rep("-", string.len(str)))
end

local printBanner = function(str)
    local asteriskStr = string.rep("*", string.len(str) + 12)
    print(asteriskStr)
    print("***   " .. str .. "   ***")
    print(asteriskStr)
end

local testClasses = DISCOVER_TEST_CLASSES()

print()

local totalSuccessfulTests, totalTestCount = 0, 0

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
    totalSuccessfulTests = totalSuccessfulTests + successfulTests
    totalTestCount       = totalTestCount       + testCount

    if #failedTests > 0 then
        printCaption("The following tests have failed:")
        for n, t in ipairs(failedTests) do
            print(n .. ". " .. t)
        end
    end
end

print()
printBanner("Total Tests Succeeded: " .. totalSuccessfulTests .. " Out Of " .. totalTestCount)
print()

if totalSuccessfulTests ~= totalTestCount then
    print("DANGER: THERE ARE " .. (totalTestCount - totalSuccessfulTests) .. " FAILING TESTS!")
    print()
end

love.event.quit()
