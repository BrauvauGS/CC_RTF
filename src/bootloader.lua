-- Déclaration du module
local Bootloader = {}
Bootloader.__index = Bootloader

-- Constructeur
function Bootloader:new()
    local self = setmetatable({}, Bootloader)

    self.BOOTLOADER_VERSION = "0.5.0"
    self.VERSION_FILE = "RTF/version.json"
    self.OS_FILE = "RTF/src/RTF_OS/RTF_os.lua"
    self.JSON_URL = "https://raw.githubusercontent.com/BrauvauGS/CC_RTF/refs/heads/dev/src/system_updates.json"

    self.platforms = {
        COMPUTER = {id = 1, name = "Computer"},
        ADVANCED_COMPUTER = {id = 2, name = "Advanced_Computer"},
        TURTLE = {id = 3, name = "Turtle"},
        ADVANCED_TURTLE = {id = 4, name = "Advanced_Turtle"},
        POCKET = {id = 5, name = "Pocket"},
        ADVANCED_POCKET = {id = 6, name = "Advanced_Pocket"},
        COMMAND_COMPUTER = {id = 7, name = "Command_Computer"}
    }

    return self
end

-- Détection de la plateforme
function Bootloader:detectPlatform()
    local isAdvanced = term.isColor()
    local isPocket = pocket ~= nil
    local isTurtle = turtle ~= nil
    local isCommand = commands ~= nil

    if isCommand then return self.platforms.COMMAND_COMPUTER end
    if isTurtle then return isAdvanced and self.platforms.ADVANCED_TURTLE or self.platforms.TURTLE end
    if isPocket then return isAdvanced and self.platforms.ADVANCED_POCKET or self.platforms.POCKET end
    return isAdvanced and self.platforms.ADVANCED_COMPUTER or self.platforms.COMPUTER
end

-- Affiche le splash screen
function Bootloader:showSplashScreen()
    term.setTextColor(colors.cyan)
    print("***************************")
    print("*  RTF Bootloader " .. self.BOOTLOADER_VERSION .. "   *")
    print("***************************")
    term.setTextColor(colors.white)
end

-- Vérifie la connexion Internet
function Bootloader:isNetworkAvailable()
    local response = http.get("https://www.google.com")
    if response then response.close() return true else return false end
end

-- Téléchargement de fichier
function Bootloader:downloadFile(url, destination)
    local fileContent = http.get(url)
    if fileContent then
        local fileHandler = fs.open(destination, "w")
        fileHandler.write(fileContent.readAll())
        fileHandler.close()
    else
        printError("Erreur lors du telechargement de " .. url)
    end
end

-- Téléchargement et parsing du JSON
function Bootloader:downloadAndParseJSON(url)
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
        printError("Erreur lors du telechargement de " .. url)
        return nil
    end
end

-- Compare deux versions
function Bootloader:isNewerVersion(localVersion, remoteVersion)
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
function Bootloader:createDirectories()
    if not fs.exists("RTF") then fs.makeDir("RTF") end
    if not fs.exists("RTF/src") then fs.makeDir("RTF/src") end
    if not fs.exists("RTF/src/RTF_OS") then fs.makeDir("RTF/src/RTF_OS") end
    if not fs.exists("RTF/src/APPS") then fs.makeDir("RTF/src/APPS") end
end

-- Lit la version locale
function Bootloader:getLocalVersions()
    if fs.exists(self.VERSION_FILE) then
        local file = fs.open(self.VERSION_FILE, "r")
        local data = textutils.unserialize(file.readAll())
        file.close()
        return data or {}
    else
        return {}
    end
end

-- Sauvegarde la version locale
function Bootloader:saveLocalVersions(data)
    local file = fs.open(self.VERSION_FILE, "w")
    file.write(textutils.serialize(data))
    file.close()
end

-- Fonction principale (boot)
function Bootloader:boot()
    term.clear()
    term.setCursorPos(1, 1)

    self:showSplashScreen()
    local platform = self:detectPlatform()
    term.setTextColor(colors.green)
    print("Hardware: " .. platform.name)

    if not self:isNetworkAvailable() then
        printError("Aucune connexion réseau.")
        return
    end

    self:createDirectories()

    local system_updates = self:downloadAndParseJSON(self.JSON_URL .. "?t=" .. os.epoch("utc"))
    if not system_updates then return end

    local localVersions = self:getLocalVersions()
    local osVersionRemote = system_updates.os.version
    local osVersionLocal = localVersions.os or "0.0.0"

    print("Version locale : " .. osVersionLocal)
    print("Version distante : " .. osVersionRemote)

    if self:isNewerVersion(osVersionLocal, osVersionRemote) or not fs.exists(self.OS_FILE) then
        print("Mise à jour de l'OS...")

        if fs.exists(self.OS_FILE) then
            fs.delete(self.OS_FILE)
            sleep(0.1)
        end

        self:downloadFile(system_updates.os.url, self.OS_FILE)
        localVersions.os = osVersionRemote
        self:saveLocalVersions(localVersions)

        print("Redémarrage pour appliquer la mise à jour...")
        sleep(1)
        os.reboot()
    else
        print("OS à jour. Version actuelle : " .. osVersionLocal)
    end

    if not fs.exists(self.OS_FILE) then
        printError("Erreur : fichier OS introuvable.")
        return
    end

    term.setTextColor(colors.white)
    print("\nChargement de l'OS...\n")
    shell.run(self.OS_FILE, platform.id, platform.name)
end

-- Retourner la classe
return Bootloader
