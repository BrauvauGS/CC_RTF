term.clear()
term.setCursorPos(1, 1)

local version = "1.0.0"
local startTime = os.clock()
local status = true


term.setTextColor(colors.cyan)
print("Downloader - Version " .. "[" .. version .. "]" )
term.setTextColor(colors.magenta)
print(">> RTF Download")
term.setTextColor(colors.white)

-- Ensure path exists
local function ensurePath(path)
    local dir = path:match("(.*/)")
    if dir and not fs.exists(dir) then
        fs.makeDir(dir)
    end
end

-- Download module
local function downloadModule(url, path)
    local response = http.get(url)
    if response then
        ensurePath(path)
        local fh = fs.open(path, "w")
        fh.write(response.readAll())
        fh.close()
        response.close()

        term.setTextColor(colors.green)
        print(":) " .. path)
        term.setTextColor(colors.white)
    else
        term.setTextColor(colors.red)
        print(":( " .. path)
        term.setTextColor(colors.white)
        status = false
    end
end

-- Modules
downloadModule(
    "https://raw.githubusercontent.com/BrauvauGS/CC_RTF/refs/heads/dev/src/Modules/System/logger.lua",
    "/RTF/src/Modules/System/logger.lua"
)
downloadModule(
    "https://raw.githubusercontent.com/BrauvauGS/CC_RTF/refs/heads/dev/src/Modules/System/helper.lua",
    "/RTF/src/Modules/System/helper.lua"
)
downloadModule(
    "https://raw.githubusercontent.com/BrauvauGS/CC_RTF/refs/heads/dev/src/bootloader.lua",
    "/RTF/bootloader.lua"
)

-- Timing
local duration = os.clock() - startTime
term.setTextColor(colors.yellow)
print("\nDone in " .. string.format("%.2f", duration) .. "s")
term.setTextColor(colors.white)

-- Final action
if status then
    term.setTextColor(colors.green)
    write(">> Booting")
    for i = 1, 4 do
        write(".")
        sleep(0.8)
    end
    print("")
    term.setTextColor(colors.white)
    shell.run("/RTF/bootloader.lua")
else
    term.setTextColor(colors.red)
    print(">> Error")
    term.setTextColor(colors.white)
end
