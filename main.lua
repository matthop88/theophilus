function love.load(args)
    if args[1] == "test" then 
        require("test/framework/application")
    elseif args[1] and string.upper(args[1]) == "SCHEDULE" then
        require("app/schedule/scheduleApp")
    elseif args[1] and string.upper(args[1]) == "CLOAK" then
        __ARGS = {}
        for n, arg in ipairs(args) do
            if n > 1 then table.insert(__ARGS, arg) end
        end
        require("app/cloak/cloakApp")
    elseif args[1] and string.upper(args[1]) == "SUCCESS" then
        __ARGS = {}
        for n, arg in ipairs(args) do
            if n > 1 then table.insert(__ARGS, arg) end
        end
        require("app/success/successApp")
    elseif args[1] and string.upper(args[1]) == "FAIL" then
        __ARGS = {}
        for n, arg in ipairs(args) do
            if n > 1 then table.insert(__ARGS, arg) end
        end
        require("app/fail/failApp")
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
