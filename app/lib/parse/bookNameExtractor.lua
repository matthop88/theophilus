return {
    execute = function(self, params)
        local args = params.args

        local bookName, passage

        if tonumber(args[1]) then
            bookName = args[1] .. " " .. args[2]
            passage  = args[3]
        else
            bookName = args[1]
            passage  = args[2]
        end

        return { book = bookName, passage = passage }
    end,
}
