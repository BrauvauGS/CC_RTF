-- Config
term.clear()
term.setCursorPos(1,1)
local delay_on = 0.5   -- Temps allumé
local delay_off = 0.3  -- Temps éteint
local light_threshold = 5 -- Seuil de lumière (0-15)
print("Runway run")
-- Boucle principale
while true do
    local lever = redstone.getInput("right")              -- Lire levier
    local lightLevel = redstone.getAnalogInput("top") -- Lire capteur de lumière
    print("level : " .. lightLevel)
    if lever and lightLevel < light_threshold then
        -- Si levier activé et lumière faible → clignote
        redstone.setOutput("bottom", true)
        sleep(delay_on)
        redstone.setOutput("bottom", false)
        sleep(delay_off)
    else
        -- Sinon → OFF
        redstone.setOutput("bottom", false)
        sleep(0.1)
    end
end
