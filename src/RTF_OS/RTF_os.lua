--[[term.clear()
term.setCursorPos(1,1)]]

-- Récupérer le nom de la plateforme passé en argument
local args = { ... }

local OS_NAME = "RTF_OS"
local OS_NAME_PROMPT = "RTF"
local OS_VERSION = "V0.1"
local cwd = "/" -- Dossier courant
local history = {} -- Historique des commandes

-- Fonction pour afficher la bannière
local function showBanner()
    term.setTextColor(colors.purple)
    print("*******************")
    --print("*                 *")
    print("*   ".. OS_NAME .. " " .. OS_VERSION.. "   *")
   -- print("*                 *")
    print("*******************")
    write("ID:    ")
    term.setTextColor(colors.cyan)
    print("\" " .. os.getComputerID() .. " \"")
    term.setTextColor(colors.purple)
    write("LABEL: ")
    term.setTextColor(colors.cyan)
    print("\" " .. os.getComputerLabel().." \"")
    term.setTextColor(colors.purple)
    print()
    term.setTextColor(colors.white)

    -- Affichage du nom de la plateforme
    term.setTextColor(colors.green)
   --local ID_platforme = args[1]
    --local Name_platforme = args[2]
    print("ID_platforme : "..args[1].."  Platform: " .. args[2])
    term.setTextColor(colors.white)

end

local function drawPrompt()
    term.setTextColor(colors.green)
    write("[")

    term.setTextColor(colors.purple)
    write(OS_NAME_PROMPT)

    term.setTextColor(colors.green)
    write("]")

    term.setTextColor(colors.cyan)
    write(cwd)  -- Affiche le chemin complet du répertoire courant

    term.setTextColor(colors.purple)
    write(": ")
    term.setTextColor(colors.white)
end

local function debug(pTexte)
    term.setTextColor(colors.yellow)
    write("[DEBUG]: ")
    term.setTextColor(colors.white)
    print(pTexte)
end

-- Fonction pour exécuter une commande
local function runCommand(command)
    -- Si la commande est vide, ne rien faire

   
    if command == "" then
        
        return true
    end

    table.insert(history, command) -- Ajoute à l'historique

    local args = {}

    for word in command:gmatch("%S+") do 
        table.insert(args, word) 
    end

    if #args == 0 then 
        return true 
    end -- Si vide, ne rien faire

    local cmd = args[1]
    
    if cmd == "ls" then
        -- Liste les fichiers du dossier courant
        local files = fs.list(cwd)
        for _, file in ipairs(files) do
            local fullPath = fs.combine(cwd, file)
            if fs.isDir(fullPath) then
                term.setTextColor(colors.cyan) -- Dossiers en violet
            else
                term.setTextColor(colors.white) -- Fichiers en blanc
            end
            print(file)
        end
        term.setTextColor(colors.white)

    elseif cmd == "cd" then
        -- Change de dossier
        if args[2] then
            local newDir = shell.resolve(args[2])
            if fs.isDir(newDir) then
                cwd = newDir  -- Met à jour le cwd avec le chemin absolu
            else
                term.setTextColor(colors.orange)
                print("Dossier introuvable.")
                term.setTextColor(colors.white)
            end
        else
            term.setTextColor(colors.orange)
            print("Usage: cd <dossier>")
            term.setTextColor(colors.white)
        end

    elseif cmd == "clear" or cmd ==  "cls" then
        -- Nettoie l'écran
        term.clear()
        term.setCursorPos(1,1)


    elseif cmd == "exit" or cmd == "shutdown" then
        -- Quitte le shell
        print("\n")
        print("Fermeture de " .. OS_NAME .. "...")
        term.setTextColor(colors.purple)
        for i = 10, 1, -1 do
            sleep(0.1)
            term.write("#")
        end
        os.shutdown()
        return false

    elseif cmd == "version" then
        -- Quitte le shell
        term.setTextColor(colors.cyan)
        write(OS_NAME .. " " ..  OS_VERSION)
        print("")
        

    elseif cmd == "reboot" then
        -- Reboot OS
        print("")
        print(OS_NAME .. " Reboot")
        term.setTextColor(colors.purple)
        for i = 10, 1, -1 do
            sleep(0.1)
            term.write("#")
        end
        --shell.run("startup.lua")
        os.reboot()

    else
        -- Tente d’exécuter un programme
        if fs.exists(cmd) then

            shell.run(cmd, table.unpack(args, 2))
        else
            term.setTextColor(colors.orange)
            print("Commande inconnue : " .. cmd)
            term.setTextColor(colors.white)
        end
    end
    return true
end

-- Lancement du shell
showBanner()
while true do
    drawPrompt()
    local input = read(nil, history) -- Active l'historique des commandes
    if not runCommand(input) then   
        break
    end
end
