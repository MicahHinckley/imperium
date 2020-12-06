local System = {}

function System:initialize()
    self.initialized = true
end

function System:start()
    self.started = true
end

return System