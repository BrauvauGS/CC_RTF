local url = "https://raw.githubusercontent.com/BrauvauGS/CC_RTF/refs/heads/dev/src/bootloader.lua"
local path = "RTF/bootloader.lua"
local moduleName = "RTF/bootloader"

-- Supprime l'ancien fichier s’il existe
if fs.exists(path) then fs.delete(path) end

-- Téléchargement
local r = http.get(url)
if r then
    local content = r.readAll()
    r.close()

    -- Écriture sur le disque
    local f = fs.open(path, "w")
    f.write(content)
    f.close()

    -- Suppression du module du cache si déjà chargé
    if package.loaded[moduleName] then
        package.loaded[moduleName] = nil
    end

    -- Chargement via require
    local Bootloader = require(moduleName)
    local loader = Bootloader:new()
    loader:boot()
else
    printError("Impossible de charger le bootloader.")
end
