-- RTF_os.lua
-- Interface principale de RTF OS avec fenêtres (CC: Tweaked)

local osName = "RTF OS"
local osVersion = "v1.3.0"

-- Recuperation des arguments (utilises plus tard si besoin)
local args = {...}
local platformId = args[1] or "Unknown"
local platformName = args[2] or "Inconnue"

-- Menu vertical
local menuItems = {
    "Commande",
    "Applications",
    "Parametres",
    "Logs",
    "Quitter"
}
local selectedIndex = 1

-- Fonction pour dessiner la fenêtre
local function drawWindow(title, x, y, width, height)
    local window = window.create(term.current(), x, y, width, height)
    window.setBackgroundColor(colors.black)
    window.setTextColor(colors.white)
    window.clear()

    -- Titre de la fenêtre
    window.setCursorPos(2, 1)
    window.setTextColor(colors.cyan)
    window.write(title)

    -- Affichage du menu
    window.setTextColor(colors.lightGray)
    for i, item in ipairs(menuItems) do
        window.setCursorPos(2, i + 2)
        if i == selectedIndex then
            window.setTextColor(colors.purple)
            window.write("[" .. item .. "]")
        else
            window.setTextColor(colors.lightGray)
            window.write(" " .. item)
        end
    end

    return window
end

-- Fonction pour dessiner le contenu (page) à droite
local function drawContent(window, title)
    window.setTextColor(colors.white)
    window.setCursorPos(2, 2)
    window.write("Page selectionnee : " .. title)
end

-- Boucle principale
local function mainLoop()
    local w, h = term.getSize()

    -- Créer les fenêtres
    local menuWindow = drawWindow("Menu", 1, 2, 18, h - 2)
    local contentWindow = window.create(term.current(), 20, 2, w - 20, h - 2)

    -- Afficher le titre de la page à droite
    drawContent(contentWindow, menuItems[selectedIndex])

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
                print("RTF OS ferme.")
                break
            else
                contentWindow.clear()
                contentWindow.setTextColor(colors.lime)
                contentWindow.setCursorPos(2, 2)
                contentWindow.write("App lancee : " .. selected)
                sleep(1)
            end
        end

        -- Redessiner la fenêtre de menu
        menuWindow.clear()
        drawWindow("Menu", 1, 2, 18, h - 2)
        -- Redessiner le contenu de la page
        contentWindow.clear()
        drawContent(contentWindow, menuItems[selectedIndex])
    end
end

-- Lancer l'interface
mainLoop()
