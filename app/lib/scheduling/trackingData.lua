local TRACKING_FILE_PATH = "data/scheduling/trackingData.lua"

local loadTrackingData = function()
    local chunk = ""
    local file = io.open(TRACKING_FILE_PATH, "r")
    if not file then return nil end
    for line in file:lines() do
        chunk = chunk .. line .. "\n"
    end
    file:close()
    local objFn, err = load(chunk)
    if objFn then
        local data = objFn()
        for _, entry in ipairs(data) do
            if entry.filter == nil then entry.filter = 0 end
        end
        return data
    else
        print("ERROR loading tracking data: " .. err)
        return nil
    end
end

local saveTrackingData = function(data)
    local file = io.open(TRACKING_FILE_PATH, "w")
    file:write("return {\n")
    for _, entry in ipairs(data) do
        file:write(string.format(
            "    { reference = %-25s level = %2d, filter = %2d, nextDate = %d },\n",
            "\"" .. entry.reference .. "\",",
            entry.level,
            entry.filter,
            entry.nextDate
        ))
    end
    file:write("}\n")
    file:close()
end

local generateTrackingData = function(scheduleList)
    local data = {}
    for _, reference in ipairs(scheduleList) do
        table.insert(data, { reference = reference, level = 1, filter = 0, nextDate = 0 })
    end
    saveTrackingData(data)
    return data
end

local selectNextScripture = function(data)
    local selected = nil
    for _, entry in ipairs(data) do
        if selected == nil or entry.nextDate < selected.nextDate then
            selected = entry
        end
    end
    return selected
end

return {
    load     = loadTrackingData,
    save     = saveTrackingData,
    generate = generateTrackingData,
    select   = selectNextScripture,
}
