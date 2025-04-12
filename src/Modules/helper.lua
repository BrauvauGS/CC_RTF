-- RTF/helper.lua
local helper = {}

-- Function to download a file from a URL and save it locally
function helper.downloadFile(url, destination)
    -- Check if the URL is valid
    if not url or url == "" then
        printError("Error: Invalid URL.")
        return false
    end

    -- Check if the destination path is valid
    if not destination or destination == "" then
        printError("Error: Invalid destination path.")
        return false
    end

    -- Try to fetch the file from the URL
    local file = http.get(url)
    if not file then
        printError("Error: Failed to download from " .. url)
        return false
    end

    -- Read the content of the downloaded file
    local content = file.readAll()
    file.close()

    -- Check if the content is empty
    if content == "" then
        printError("Error: Downloaded file is empty.")
        return false
    end

    -- Create or overwrite the local file at the specified path
    local f = fs.open(destination, "w")
    if not f then
        printError("Error: Failed to open file for writing.")
        return false
    end

    -- Write the content to the local file
    f.write(content)
    f.close()

    -- Confirm success
    print("File downloaded and saved to " .. destination)
    return true
end

return helper