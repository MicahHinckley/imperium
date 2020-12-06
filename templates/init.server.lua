local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Imperium = require(ReplicatedStorage.Imperium)
local Import = require(ReplicatedStorage.Import)

Import.addLocation(ServerScriptService.Server)
Import.addLocation(ReplicatedStorage.Shared)

Imperium.start(ServerScriptService.Server.Source.Systems)