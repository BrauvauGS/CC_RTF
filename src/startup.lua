-- Variables
local helperUrl = "https://raw.githubusercontent.com/BrauvauGS/CC_RTF/refs/heads/dev/src/Modules/helper.lua"  -- Replace with your URL
local helperPath = "RTF/src/Modules/helper.lua"  -- Where you want to save helper.lua locally
local helperModuleName = "RTF.src.Modules.helper"

local loggerUrl = "https://raw.githubusercontent.com/BrauvauGS/CC_RTF/refs/heads/dev/src/Modules/logger.lua"  -- Replace with your URL
local loggerPath = "RTF/src/Modules/logger.lua"
local loggerModuleName = "RTF.src.Modules.logger"

local bootloaderUrl = "https://raw.githubusercontent.com/BrauvauGS/CC_RTF/refs/heads/dev/src/bootloader.lua"
local bootloaderPath = "RTF/bootloader.lua"

-- Initialize display
term.clear()
term.setCursorPos(1, 1)
term.setTextColor(colors.cyan)
print("**Downloading logger class**")

-- Check if logger.lua exists
if fs.exists(loggerPath) then
    -- Delete old logger.lua
    fs.delete(loggerPath)
    term.setTextColor(colors.red)
    print("Old logger.lua deleted.")
else
    term.setTextColor(colors.yellow)
    print("logger.lua does not exist. Creating...")
end

-- Download and create the new logger.lua
local file = http.get(loggerUrl)
if file then
    local content = file.readAll()
    file.close()

    -- Open the file in "w" mode to overwrite or create
    local f = fs.open(loggerPath, "w")
    f.write(content)
    f.close()

    term.setTextColor(colors.green)
    print("logger.lua downloaded and replaced successfully.")
else
    term.setTextColor(colors.red)
    print("Error: Failed to download logger.lua.")
end

-- Verify if logger.lua is downloaded
if fs.exists(loggerPath) then
    -- Include logger.lua
    local Logger = require(loggerModuleName)
    local ConsolLog = Logger:new()

    -- Exemple d'utilisation des logs
    ConsolLog:log("info", "Downloading helper.lua...")

    -- Check if helper.lua exists
    if fs.exists(helperPath) then
        -- Delete old helper.lua
        fs.delete(helperPath)
        ConsolLog:log("warning", "Old helper.lua deleted.")
    else
        ConsolLog:log("warning", "helper.lua does not exist. Creating...")
    end

    -- Download and create the new helper.lua
    file = http.get(helperUrl)
    if file then
        local content = file.readAll()
        file.close()

        -- Open the file in "w" mode to overwrite or create
        local f = fs.open(helperPath, "w")
        f.write(content)
        f.close()

        ConsolLog:log("info", "helper.lua downloaded and replaced successfully.")
    else
        ConsolLog:log("error", "Error: Failed to download helper.lua.")
    end

    -- Verify if helper.lua is downloaded
    if fs.exists(helperPath) then
        -- Include helper.lua
        local helper = require(helperModuleName)

        -- Download the bootloader using helper function
        ConsolLog:log("info", "Downloading bootloader...")

        local success = helper.downloadFile(bootloaderUrl, bootloaderPath)

        if success then
            ConsolLog:log("info", "Bootloader downloaded successfully.")
        else
            ConsolLog:log("error", "Error: Failed to download bootloader.")
        end

        -- Wait for a key press to launch the bootloader
        ConsolLog:log("info", "Press any key to launch the bootloader...")

        os.pullEvent("key")

        -- Launch the bootloader
        if fs.exists(bootloaderPath) then
            ConsolLog:log("info", "Launching bootloader...")
            shell.run(bootloaderPath)
        else
            ConsolLog:log("error", "Error: Bootloader file not found.")
        end
    else
        ConsolLog:log("error", "helper.lua was not downloaded, cannot proceed.")
    end
else
    ConsolLog:log("error", "logger.lua was not downloaded, cannot proceed.")
end
