

local osUrl = "https://raw.githubusercontent.com/BrauvauGS/CC_RTF/refs/heads/dev/src/RTF_OS/RTF_os.lua"
local osPath = "/RTF/src/RTF_OS/RTF_os.lua"


-- Create necessary directories
function createSystemDirectories()
    if not fs.exists("RTF") then fs.makeDir("RTF") end
    if not fs.exists("RTF/src") then fs.makeDir("RTF/src") end
    if not fs.exists("RTF/src/RTF_OS") then fs.makeDir("RTF/src/RTF_OS") end
    if not fs.exists("RTF/src/APPS") then fs.makeDir("RTF/src/APPS") end
    if not fs.exists("RTF/src/Modules") then fs.makeDir("RTF/src/Modules") end
end



-- Main boot function
function boot()
    term.clear()
    term.setCursorPos(1, 1)
    term.setTextColor(colors.cyan)

    print("** RTF Bootloader **")
    createSystemDirectories()

end

-- Start the bootloader
boot()
