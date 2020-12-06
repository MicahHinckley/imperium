local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TestService = game:GetService("TestService")

return function()
    local Asink = require(ReplicatedStorage.Shared.Imperium.Asink)
    local Imperium = require(ReplicatedStorage.Imperium)

    it("should return a future", function()
        expect(Asink.Future.isFuture(Imperium.start(TestService.Test.Systems))).to.equal(true)
    end)

    it("should start systems", function()
        Imperium.start(TestService.Test.Systems):await()

        for _,child in ipairs(TestService.Test.Systems:GetChildren()) do
            local system = require(child)

            expect(system.initialized).to.equal(true)
            expect(system.started).to.equal(true)
        end
    end)
end