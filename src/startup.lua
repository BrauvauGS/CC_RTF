term.clear()
term.setCursorPos(1, 1)

-- Variables globales
local BOOTLOADER_VERSION = "V0.1.0"
local OS_FILE = "src/RTF_OS/RTF_os.lua"
local jsonURL = "https://raw.githubusercontent.com/BrauvauGS/CC_RTF/refs/heads/dev/src/system_updates.json"

-- Table des plateformes
local platforms = {
    COMPUTER = {id = 1, name = "Computer"},
    ADVANCED_COMPUTER = {id = 2, name = "Advanced_Computer"},
    TURTLE = {id = 3, name = "Turtle"},
    ADVANCED_TURTLE = {id = 4, name = "Advanced_Turtle"},
    POCKET = {id = 5, name = "Pocket"},
    ADVANCED_POCKET = {id = 6, name = "Advanced_Pocket"},
    COMMAND_COMPUTER = {id = 7, name = "Command_Computer"}
}

-- Fonction de telechargement avec reprise en cas d'echec
local function downloadFile(url, destination)
    local fileContent = http.get(url)
    if fileContent then
        local fileHandler = fs.open(destination, "w")
        fileHandler.write(fileContent.readAll())
        fileHandler.close()
    else
        printError("Erreur lors du telechargement de " .. url)
    end
end

-- Fonction pour telecharger et parser le fichier system_updates.json
local function downloadAndParseJSON(url)
    local jsonFileContent = http.get(url)
    if jsonFileContent then
        local jsonData = jsonFileContent.readAll()
        local system_updates = textutils.unserializeJSON(jsonData, { parse_null = true, parse_empty_array = false })
        if not system_updates then
            printError("Erreur lors du parsing du fichier JSON")
            return nil
        end
        return system_updates
    else
        printError("Erreur lors du telechargement de " .. url)
        return nil
    end
end

-- Fonction pour verifier la connexion reseau
local function isNetworkAvailable()
    local response = http.get("https://www.google.com")  -- ou une autre URL fiable
    if response then
        response.close()  -- Assurez-vous de fermer la connexion après avoir vérifié
        return true  -- Connexion disponible
    else
        return false  -- Pas de connexion reseau
    end
end

-- Fonction pour detecter la plateforme
local function detectPlatform()
    local isAdvanced = term.isColor()
    local isPocket = pocket ~= nil
    local isTurtle = turtle ~= nil
    local isCommand = commands ~= nil

    local detected_platform
    if isCommand then
        detected_platform = platforms.COMMAND_COMPUTER
    elseif isTurtle then
        if isAdvanced then
            detected_platform = platforms.ADVANCED_TURTLE
        else
            detected_platform = platforms.TURTLE
        end
    elseif isPocket then
        if isAdvanced then
            detected_platform = platforms.ADVANCED_POCKET
        else
            detected_platform = platforms.POCKET
        end
    else
        if isAdvanced then
            detected_platform = platforms.ADVANCED_COMPUTER
        else
            detected_platform = platforms.COMPUTER
        end
    end
    return detected_platform
end

-- Fonction pour afficher le splash screen
local function showSplashScreen()
    term.setTextColor(colors.cyan)
    print("***************************")
    print("*  RTF Bootloader " .. BOOTLOADER_VERSION .. "  *")
    print("***************************")
    term.setTextColor(colors.white)
end

-- Fonction pour creer la structure de dossiers
local function createDirectories()
    -- Cree le dossier src et ses sous-dossiers
    if not fs.exists("src") then fs.makeDir("src") end
    if not fs.exists("src/RTF_OS") then fs.makeDir("src/RTF_OS") end
    if not fs.exists("src/APPS") then fs.makeDir("src/APPS") end
end

-- Fonction principale
local function main()
    -- Afficher le splash screen
    showSplashScreen()

    -- Detecter la plateforme
    local detected_platform = detectPlatform()
    term.setTextColor(colors.green)
    print("Hardware: " .. detected_platform.name)

    -- Verifier la connexion reseau
    if isNetworkAvailable() then
    else
        printError("Aucune connexion reseau.")
        return
    end



    -- Creer la structure de dossiers
    createDirectories()

    -- Telecharger et parser le fichier system_updates.json
    local system_updates = downloadAndParseJSON(jsonURL)
    if not system_updates then return end

    -- Telecharger le fichier de l'OS
    downloadFile(system_updates.os.url, OS_FILE)


    -- Verifier si le fichier OS existe et est valide
    if not fs.exists(OS_FILE) or fs.isDir(OS_FILE) then
        printError("Erreur : '" .. OS_FILE .. "' introuvable ou invalide.")
        return
    end

    term.setTextColor(colors.white)
    print("\n")

    -- Charger et executer le fichier OS
    shell.run(OS_FILE, detected_platform.id, detected_platform.name)
end

-- Execution du programme principal
main()
