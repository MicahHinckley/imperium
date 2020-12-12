local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Imperium = require(ReplicatedStorage.Imperium)
local import = require(ReplicatedStorage.import)

import.addLocation(ServerScriptService.Server)
import.addLocation(ReplicatedStorage.Shared)

Imperium.start(ServerScriptService.Server.Systems)