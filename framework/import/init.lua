--< Services >--
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local StarterPlayer = game:GetService("StarterPlayer")
local RunService = game:GetService("RunService")

--< Modules >--
local Log = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Log"))

--< Variables >--
local ModuleLookup = {}

--< Functions >--
local function AddLocation(location)
    for _,descendant in ipairs(location:GetDescendants()) do
        if descendant:IsA("ModuleScript") and descendant:FindFirstAncestorOfClass("ModuleScript") == nil then
            if ModuleLookup[descendant.Name] then
                Log.Warn("Two or more modules of name \"" .. descendant.Name .. "\" already exist. Try renaming them.") --error("Module '" .. descendant.Name .. "' already exists.")
            else
                ModuleLookup[descendant.Name] = descendant
            end
        end
    end
end

--< Initialize >--
if RunService:IsServer() then
    AddLocation(ServerScriptService.Server)
    AddLocation(ReplicatedStorage.Shared)
elseif RunService:IsClient() then
    AddLocation(StarterPlayer:WaitForChild("StarterPlayerScripts"):WaitForChild("Client"))
    AddLocation(ReplicatedStorage:WaitForChild("Shared"))
end

--< Module >--
local function Import(identifier)
    if ModuleLookup[identifier] then
        return require(ModuleLookup[identifier])
    else
        Log.Error("Attepmt to import an invalid identifier. \"" .. identifier .. "\" does not exist.")
    end
end

return Import