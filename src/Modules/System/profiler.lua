local logger = require("Modules.logger")

local Profiler = {}

-- Constructor
function Profiler:new(name)
    local instance = {}
    setmetatable(instance, { __index = Profiler })

    instance.name = name or "Profiling"
    instance.timings = {}
    instance.startTimes = {}
    instance.logger = logger:new()

    return instance
end

-- Start timing for a specific label
function Profiler:start(label)
    self.startTimes[label] = os.clock()
    self.logger:log("I", "Start profiling: " .. label)
end

-- Stop timing and store duration
function Profiler:stop(label)
    local startTime = self.startTimes[label]
    if not startTime then
        self.logger:log("E", "No profiling start time found for: " .. label)
        return
    end

    local elapsed = os.clock() - startTime
    self.timings[label] = elapsed
    self.startTimes[label] = nil
    self.logger:log("I", string.format("Stop profiling: %s (%.4f sec)", label, elapsed))
end

-- Report all recorded timings
function Profiler:report()
    self.logger:log("S", "== Profiling Report: " .. self.name .. " ==")
    for label, time in pairs(self.timings) do
        self.logger:log("I", string.format("%s: %.4f sec", label, time))
    end
end

return Profiler
