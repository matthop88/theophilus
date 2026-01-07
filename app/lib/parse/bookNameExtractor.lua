local insufficientArgsError = function(value)
    if value == nil then
        return { error = "INSUFFICIENT ARGUMENTS: No Arguments Given" }
    else
        return { error = "INSUFFICIENT ARGUMENTS: '" .. value .. "' -> Book Name Expected" }
    end
end

local bookPassageResult = function(book, passage)
    return { book = book, passage = passage }
end

local parseArgs = function(args)
    if tonumber(args[1]) then
        if args[2] == nil then return insufficientArgsError(args[1])
        else                   return bookPassageResult(args[1] .. " " .. args[2], args[3])   end
    else
        return bookPassageResult(args[1], args[2])
    end
end

return {
    execute = function(self, params)
        local args = params.args

        if args == nil or #args == 0 then return insufficientArgsError()
        else                              return parseArgs(args)     end
    end,
}
