return {
    execute = function(self, params)
        local args = params.args

        if args == nil or #args == 0 then
            return { error = "INSUFFICIENT ARGUMENTS: No Arguments Given" }

        else
            local bookName, passage

            if tonumber(args[1]) then
                bookName = args[1] .. " " .. args[2]
                passage  = args[3]
            else
                bookName = args[1]
                passage  = args[2]
            end

            return { book = bookName, passage = passage }
        end
    end,
}
