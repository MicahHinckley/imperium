--< Services >--
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--< Initialize >--
if game:IsLoaded() == false then
	game.Loaded:Wait()
end

--< Modules >--
local Imperium = require(ReplicatedStorage.Imperium)
local Import = require(ReplicatedStorage.Import)

--< Variables >--
local Player = Players.LocalPlayer
local Client = Player.PlayerScripts.Client

--< Start >--
Import.AddLocation(Client)
Import.AddLocation(ReplicatedStorage.Shared)

Imperium:Start(Client.Source.Systems)