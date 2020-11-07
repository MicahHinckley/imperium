--< Modules >--
local Asink = {}

--< Functions >--
local function InitializeSystem(system)
    local Future, Resolve = Asink.Future.new()

    Asink.Runtime.exec(function()
        system:Initialize()
        Resolve()
    end)

    return Future
end

local function InitializeSystems(systems)
    local Future, Resolve = Asink.Future.new()

    Asink.Runtime.exec(function()
        local SystemCache = {}
        local InitializeJobs = {}

        for _,descendant in ipairs(systems:GetChildren()) do
            if descendant:IsA("ModuleScript") and descendant:FindFirstAncestorOfClass("ModuleScript") == nil then
                local System = require(descendant)
    
                if System.Initialize ~= nil then
                    local InitializeJob = InitializeSystem()

                    table.insert(InitializeJobs, InitializeJob)
                end
    
                table.insert(SystemCache, System)
            end
        end

        Future.all(InitializeJobs):await()

        Resolve(SystemCache)
    end)

    return Future
end

--< Module >--
local Imperium = {}

function Imperium:Start(systems)
    return InitializeSystems(systems):andThen(function(systemCache)
        for _,system in ipairs(systemCache) do
            if system.Start ~= nil then
                Asink.Runtime.exec(function()
                    system:Start()
                end)
            end
        end
    end)
end

return Imperium