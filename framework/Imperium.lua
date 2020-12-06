local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Asink = require(ReplicatedStorage.Shared.Imperium.Asink)

local function initializeSystem(system)
    local future, resolve = Asink.Future.new()

    Asink.Runtime.exec(function()
        system:Initialize()
        resolve()
    end)

    return future
end

local function initializeSystems(systemsRoot)
    local future, resolve = Asink.Future.new()

    Asink.Runtime.exec(function()
        local systemCache = {}
        local initializeJobs = {}

        local function initializeSystemsInRoot(root)
            for _,child in ipairs(root:GetChildren()) do
                if child:IsA("ModuleScript") then
                    local system = require(child)
    
                    if system.initialize ~= nil then
                        table.insert(initializeJobs, initializeSystem(system))
                    end
    
                    table.insert(systemCache, system)
                else
                    initializeSystemsInRoot(child)
                end
            end
        end

        initializeSystemsInRoot(systemsRoot)

        future.all(initializeJobs):await()

        resolve(systemCache)
    end)

    return future
end

local Imperium = {}

function Imperium.start(systems)
    local future = initializeSystems(systems)

    future:map(function(systemCache)
        for _,system in ipairs(systemCache) do
            if system.start ~= nil then
                Asink.Runtime.exec(function()
                    system:start()
                end)
            end
        end
    end)

    return future
end

return Imperium