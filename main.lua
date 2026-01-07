function love.load(args)
    if args[1] == "test" then 
        require("test/framework/application")
    else        
        __ARGS = args              
        require("app/main")
    end
end
