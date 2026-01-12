local STRING_UTIL = require("app/lib/util/stringUtil")

local loadData, findFiles, lookupFunction

loadData = function(path)
    local chunk = "return "
    for line in io.lines(path) do
        chunk = chunk .. (line .. "\n")
    end

    local objFn, err = load(chunk)
    if objFn then
        return objFn()
    else
        print("ERROR: " .. err)
    end
end

findFiles = function(directory, files)
    files = files or {}
    
    local directoryItems = love.filesystem.getDirectoryItems(directory)

    for _, v in ipairs(directoryItems) do
        local path = directory .. "/" .. v
        if STRING_UTIL:endsWith(path, ".lua") then
            table.insert(files, path)
        else 
            findFiles(path, files)
        end      
    end

    return files
end

lookupFunction = function(directory, filter)
    local files = findFiles(directory)

    local dataObjs = {}
    
    for _, filename in ipairs(files) do
        local data = loadData(filename)
        if not filter or filter(data) then
            table.insert(dataObjs, data)
        end
    end

    return dataObjs
end

return lookupFunction
