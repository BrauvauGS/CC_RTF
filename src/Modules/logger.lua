local Logger = {}

-- Constructor to create a new Logger instance
function Logger:new()
    local instance = {}
    setmetatable(instance, { __index = Logger })

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
function Logger:log(level, message)
    -- If no level is passed, set the color to grey (default)
    local color = self.colors[level] or self.colors.default
    local levelText = level and ("[" .. level:upper() .. "]") or "[TRACE]"

    -- Set the text color for the level
    term.setTextColor(color)
    write(levelText .. " ")  -- Print the level on the same line

    -- Reset the color back to white for the message
    term.setTextColor(colors.white)
    print(message)  -- Print the message on the same line after the level
end

-- Return the Logger class
return Logger
