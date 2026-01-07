return {
    execute = function(self, params)
        local args = params.args

        local bookName, passage

        bookName = args[1]
        passage  = args[2]

        return { book = args[1], passage = args[2] }
    end,
}
