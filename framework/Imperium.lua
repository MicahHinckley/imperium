--< Module >--
local Imperium = {}

function Imperium:Start(services)
    local ServiceCache = {}

    for _,descendant in ipairs(services:GetChildren()) do
        if descendant:IsA("ModuleScript") and descendant:FindFirstAncestorOfClass("ModuleScript") == nil then
            local Service = require(descendant)

            if Service.Initialize then
                Service:Initialize()
            end

            table.insert(ServiceCache, Service)
        end
    end

    for _,service in ipairs(ServiceCache) do
        if service.Start then
            -- spawn thread and call start
        end
    end

    return ServiceCache
end

return Imperium