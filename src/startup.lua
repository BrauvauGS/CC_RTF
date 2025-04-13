-- Initialize display
local startTime = os.clock()
term.clear()
term.setCursorPos(1, 1)
term.setTextColor(colors.magenta)
print("**Download from the RTF repository**")


local function downloadModule(url, path)
    local response = http.get(url)
    if response then
        local fh = fs.open(path, "w")
        fh.write(response.readAll())
        fh.close()
        response.close()
    else
        printError("Failed to download: " .. url)
    end
end


downloadModule("https://raw.githubusercontent.com/BrauvauGS/CC_RTF/refs/heads/dev/src/Modules/logger.lua", "/RTF/src/Modules/logger.lua")
downloadModule("https://raw.githubusercontent.com/BrauvauGS/CC_RTF/refs/heads/dev/src/Modules/helper.lua", "/RTF/src/Modules/helper.lua")
downloadModule("https://raw.githubusercontent.com/BrauvauGS/CC_RTF/refs/heads/dev/src/bootloader.lua", "/RTF/bootloader.lua")


local duration = os.clock() - startTime
term.setTextColor(colors.yellow)
print("Downloaded in " .. string.format("%.2f", duration) .. " seconds")


shell.run("/RTF/bootloader.lua")