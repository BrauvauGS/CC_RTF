-- Variables
local osUrl = "https://raw.githubusercontent.com/BrauvauGS/CC_RTF/refs/heads/dev/src/RTF_OS/RTF_os.lua"
local osPath = "RTF/src/RTF_OS/RTF_os.lua"

-- Create necessary directories
function createDirectories()
    if not fs.exists("RTF") then fs.makeDir("RTF") end
    if not fs.exists("RTF/src") then fs.makeDir("RTF/src") end
    if not fs.exists("RTF/src/RTF_OS") then fs.makeDir("RTF/src/RTF_OS") end
end

-- Download a file
function downloadFile(url, destination)
    local fileContent = http.get(url)
    if fileContent then
        local fileHandler = fs.open(destination, "w")
        fileHandler.write(fileContent.readAll())
        fileHandler.close()
        return true
    else
        printError("Error downloading " .. url)
        return false
    end
end

-- Main boot function
function boot()
    term.clear()
    term.setCursorPos(1, 1)

    print("** RTF Bootloader **")
    createDirectories()

    -- Download and run OS
    print("Downloading OS...")
    if downloadFile(osUrl, osPath) then
        print("OS downloaded successfully.")
        
        -- Set platform: id = 1, name = "Advanced_Computer"
        local platform = { id = 1, name = "Advanced_Computer" }
        print("Running OS on platform: " .. platform.name)
        shell.run(osPath, platform.id, platform.name)  -- Run OS with platform params
    else
        printError("Error downloading OS.")
    end
end

-- Start the bootloader
boot()
