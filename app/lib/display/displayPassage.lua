local STRING_UTIL    = require("app/lib/util/stringUtil")
local displayCaption = require("app/lib/display/displayCaption")

return function(result)
    if result.error then
        print("\nERROR: " .. result.error .. "\n")
    else
        local reference = result.book .. " " .. result.passage .. " (" .. result.version .. ")"
        displayCaption(reference)

        for _, ch in ipairs(result.result) do
            displayCaption(result.book .. " " .. ch.chapter)

            if ch.warning then
                print("\nWARNING: " .. ch.warning .. "\n")
            else
                for _, v in ipairs(ch) do
                    if v.warning then
                        print("\nWARNING: " .. v.warning .. "\n")
                    else
                        for n, s in ipairs(v) do
                            local ss = s
                            if   STRING_UTIL:endsWith(s, ".")
                              or STRING_UTIL:endsWith(s, "?")
                              or STRING_UTIL:endsWith(s, "!")
                              or STRING_UTIL:endsWith(s, ":")
                            then
                                ss = ss .. "\n"
                            end

                            if n == 1 then print(v.verse .. " " .. ss)
                            else print(ss)                         end
                        end
                    end
                end
            end
        end

        print("\n" .. reference .. "\n")
    end
end
