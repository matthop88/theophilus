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
    for testName, testFn in pairs(testFunctions) do
        local status, err = pcall(function() testFn(testClass) end)
        if status ~= true then
            print()
            print("FAILED => " .. testName)
            print("          WITH ERROR: " .. err)
            print()
        end
    end 
end

print()

love.event.quit()
