local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

if game:IsLoaded() == false then
	game.Loaded:Wait()
end

local Imperium = require(ReplicatedStorage.Imperium)
local Import = require(ReplicatedStorage.Import)

local client = Players.LocalPlayer.PlayerScripts.Client

Import.addLocation(client)
Import.addLocation(ReplicatedStorage.Shared)

Imperium.start(client.Source.Systems)