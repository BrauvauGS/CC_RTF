-- RTF_os.lua
-- Interface principale de RTF OS

local osName = "RTF OS"
local osVersion = "v1.2.0"

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

-- Dessiner l'interface
local function drawUI()
    local w, h = term.getSize()
    term.clear()

    -- En-tete OS (centre)
    local header = osName .. " " .. osVersion
    local headerX = math.floor((w - #header) / 2)
    term.setCursorPos(headerX, 1)
    term.setTextColor(colors.cyan)
    write(header)

    -- Menu vertical
    for i, item in ipairs(menuItems) do
        term.setCursorPos(2, i + 2)
        if i == selectedIndex then
            term.setTextColor(colors.purple)
            write("[" .. item .. "]")
        else
            term.setTextColor(colors.lightGray)
            write(" " .. item)
        end
    end

    -- Contenu page (titre seulement)
    term.setTextColor(colors.white)
    term.setCursorPos(20, 4)
    print("Page selectionnee : " .. menuItems[selectedIndex])
end

-- Boucle principale
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
                print("RTF OS ferme.")
                break
            else
                term.setCursorPos(20, 6)
                term.setTextColor(colors.lime)
                print("App lancee : " .. selected)
                sleep(1)
            end
        end
        drawUI()
    end
end

-- Lancer l'interface
mainLoop()
