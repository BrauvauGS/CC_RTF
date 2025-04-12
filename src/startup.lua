-- Variables
local helperUrl = "https://raw.githubusercontent.com/TON_USER/TON_REPO/main/helper.lua"  -- Remplace avec ton URL
local helperPath = "RTF/src/Modules/helper.lua"  -- Où tu veux sauvegarder helper.lua localement

local bootloaderUrl = "https://raw.githubusercontent.com/BrauvauGS/CC_RTF/refs/heads/dev/src/bootloader.lua"
local bootloaderPath = "RTF/bootloader.lua"

-- Initialisation de l'affichage
term.clear()
term.setCursorPos(1, 1)
term.setTextColor(colors.cyan)
print("Téléchargement de helper.lua...")

-- Vérifier si helper.lua existe
if fs.exists(helperPath) then
    -- Supprimer l'ancien helper.lua
    fs.delete(helperPath)
    term.setTextColor(colors.red)
    print("Ancien helper.lua supprimé.")
else
    term.setTextColor(colors.yellow)
    print("helper.lua n'existe pas. Création...")
end

-- Télécharger et créer le nouveau helper.lua
local file = http.get(helperUrl)
if file then
    local content = file.readAll()
    file.close()

    -- Ouvrir le fichier en mode "w" pour écraser ou créer
    local f = fs.open(helperPath, "w")
    f.write(content)
    f.close()

    term.setTextColor(colors.green)
    print("helper.lua téléchargé et remplacé avec succès.")
else
    term.setTextColor(colors.red)
    print("Erreur : Échec du téléchargement de helper.lua.")
end

-- Vérifier si helper.lua est bien téléchargé
if fs.exists(helperPath) then
    -- Inclure helper.lua
    require("RTF.helper")

    -- Télécharger le bootloader
    term.setTextColor(colors.cyan)
    print("Téléchargement du bootloader...")

    local file = http.get(bootloaderUrl)
    if file then
        local content = file.readAll()
        file.close()
        local f = fs.open(bootloaderPath, "w")
        f.write(content)
        f.close()
        term.setTextColor(colors.green)
        print("Bootloader téléchargé avec succès.")
    else
        term.setTextColor(colors.red)
        print("Erreur : Échec du téléchargement du bootloader.")
    end

    -- Attendre la pression d'une touche pour lancer le bootloader
    term.setTextColor(colors.cyan)
    print("Appuyez sur n'importe quelle touche pour lancer le bootloader...")

    os.pullEvent("key")

    -- Lancer le bootloader
    if fs.exists(bootloaderPath) then
        term.setTextColor(colors.green)
        print("Lancement du bootloader...")
        shell.run(bootloaderPath)
    else
        term.setTextColor(colors.red)
        print("Erreur : Le fichier bootloader n'a pas été trouvé.")
    end
else
    term.setTextColor(colors.red)
    print("helper.lua n'a pas été téléchargé, impossible de continuer.")
end
