--< Module >--
local System = {}

function System:Initialize()
    self.Initialized = true
end

function System:Start()
    self.Started = true
end

return System