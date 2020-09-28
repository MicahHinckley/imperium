--< Modules >--
local Display = require(script.Display)

--< Functions >--
local function BetterFormat(template, ...)
    local Values = {...}
    
    local Matches = 0
    local Result = template:gsub("{([^}]*)}", function(args)
        Matches = Matches + 1

        local Value = Values[Matches]

        if args == "?" then
            return Display(Value)
        elseif args == "" then
            return tostring(Value)
        else
            error(string.format("Invalid format string %q", args))
        end
    end)
    
    return Result
end

--< Module >--
local Log = {}

function Log.Error(template, ...)
    local Message = BetterFormat(template, ...)
    error(Message, 2)
end

function Log.Warn(template, ...)
    local Message = BetterFormat(template, ...)
    warn(Message)
end

function Log.Info(template, ...)
    local Message = BetterFormat(template, ...)
    print(Message)
end

return Log