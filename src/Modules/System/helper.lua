-- RTF/helper.lua


local helper = {}

-- Constructor to create a new Logger instance
function helper:new()
    local instance = {}
    setmetatable(instance, { __index = helper })

    local logger = require("src.Modules.System.logger")

    instance.logger = logger:new()

    instance.version = "1.0.0"

    instance.platforms = {
        COMPUTER = {id = 1, name = "Computer"},
        ADVANCED_COMPUTER = {id = 2, name = "Advanced_Computer"},
        TURTLE = {id = 3, name = "Turtle"},
        ADVANCED_TURTLE = {id = 4, name = "Advanced_Turtle"},
        POCKET = {id = 5, name = "Pocket"},
        ADVANCED_POCKET = {id = 6, name = "Advanced_Pocket"},
        COMMAND_COMPUTER = {id = 7, name = "Command_Computer"}
    }


    return instance
end
-- Function to download a file from a URL and save it locally
function helper:downloadFile(url, destination)
    -- Check if the URL is valid
    if not url or url == "" then
       self.logger:log("E", "Error: Invalid URL.")
        return false
    end

    -- Check if the destination path is valid
    if not destination or destination == "" then
        self.logger:log("E", "Error: Invalid destination path.")
        return false
    end

    -- Try to fetch the file from the URL
    local file = http.get(url)
    if not file then
        self.logger:log("E", "Error: Failed to download from " .. url)
        return false
    end

    -- Read the content of the downloaded file
    local content = file.readAll()
    file.close()

    -- Check if the content is empty
    if content == "" then
        self.logger:log("E", "Error: Downloaded file is empty.")
        return false
    end

    -- Create or overwrite the local file at the specified path
    local f = fs.open(destination, "w")
    if not f then
        self.logger:log("E", "Error: Failed to open file for writing.")
        return false
    end

    -- Write the content to the local file
    f.write(content)
    f.close()

    -- Confirm success
    self.logger:log("I", "File downloaded and saved to " .. destination)
    return true
end
function helper:getVersion()
    return self.version
end

function helper:getPlatforme()
    local isAdvanced = term.isColor()
    local isPocket = pocket ~= nil
    local isTurtle = turtle ~= nil
    local isCommand = commands ~= nil

    if isCommand then return self.platforms.COMMAND_COMPUTER end
    if isTurtle then return isAdvanced and self.platforms.ADVANCED_TURTLE or self.platforms.TURTLE end
    if isPocket then return isAdvanced and self.platforms.ADVANCED_POCKET or self.platforms.POCKET end
    return isAdvanced and self.platforms.ADVANCED_COMPUTER or self.platforms.COMPUTER
end
return helper