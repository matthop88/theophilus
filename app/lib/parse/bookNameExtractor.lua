return {
    execute = function(self, params)
        local args = params.args

        if args == nil or #args == 0 then
            return { error = "INSUFFICIENT ARGUMENTS: No Arguments Given" }
        else
            if tonumber(args[1]) then
                if args[2] == nil then
                    return { error = "INSUFFICIENT ARGUMENTS: '" .. args[1] .. "' -> Book Name Expected" }
                else
                    return { book = args[1] .. " " .. args[2], passage = args[3] }
                end
            else
                return { book = args[1], passage = args[2] }
            end
        end
    end,
}
