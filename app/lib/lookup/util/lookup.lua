local lookupFunction = function(directory, files)
    files = files or {}
    
    local directoryItems = love.filesystem.getDirectoryItems(directory)

    for _, v in ipairs(directoryItems) do
        --[[
            local path = directory .. "/" .. v
            if v ends with ".lua" then
                table.insert(files, path)
            else 
                lookupFunction(path, files)
            end      
        ]]
    end

    return files
end

return lookupFunction
