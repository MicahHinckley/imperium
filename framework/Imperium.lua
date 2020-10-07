--< Module >--
local Imperium = {}

function Imperium:Start(systems)
    local SystemCache = {}

    for _,descendant in ipairs(systems:GetChildren()) do
        if descendant:IsA("ModuleScript") and descendant:FindFirstAncestorOfClass("ModuleScript") == nil then
            local System = require(descendant)

            if System.Initialize then
                System:Initialize()
            end

            table.insert(SystemCache, System)
        end
    end

    for _,system in ipairs(SystemCache) do
        if system.Start then
            -- spawn thread and call start
        end
    end

    return SystemCache
end

return Imperium