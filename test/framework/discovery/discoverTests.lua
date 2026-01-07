return function()
    local testClasses = {}

    local testFilenames = love.filesystem.getDirectoryItems("test/tests")
    for _, testFilename in ipairs(testFilenames) do
        local keyName = string.sub(testFilename, 1, string.len(testFilename) - 4)
        local filePath = "test/tests/" .. keyName

        table.insert(testClasses, require(filePath))
    end

    return testClasses
end
