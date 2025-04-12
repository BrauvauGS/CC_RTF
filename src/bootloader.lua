-- Variables
local osUrl = "https://raw.githubusercontent.com/BrauvauGS/CC_RTF/refs/heads/dev/src/RTF_OS/RTF_os.lua"
local osPath = "RTF/src/RTF_OS/RTF_os.lua"

local loggerUrl = "https://raw.githubusercontent.com/BrauvauGS/CC_RTF/refs/heads/dev/src/Modules/logger.lua"
local loggerPath = "RTF/src/Modules/logger.lua"
local loggerModuleName = "Modules.logger"

local Logger
local ConsolLog

-- Create necessary directories
function createSystemDirectories()
    if not fs.exists("RTF") then fs.makeDir("RTF") end
    if not fs.exists("RTF/src") then fs.makeDir("RTF/src") end
    if not fs.exists("RTF/src/RTF_OS") then fs.makeDir("RTF/src/RTF_OS") end
    if not fs.exists("RTF/src/APPS") then fs.makeDir("RTF/src/APPS") end
    if not fs.exists("RTF/src/Modules") then fs.makeDir("RTF/src/Modules") end
end

-- Download a file
function downloadFile(url, destination)
    local fileContent = http.get(url)
    if fileContent then
        local fileHandler = fs.open(destination, "w")
        fileHandler.write(fileContent.readAll())
        fileHandler.close()
        fileContent.close()
        return true
    else
        printError("Erreur de téléchargement pour " .. url)
        return false
    end
end

-- Main boot function
function boot()
    term.clear()
    term.setCursorPos(1, 1)

    print("** RTF Bootloader **")
    createSystemDirectories()

    -- Download and initialize the logger
    print("Downloading logger...")
    if downloadFile(loggerUrl, loggerPath) then
        print("Logger downloaded successfully.")

        -- Verify if the file exists before loading
        if fs.exists(loggerPath) then
            print("logger.lua exists. Loading module...")

            -- Use pcall to load the logger and handle errors gracefully
            local success, err = pcall(function()
                Logger = require(loggerModuleName)
                ConsolLog = Logger:new()
                ConsolLog:log("system", "Logger initialized successfully")
            end)
            if not success then
                printError("Error loading logger: " .. err)
                return
            end

            -- Download and run OS
            print("Downloading OS...")
            if downloadFile(osUrl, osPath) then
                print("OS downloaded successfully.")

                -- Define platform: id = 1, name = "Advanced_Computer"
                local platform = { id = 1, name = "Advanced_Computer" }
                print("Running OS on platform: " .. platform.name)
               -- shell.run(osPath, platform.id, platform.name)  -- Run the OS with platform params
            else
                printError("Error downloading OS.")
            end
        else
            printError("Error: logger.lua was not downloaded.")
        end
    else
        printError("Error downloading the logger.")
    end
end

-- Start the bootloader
boot()
