-- RTF_os.lua
-- Interface principale de RTF OS avec fenêtres (CC: Tweaked)

local osName = "RTF OS"
local osVersion = "v1.4.0"

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
    -- Créer la fenêtre
    local win = window.create(term.current(), x, y, width, height)
    win.setBackgroundColor(colors.black)
    win.setTextColor(colors.white)
    win.clear()

    -- Titre de la fenêtre
    win.setCursorPos(2, 1)
    win.setTextColor(colors.cyan)
    win.write(title)

    -- Retourner la fenêtre créée
    return win
end

-- Fonction pour dessiner le menu dans la fenêtre
local function drawMenu(window)
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
end

-- Fonction pour dessiner le contenu à droite
local function drawContent(window)
    window.clear()
    window.setTextColor(colors.white)
    window.setCursorPos(2, 2)
    window.write("Page sélectionnée : " .. menuItems[selectedIndex])
end

-- Boucle principale
local function mainLoop()
    local w, h = term.getSize()

    -- Créer les fenêtres
    local menuWindow = drawWindow("Menu", 1, 2, 18, h - 2)
    local contentWindow = window.create(term.current(), 20, 2, w - 20, h - 2)

    -- Afficher le contenu initial
    drawContent(contentWindow)
    drawMenu(menuWindow)

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
                contentWindow.write("App lancée : " .. selected)
                sleep(1)
            end
        end

        -- Redessiner le menu et le contenu après chaque événement
        drawMenu(menuWindow)
        drawContent(contentWindow)
    end
end

-- Lancer l'interface
mainLoop()
