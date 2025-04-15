-- src/Modules/RTF/helper.lua

local Logger = require("src.Modules.System.logger")

-- Définition de la classe Helper
local Helper = {}
Helper.__index = Helper

-- Constructeur
function Helper:new()
    local instance = setmetatable({}, self)  -- Utilisation de `self` pour l'héritage dynamique

    -- Initialisation des attributs
    instance.logger = Logger:new()
    instance.version = "1.0.6"

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

function Helper:getVersion()
    return self.version
end

-- Function to download a file from a URL and save it locally
function Helper:downloadFile(url, destination)
    if not url or url == "" then
        self.logger:log("E", "Error: Invalid URL.")
        return false
    end

    if not destination or destination == "" then
        self.logger:log("E", "Error: Invalid destination path.")
        return false
    end

    local file = http.get(url)
    if not file then
        self.logger:log("E", "Error: Failed to download from " .. url)
        return false
    end

    local content = file.readAll()
    file.close()

    if content == "" then
        self.logger:log("E", "Error: Downloaded file is empty.")
        return false
    end

    local f = fs.open(destination, "w")
    if not f then
        self.logger:log("E", "Error: Failed to open file for writing.")
        return false
    end

    f.write(content)
    f.close()

    self.logger:log("I", "File downloaded and saved to " .. destination)
    return true
end



function Helper:getPlatform()
    local isAdvanced = term.isColor()
    local isPocket = pocket ~= nil
    local isTurtle = turtle ~= nil
    local isCommand = commands ~= nil

    if isCommand then return self.platforms.COMMAND_COMPUTER end
    if isTurtle then return isAdvanced and self.platforms.ADVANCED_TURTLE or self.platforms.TURTLE end
    if isPocket then return isAdvanced and self.platforms.ADVANCED_POCKET or self.platforms.POCKET end
    return isAdvanced and self.platforms.ADVANCED_COMPUTER or self.platforms.COMPUTER
end

return Helper
