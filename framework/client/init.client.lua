--< Initialize >--
if not game:IsLoaded() then
    game.Loaded:Wait()
end

--< Services >--
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--< Start >--
require(ReplicatedStorage.Import)