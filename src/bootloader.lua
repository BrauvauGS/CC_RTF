-- Variables
local osUrl = "https://raw.githubusercontent.com/BrauvauGS/CC_RTF/refs/heads/dev/src/RTF_OS/RTF_os.lua"
local osPath = "RTF/src/RTF_OS/RTF_os.lua"

local loggerUrl = "https://raw.githubusercontent.com/BrauvauGS/CC_RTF/refs/heads/dev/src/Modules/logger.lua"
local loggerPath = "RTF/src/Modules/logger.lua"
local loggerModuleName = "RTF.src.Modules.logger"

-- Créer les répertoires nécessaires
function createSystemDirectories()
    if not fs.exists("RTF") then fs.makeDir("RTF") end
    if not fs.exists("RTF/src") then fs.makeDir("RTF/src") end
    if not fs.exists("RTF/src/RTF_OS") then fs.makeDir("RTF/src/RTF_OS") end
    if not fs.exists("RTF/src/APPS") then fs.makeDir("RTF/src/APPS") end
    if not fs.exists("RTF/src/Modules") then fs.makeDir("RTF/src/Modules") end
end

-- Télécharger un fichier
function downloadFile(url, destination)
    local fileContent = http.get(url)
    if fileContent then
        local fileHandler = fs.open(destination, "w")
        fileHandler.write(fileContent.readAll())
        fileHandler.close()
        return true
    else
        printError("Erreur de téléchargement pour " .. url)
        return false
    end
end

-- Fonction principale de démarrage
function boot()
    term.clear()
    term.setCursorPos(1, 1)

    print("** RTF Bootloader **")
    createSystemDirectories()

    -- Télécharger et initialiser le logger
    print("Téléchargement du logger...")
    if downloadFile(loggerUrl, loggerPath) then
        print("Logger téléchargé avec succès.")

        -- Vérification si le fichier existe avant de le charger
        if fs.exists(loggerPath) then
            print("Le fichier logger.lua existe. Chargement du module.")
            
            -- Charger le module logger
            local Logger = require(loggerModuleName)
            local ConsolLog = Logger:new()
            ConsolLog:log("system", "Logger initialisé avec succès")

            -- Télécharger et lancer l'OS
            print("Téléchargement de l'OS...")
            if downloadFile(osUrl, osPath) then
                print("OS téléchargé avec succès.")

                -- Définir la plateforme : id = 1, name = "Advanced_Computer"
                local platform = { id = 1, name = "Advanced_Computer" }
                print("Lancement de l'OS sur la plateforme : " .. platform.name)
                shell.run(osPath, platform.id, platform.name)  -- Lancer l'OS avec les paramètres de plateforme
            else
                printError("Erreur de téléchargement de l'OS.")
            end
        else
            printError("Erreur : Le fichier logger.lua n'a pas été téléchargé.")
        end
    else
        printError("Erreur de téléchargement du logger.")
    end
end

-- Lancer le bootloader
boot()
