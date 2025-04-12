local url = "https://raw.githubusercontent.com/BrauvauGS/CC_RTF/dev/bootloader.lua"
local path = "bootloader.lua"

if fs.exists(path) then fs.delete(path) end
local r = http.get(url)
if r then
    local f = fs.open(path, "w")
    f.write(r.readAll())
    f.close()
    local Bootloader = dofile(path)
    local loader = Bootloader:new()
    loader:boot()
else
    printError("Impossible de charger le bootloader.")
end
