require("app/main")

local DISCOVER_TESTS = require("test/framework/discovery/discoverTestClasses")

local tests = DISCOVER_TESTS()

for n, test in ipairs(tests) do
    print(n .. ": " .. test:getName())
end
