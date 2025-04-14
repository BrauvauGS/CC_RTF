-- src/Modules/System/logger.lua

local Logger = {}
Logger.__index = Logger

-- Constructeur
function Logger:new()
    local instance = setmetatable({}, self)  -- Modifié pour utiliser `self` et permettre l'héritage dynamique

    instance.version = "1.0.3"

    -- Correspondance des niveaux abrégés
    instance.levelMap = {
        I = "info",
        W = "warning",
        E = "error",
        S = "system",
        D = "download"
    }

    -- Couleurs par niveau
    instance.colors = {
        info = colors.green,
        warning = colors.yellow,
        error = colors.red,
        system = colors.purple,
        download = colors.magenta,
        default = colors.gray -- gris, pas grey : "gray" est correct ici pour l'API
    }

    return instance
end

-- Log un message avec un niveau
function Logger:log(shortLevel, message)
    local fullLevel = self.levelMap[shortLevel] or "default"
    local color = self.colors[fullLevel] or self.colors.default
    local levelText = "[" .. fullLevel:upper() .. "]:"

    term.setTextColor(color)
    write(levelText .. " ")
    term.setTextColor(colors.white)
    print(message)
end

-- Retourne la version du logger
function Logger:getVersion()
    return self.version
end

return Logger
