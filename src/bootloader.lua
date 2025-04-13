-- Variables

local loggerUrl = "https://raw.githubusercontent.com/BrauvauGS/CC_RTF/refs/heads/dev/src/Modules/logger.lua"
local loggerPath = "RTF/src/Modules/logger.lua"
local loggerModuleName = "Modules.logger"

local helperUrl = "https://raw.githubusercontent.com/BrauvauGS/CC_RTF/refs/heads/dev/src/Modules/helper.lua"
local helperPath = "RTF/src/Modules/helper.lua"  
local helperModuleName = "Modules.helper"

local osUrl = "https://raw.githubusercontent.com/BrauvauGS/CC_RTF/refs/heads/dev/src/RTF_OS/RTF_os.lua"
local osPath = "RTF/src/RTF_OS/RTF_os.lua"

local ConsolLog
local helper
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
    term.setTextColor(colors.cyan)

    print("** RTF Bootloader **")
    createSystemDirectories()

    -- Download and initialize the logger
    term.setTextColor(colors.lightBlue)
    print("Downloading logger...")
    if downloadFile(loggerUrl, loggerPath) then

        -- Verify if the file exists before loading
        if fs.exists(loggerPath) then

            -- Use pcall to load the logger and handle errors gracefully
            local success, err = pcall(function()
                local Logger = require(loggerModuleName)
                ConsolLog = Logger:new()
                ConsolLog:log("I", "Logger initialized successfully")
            end)
            if not success then
                printError("Error loading logger: " .. err)
                return
            end
            ConsolLog:log("D", "Downloading helper...")
            if downloadFile(helperUrl, helperPath) then

                -- Verify if the file exists before loading
                if fs.exists(helperPath) then

                    -- Use pcall to load the logger and handle errors gracefully
                    local success, err = pcall(function()
                        local Rtfhelper = require(helperModuleName)
                        helper = Rtfhelper:new()
                        ConsolLog:log("I", "helper initialized successfully")
                    end)
                    if not success then
                        ConsolLog:log("E", "loading logger: " .. err)
                        return
                    end
                    -- Download and run OS
                    ConsolLog:log("D", "Downloading OS...")
                    if helper:downloadFile(osUrl, osPath) then

                        -- Define platform: id = 1, name = "Advanced_Computer"
                        local platform = { id = 1, name = "Advanced_Computer" }
                        ConsolLog:log("I", "Running OS on platform: " .. platform.name)
                    -- shell.run(osPath, platform.id, platform.name)  -- Run the OS with platform params
                    else
                        ConsolLog:log("E", "downloading OS.")
                    end
                end
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
