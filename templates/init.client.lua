local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

if game:IsLoaded() == false then
	game.Loaded:Wait()
end

local Imperium = require(ReplicatedStorage.Imperium)
local import = require(ReplicatedStorage.import)

local client = Players.LocalPlayer.PlayerScripts.Client

import.addLocation(client)
import.addLocation(ReplicatedStorage.Shared)

Imperium.start(client.Source.Systems)