-- RTF_os.lua
-- UI principale de l'OS textuel RTF

local osName = "RTF OS"
local osVersion = "v1.1.0"

-- Récupération des arguments du bootloader
local args = {...}
local platformId = args[1] or "Unknown"
local platformName = args[2] or "Inconnue"

-- Liste des options du menu vertical
local menuItems = {
    "Accueil",
    "Applications",
    "Paramètres",
    "Logs",
    "Quitter"
}
local selectedIndex = 1

-- Fonction pour dessiner l'interface utilisateur
local function drawUI()
    local w, h = term.getSize()
    term.clear()

    -- Affichage du nom/version OS centré en haut
    local header = osName .. " " .. osVersion
    local headerX = math.floor((w - #header) / 2)
    term.setCursorPos(headerX, 1)
    term.setTextColor(colors.yellow)
    term.setBackgroundColor(colors.black)
    write(header)

    -- Affichage de la plateforme (à droite)
    local platformStr = "Sur : " .. platformName .. " (" .. platformId .. ")"
    term.setCursorPos(w - #platformStr + 1, 1)
    term.setTextColor(colors.gray)
    write(platformStr)

    -- Menu vertical à gauche
    for i, item in ipairs(menuItems) do
        term.setCursorPos(2, i + 2)
        if i == selectedIndex then
            term.setBackgroundColor(colors.blue)
            term.setTextColor(colors.white)
        else
            term.setBackgroundColor(colors.black)
            term.setTextColor(colors.lightGray)
        end
        write(item .. string.rep(" ", 16 - #item))
    end

    -- Affichage de la "page" à droite
    term.setBackgroundColor(colors.black)
    term.setTextColor(colors.white)
    term.setCursorPos(20, 4)
    print("Page sélectionnée : " .. menuItems[selectedIndex])
end

-- Boucle principale d'interaction
local function mainLoop()
    drawUI()
    while true do
        local event, key = os.pullEvent("key")
        if key == keys.up then
            selectedIndex = selectedIndex - 1
            if selectedIndex < 1 then selectedIndex = #menuItems end
        elseif key == keys.down then
            selectedIndex = selectedIndex + 1
            if selectedIndex > #menuItems then selectedIndex = 1 end
        elseif key == keys.enter then
            local selected = menuItems[selectedIndex]
            if selected == "Quitter" then
                term.clear()
                term.setCursorPos(1, 1)
                print("RTF OS fermé. À bientôt !")
                break
            else
                -- Tu pourras mettre des `app.launch("Logs")` plus tard ici
                term.setCursorPos(20, 6)
                term.setTextColor(colors.lime)
                print("App lancée : " .. selected)
                sleep(1)
            end
        end
        drawUI()
    end
end

-- Lancement de l'interface
mainLoop()
