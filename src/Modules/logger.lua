local Logger = {}

-- Constructor to create a new Logger instance
function Logger:new()
    local instance = {}
    setmetatable(instance, { __index = Logger })

    -- Mapping of short levels to full levels
    instance.levelMap = {
        I = "info",
        W = "warning",
        E = "error",
        S = "system"
    }

    -- Default colors for each log level
    instance.colors = {
        info = colors.green,
        warning = colors.yellow,
        error = colors.red,
        system = colors.purple,
        default = colors.grey -- Default color if no level is provided
    }

    return instance
end

-- Function to log a message with a specific level
function Logger:log(shortLevel, message)
    local fullLevel = self.levelMap[shortLevel] or "default"
    local color = self.colors[fullLevel] or self.colors.default
    local levelText = "[" .. fullLevel:upper() .. "] :"

    term.setTextColor(color)
    write(levelText .. " ")
    term.setTextColor(colors.white)
    print(message)
end

-- Return the Logger class
return Logger
