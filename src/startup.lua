-- Variables
local helperUrl = "https://raw.githubusercontent.com/BrauvauGS/CC_RTF/refs/heads/dev/src/Modules/helper.lua"  -- Replace with your URL
local helperPath = "RTF/src/Modules/helper.lua"  -- Where you want to save helper.lua locally
local helperModuleName = "RTF.src.Modules.helper"

local loggerUrl = "https://raw.githubusercontent.com/BrauvauGS/CC_RTF/refs/heads/dev/src/Modules/helper.lua"  -- Replace with your URL
local loggerPath = "RTF/src/Modules/logger.lua"  

local bootloaderUrl = "https://raw.githubusercontent.com/BrauvauGS/CC_RTF/refs/heads/dev/src/bootloader.lua"
local bootloaderPath = "RTF/bootloader.lua"

-- Initialize display
term.clear()
term.setCursorPos(1, 1)
term.setTextColor(colors.cyan)
print("Downloading helper.lua...")

-- Check if helper.lua exists
if fs.exists(helperPath) then
    -- Delete old helper.lua
    fs.delete(helperPath)
    term.setTextColor(colors.red)
    print("Old helper.lua deleted.")
else
    term.setTextColor(colors.yellow)
    print("helper.lua does not exist. Creating...")
end

-- Download and create the new helper.lua
local file = http.get(helperUrl)
if file then
    local content = file.readAll()
    file.close()

    -- Open the file in "w" mode to overwrite or create
    local f = fs.open(helperPath, "w")
    f.write(content)
    f.close()

    term.setTextColor(colors.green)
    print("helper.lua downloaded and replaced successfully.")
else
    term.setTextColor(colors.red)
    print("Error: Failed to download helper.lua.")
end

-- Verify if helper.lua is downloaded
if fs.exists(helperPath) then
    -- Include helper.lua
    local helper = require(helperModuleName)

    -- Use helper.downloadFile to download bootloader
    term.setTextColor(colors.cyan)
    print("Downloading dependency...")
    -- Download the bootloader using helper function
    local success = helper.downloadFile(bootloaderUrl, bootloaderPath)

    if success then
        term.setTextColor(colors.green)
        print("Bootloader downloaded successfully.")
    else
        term.setTextColor(colors.red)
        print("Error: Failed to download bootloader.")
    end




    print("Downloading bootloader...")

    -- Download the bootloader using helper function
    local success = helper.downloadFile(bootloaderUrl, bootloaderPath)

    if success then
        term.setTextColor(colors.green)
        print("Bootloader downloaded successfully.")
    else
        term.setTextColor(colors.red)
        print("Error: Failed to download bootloader.")
    end

    -- Wait for a key press to launch the bootloader
    term.setTextColor(colors.cyan)
    print("Press any key to launch the bootloader...")

    os.pullEvent("key")

    -- Launch the bootloader
    if fs.exists(bootloaderPath) then
        term.setTextColor(colors.green)
        print("Launching bootloader...")
        shell.run(bootloaderPath)
    else
        term.setTextColor(colors.red)
        print("Error: Bootloader file not found.")
    end
else
    term.setTextColor(colors.red)
    print("helper.lua was not downloaded, cannot proceed.")
end
