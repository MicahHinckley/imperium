--< Services >--
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

--< Modules >--
local Imperium = require(ReplicatedStorage.Imperium)
local Import = require(ReplicatedStorage.Import)

--< Start >--
Import.AddLocation(ServerScriptService.Server)
Import.AddLocation(ReplicatedStorage.Shared)

Imperium:Start(ServerScriptService.Server.Source.Systems)