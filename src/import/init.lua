--< Services >--
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local StarterPlayer = game:GetService("StarterPlayer")
local RunService = game:GetService("RunService")

--< Constants >--
local LOCATIONS = {
    Client = StarterPlayer:WaitForChild("StarterPlayerScripts"):WaitForChild("Client");
    Server = ServerScriptService:WaitForChild("Server");
    Shared = ReplicatedStorage:WaitForChild("Shared");
}

--< Variables >--
local ModuleLookup = {}

--< Functions >--
local function AddLocation(location)
    for _,descendant in ipairs(location:GetDescendants()) do
        if (descendant:IsA("ModuleScript") and descendant:FindFirstAncestorOfClass("ModuleScript") == nil) then
            if (ModuleLookup[descendant.Name]) then
                error("Module '" .. descendant.Name .. "' already exists.")
            else
                ModuleLookup[descendant.Name] = descendant
            end
        end
    end
end

--< Initialize >--
if (RunService:IsServer()) then
    AddLocation(LOCATIONS.Server)
    AddLocation(LOCATIONS.Shared)
elseif (RunService:IsClient()) then
    AddLocation(LOCATIONS.Client)
    AddLocation(LOCATIONS.Shared)
end

--< Module >--
local function Import(identifier)
    if (ModuleLookup[identifier]) then
        return require(ModuleLookup[identifier])
    else
        error("'" .. identifier .. "' does not exist.")
    end
end

return Import