local insufficientArgsError = function(value)
    if value == nil then
        return { error = "INSUFFICIENT ARGUMENTS: No Arguments Given" }
    else
        return { error = "INSUFFICIENT ARGUMENTS: '" .. value .. "' -> Book Name Expected" }
    end
end

local bookPassageVersionResult = function(book, passage, version)
    return { book = book, passage = passage, version = version }
end

local parseArgs = function(args)
    local argOffset = 0
    local book, passage
    if tonumber(args[1]) then
        argOffset = 1
        if args[2] == nil then return insufficientArgsError(args[1])
        else                   book = args[1] .. " " .. args[2]  end
    else
        book = args[1]
    end

    passage = args[2 + argOffset]
    version = args[3 + argOffset]

    return bookPassageVersionResult(book, passage, version)
end

return {
    execute = function(self, params)
        local args = params.args

        if args == nil or #args == 0 then return insufficientArgsError()
        else                              return parseArgs(args)     end
    end,
}
