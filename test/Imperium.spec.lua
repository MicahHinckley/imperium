--< Services >--
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TestService = game:GetService("TestService")

--< Tests >--
return function()
    local Asink = require(ReplicatedStorage.Shared.Imperium.Asink)
    local Imperium = require(ReplicatedStorage.Imperium)

    it("should return a future", function()
        expect(Asink.Future.isFuture(Imperium:Start(TestService.Test.Systems))).to.equal(true)
    end)

    it("should start systems", function()
        Imperium:Start(TestService.Test.Systems):await()

        for _,system in ipairs(TestService.Test.Systems:GetChildren()) do
            local System = require(system)

            expect(System.Initialized).to.equal(true)
            expect(System.Started).to.equal(true)
        end
    end)
end