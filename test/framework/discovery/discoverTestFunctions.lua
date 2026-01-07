return function(testsClass)
    local testFunctions = {}
    
    for testName, fn in pairs(testsClass) do
        if type(fn) == "function" and testName:sub(1, 4) == "test" then
            testFunctions[testName] = fn
        end
    end

    return testFunctions
end
    
