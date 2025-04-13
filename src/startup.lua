-- Initialize display
term.clear()
term.setCursorPos(1, 1)
term.setTextColor(colors.magenta)
print("**Instal**")

local Looger = http.get("https://raw.githubusercontent.com/BrauvauGS/CC_RTF/refs/heads/dev/src/Modules/logger.lua")
local fh = fs.open("/RTF/src/Modules/logger.lua", "w")
fh.write(Looger.readAll())
fh.close()

local helper = http.get("https://raw.githubusercontent.com/BrauvauGS/CC_RTF/refs/heads/dev/src/Modules/helper.lua")
local fh = fs.open("/RTF/src/Modules/helper.lua", "w")
fh.write(helper.readAll())
fh.close()
