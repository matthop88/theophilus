local STRING_UTIL = require("app/lib/util/stringUtil")

local lookupFunction

lookupFunction = function(directory, files)
    files = files or {}
    
    local directoryItems = love.filesystem.getDirectoryItems(directory)

    for _, v in ipairs(directoryItems) do
        local path = directory .. "/" .. v
        if STRING_UTIL:endsWith(v, ".lua") then
            table.insert(files, path)
        else 
            lookupFunction(path, files)
        end      
    end

    return files
end

return lookupFunction
