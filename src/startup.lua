term.clear()
term.setCursorPos(1,1)



local jsonURL = "https://raw.githubusercontent.com/BrauvauGS/CC_RTF/refs/heads/main/src/versions.json"

-- Télécharger le fichier versions.json
local jsonFileContent = http.get(jsonURL)

if jsonFileContent then
    -- Lire tout le contenu du fichier téléchargé
    local jsonData = jsonFileContent.readAll()

    -- Parser le JSON en une table Lua, en gérant les valeurs null et les tableaux vides
    local versions = textutils.unserializeJSON(jsonData, { parse_null = true, parse_empty_array = false })

    -- Vérifier si le parsing a réussi
    if versions then
        -- Afficher la version du bootloader
        print("Version du Bootloader : " .. versions.bootloader.version)

        -- Afficher la version de l'OS
        print("Version de l'OS : " .. versions.os.version)
    else
        printError("Erreur lors du parsing du fichier JSON")
    end

        -- Télécharger le fichier de l'OS
        print("Téléchargement de l'OS...")
        local osURL = versions.os.url
        local osContent = http.get(osURL)

        if osContent then
            local osFile = fs.open("RTF_os.lua", "w")
            osFile.write(osContent.readAll())
            osFile.close()
            print("OS téléchargé avec succès.")
        else
            printError("Erreur lors du téléchargement de l'OS.")
        end



else
    -- Si l'URL n'a pas été accessible, afficher une erreur
    printError("Erreur lors du téléchargement de versions.json")
end

-- Bootloader pour CC:Tweaked
local OS_FILE = "RTF_os.lua"
local BOOTLOADER_VERSION = "V0.1"

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
local isAdvanced = term.isColor()
local isPocket = pocket ~= nil
local isTurtle = turtle ~= nil
local isCommand = commands ~= nil


-- Détection automatique de la plateforme
local detected_platform = platforms.COMPUTER  -- Valeur par défaut (Ordinateur standard)



-- Affichage du nom et de l'ID de la plateforme détectée
term.setTextColor(colors.green)

-- Splash screen
term.setTextColor(colors.cyan)
print("*************************")
print("*  RTF Bootloader " .. BOOTLOADER_VERSION.. "  *")
print("*************************")
print()
term.setTextColor(colors.white)

term.write("Detection Hardware ...")
print()
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
print("Hardware: " .. detected_platform.name)
-- Vérifie si le fichier OS existe et est un fichier valide
if not fs.exists(OS_FILE) or fs.isDir(OS_FILE)  then
    printError("Erreur : '" .. OS_FILE .. "' introuvable ou invalide.")
    return
end

-- Animation de chargement
term.write("Chargement " .. OS_FILE .. " ")
term.setTextColor(colors.cyan)


for i = 1, 3 do
    sleep(0.1)
    term.write(".")
end
term.setTextColor(colors.white)
print("\n")

-- Charge et exécute le fichier OS
--shell.run(OS_FILE,detected_platform.id,detected_platform.name)
