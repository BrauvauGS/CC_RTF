-- startup.lua

local bootloaderUrl = "https://raw.githubusercontent.com/BrauvauGS/CC_RTF/refs/heads/dev/src/bootloader.lua"
local bootloaderPath = "RTF/bootloader.lua"

-- Fonction pour télécharger le bootloader
local function downloadBootloader()
    -- Télécharger la nouvelle version du bootloader
    print("Téléchargement du bootloader...")
    local r = http.get(bootloaderUrl)
    if r then
        local content = r.readAll()
        r.close()

        -- Écrire le contenu téléchargé dans le fichier
        local f = fs.open(bootloaderPath, "w")
        f.write(content)
        f.close()

        print("Bootloader téléchargé avec succès.")
    else
        printError("Impossible de télécharger le bootloader.")
    end
end

-- Fonction pour lancer le bootloader
local function runBootloader()
    if fs.exists(bootloaderPath) then
        print("Lancement du bootloader...")
        shell.run(bootloaderPath)
    else
        printError("Le fichier bootloader n'a pas été trouvé.")
    end
end

-- Télécharger et lancer le bootloader
downloadBootloader()
runBootloader()
