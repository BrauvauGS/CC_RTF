-- Variables
local bootloaderUrl = "https://raw.githubusercontent.com/BrauvauGS/CC_RTF/refs/heads/dev/src/bootloader.lua"
local bootloaderPath = "RTF/src/bootloader.lua"

-- Create the RTF folder if it doesn't exist
if not fs.exists("RTF") then
    fs.makeDir("RTF")
end

-- Initialize display
term.clear()
term.setCursorPos(1, 1)
term.setTextColor(colors.cyan)
print("**Downloading bootloader**")

-- Delete old bootloader if it exists
if fs.exists(bootloaderPath) then
    fs.delete(bootloaderPath)
    term.setTextColor(colors.yellow)
    print("Old bootloader deleted.")
end

-- Download the bootloader
local file = http.get(bootloaderUrl)
if file then
    local content = file.readAll()
    file.close()

    -- Save the bootloader to the local path
    local f = fs.open(bootloaderPath, "w")
    f.write(content)
    f.close()

    term.setTextColor(colors.green)
    print("Bootloader downloaded successfully.")
else
    term.setTextColor(colors.red)
    print("Error: Failed to download bootloader.")
end

-- Wait for a key press to launch the bootloader
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
