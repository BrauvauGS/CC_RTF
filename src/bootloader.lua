local logger = require("src.Modules.System.logger")
local helper = require("src.Modules.System.helper")

local version = "1.0.1"

local osUrl = "https://raw.githubusercontent.com/BrauvauGS/CC_RTF/refs/heads/dev/src/RTF_OS/RTF_os.lua"
local osPath = "/RTF/src/RTF_OS/RTF_os.lua"

--obj
local ConsolLog = logger:new()
local h = helper:new()



-- Main boot function
function boot()
    term.clear()
    term.setCursorPos(1, 1)

    term.setTextColor(colors.cyan)
    print("****************************")
    print("*  RTF Bootloader v" .. version .. "   *")
    print("****************************")
    term.setTextColor(colors.white)

    ConsolLog:log("S","Logger V".. ConsolLog:getVersion() .." loaded")
    ConsolLog:log("S","Helper V".. h:getVersion() .." loaded")

    local platform = h:getPlatform()
    ConsolLog:log("I","Platform ID :".. platform.id .." name : " .. platform.name)

    local success = h:downloadFile(osUrl, osPath)
    if success == true then
        ConsolLog:log("D","RTF_os dowloaded")
        ConsolLog:log("S"," Run RTF OS")
        for i = 1, 4 do
            write(".")
            sleep(0.8)
        end
        shell.run(osPath, platform.id, platform.name)
    else
        ConsolLog:log("E","RTF_os dowload")
    end

end

-- Start the bootloader
boot()
