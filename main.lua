function love.load(args)
    if args[1] == "test" then 
        require("test/framework/application")
    elseif args[1] and string.upper(args[1]) == "BIBLE" then
        __ARGS = {}
        for n, arg in ipairs(args) do
            if n > 1 then table.insert(__ARGS, arg) end
        end

        require("app/bible/bibleApp")        
    else
        __ARGS = args              
        require("app/main")
    end
end
