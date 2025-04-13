local logger = require("src.Modules.System.logger")
local helper = require("src.Modules.System.helper")

local version = "1.0.0"

local osUrl = "https://raw.githubusercontent.com/BrauvauGS/CC_RTF/refs/heads/dev/src/RTF_OS/RTF_os.lua"
local osPath = "/RTF/src/RTF_OS/RTF_os.lua"

--obj
local ConsolLog = logger:new()
local helper = helper:new()



-- Main boot function
function boot()
    term.clear()
    term.setCursorPos(1, 1)
    term.setTextColor(colors.cyan)
    print("** RTF Bootloader " .. "[" ..version.."]".." **")
    ConsolLog:log("S","Logger init ok")
    ConsolLog:log("S","Helper init ok " .. helper:getVersion())

end

-- Start the bootloader
boot()
