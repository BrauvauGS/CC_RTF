local Logger = {}

-- Constructor to create a new Logger instance
function Logger:new()
    local instance = {}
    setmetatable(instance, { __index = Logger })

    -- Default colors for each log type
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
function Logger:log(level, message)
    -- If no level is passed, set the color to grey (default)
    local color = self.colors[level] or self.colors.default
    local levelText = level and ("[" .. level:upper() .. "]") or "[DEFAULT]"

    -- Set the text color and print the message
    term.setTextColor(color)
    print(levelText .. " " .. message)
    term.setTextColor(colors.white)  -- Reset to white after printing
end

-- Return the Logger class
return Logger
