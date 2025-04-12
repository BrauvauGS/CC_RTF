-- Variables
local BOOTLOADER_VERSION = "0.5.0"
local VERSION_FILE = "RTF/RTF_local_version.json"
local OS_FILE = "RTF/src/RTF_OS/RTF_os.lua"
local JSON_URL = "https://raw.githubusercontent.com/BrauvauGS/CC_RTF/refs/heads/dev/src/system_updates.json"

local platforms = {
    COMPUTER = {id = 1, name = "Computer"},
    ADVANCED_COMPUTER = {id = 2, name = "Advanced_Computer"},
    TURTLE = {id = 3, name = "Turtle"},
    ADVANCED_TURTLE = {id = 4, name = "Advanced_Turtle"},
    POCKET = {id = 5, name = "Pocket"},
    ADVANCED_POCKET = {id = 6, name = "Advanced_Pocket"},
    COMMAND_COMPUTER = {id = 7, name = "Command_Computer"}
}

-- Détection de la plateforme
function detectPlatform()
    local isAdvanced = term.isColor()
    local isPocket = pocket ~= nil
    local isTurtle = turtle ~= nil
    local isCommand = commands ~= nil

    if isCommand then return platforms.COMMAND_COMPUTER end
    if isTurtle then return isAdvanced and platforms.ADVANCED_TURTLE or platforms.TURTLE end
    if isPocket then return isAdvanced and platforms.ADVANCED_POCKET or platforms.POCKET end
    return isAdvanced and platforms.ADVANCED_COMPUTER or platforms.COMPUTER
end

-- Affiche le splash screen
function showSplashScreen()
    term.setTextColor(colors.cyan)
    print("***************************")
    print("*  RTF Bootloader " .. BOOTLOADER_VERSION .. "   *")
    print("***************************")
    term.setTextColor(colors.white)
end

-- Téléchargement de fichier
function downloadFile(url, destination)
    local fileContent = http.get(url)
    if fileContent then
        local fileHandler = fs.open(destination, "w")
        fileHandler.write(fileContent.readAll())
        fileHandler.close()
    else
        printError("Erreur lors du téléchargement de " .. url)
    end
end

-- Téléchargement et parsing du JSON
function downloadAndParseJSON(url)
    local jsonFileContent = http.get(url)
    if jsonFileContent then
        local jsonData = jsonFileContent.readAll()
        local system_updates = textutils.unserializeJSON(jsonData)
        if not system_updates then
            printError("Erreur lors du parsing du fichier JSON")
            return nil
        end
        return system_updates
    else
        printError("Erreur lors du téléchargement de " .. url)
        return nil
    end
end

-- Comparer deux versions
function isNewerVersion(localVersion, remoteVersion)
    local function splitVersion(v)
        local major, minor, patch = v:match("(%d+)%.(%d+)%.(%d+)")
        return tonumber(major), tonumber(minor), tonumber(patch)
    end

    local lMaj, lMin, lPatch = splitVersion(localVersion or "0.0.0")
    local rMaj, rMin, rPatch = splitVersion(remoteVersion)

    if rMaj > lMaj then return true end
    if rMaj == lMaj and rMin > lMin then return true end
    if rMaj == lMaj and rMin == lMin and rPatch > lPatch then return true end
    return false
end

-- Crée les dossiers nécessaires
function createDirectories()
    if not fs.exists("RTF") then fs.makeDir("RTF") end
    if not fs.exists("RTF/src") then fs.makeDir("RTF/src") end
    if not fs.exists("RTF/src/RTF_OS") then fs.makeDir("RTF/src/RTF_OS") end
    if not fs.exists("RTF/src/APPS") then fs.makeDir("RTF/src/APPS") end
end

-- Lire la version locale
function getLocalVersions()
    if fs.exists(VERSION_FILE) then
        local file = fs.open(VERSION_FILE, "r")
        local data = textutils.unserialize(file.readAll())
        file.close()
        return data or {}
    else
        return {}
    end
end

-- Sauvegarder la version locale
function saveLocalVersions(data)
    local file = fs.open(VERSION_FILE, "w")
    file.write(textutils.serialize(data))
    file.close()
end

-- Fonction principale (boot)
function boot()
    term.clear()
    term.setCursorPos(1, 1)

    showSplashScreen()
    local platform = detectPlatform()
    term.setTextColor(colors.green)
    print("Hardware: " .. platform.name)

    createDirectories()

    local system_updates = downloadAndParseJSON(JSON_URL .. "?t=" .. os.epoch("utc"))
    if not system_updates then return end

    local localVersions = getLocalVersions()
    local osVersionRemote = system_updates.os.version
    local osVersionLocal = localVersions.os or "0.0.0"

    print("Version locale : " .. osVersionLocal)
    print("Version distante : " .. osVersionRemote)

    if isNewerVersion(osVersionLocal, osVersionRemote) or not fs.exists(OS_FILE) then
        print("Mise à jour de l'OS...")

        if fs.exists(OS_FILE) then
            fs.delete(OS_FILE)
            sleep(0.1)
        end

        downloadFile(system_updates.os.url, OS_FILE)
        localVersions.os = osVersionRemote
        saveLocalVersions(localVersions)

        print("Redémarrage pour appliquer la mise à jour...")
        sleep(1)
        os.reboot()
    else
        print("OS à jour. Version actuelle : " .. osVersionLocal)
    end

    if not fs.exists(OS_FILE) then
        printError("Erreur : fichier OS introuvable.")
        return
    end

    term.setTextColor(colors.white)
    print("\nChargement de l'OS...\n")
    shell.run(OS_FILE, platform.id, platform.name)
end

-- Lancer le bootloader
boot()
