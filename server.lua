local QBCore = exports['qb-core']:GetCoreObject()

local function findPlayersDBFile()
    local resourcePath = GetResourcePath(GetCurrentResourceName())
    for _, relativePath in ipairs(Config.PossiblePaths) do
        local fullPath = resourcePath .. '/' .. relativePath
        local file = io.open(fullPath, 'r')
        if file then
            file:close()
            --Can comment out the line below if you don't want to see this message
            print('Found playersDB.json at: ' .. fullPath)
            return fullPath
        end
    end
    print('Error: Unable to find playersDB.json in any of the specified paths')
    return nil
end

local playersDBPath = findPlayersDBFile()

local function calculatePlaytime(minutes)
    local years = math.floor(minutes / (60 * 24 * 365))
    minutes = minutes % (60 * 24 * 365)
    local months = math.floor(minutes / (60 * 24 * 30))
    minutes = minutes % (60 * 24 * 30)
    local days = math.floor(minutes / (60 * 24))
    minutes = minutes % (60 * 24)
    local hours = math.floor(minutes / 60)
    minutes = minutes % 60
    
    return years, months, days, hours, minutes
end

local function getPlayerPlaytime(source)
    if not playersDBPath then
        print('Error: playersDB.json path not set')
        return nil
    end

    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then 
        print('Error: Unable to get player data for source: ' .. tostring(source))
        return nil 
    end

    local license = Player.PlayerData.license:gsub("license:", "")

    local file = io.open(playersDBPath, 'r')
    if not file then
        print('Error: Unable to open playersDB.json at path: ' .. playersDBPath)
        return nil
    end

    local content = file:read('*all')
    file:close()

    local success, data = pcall(json.decode, content)
    if not success or not data or not data.players then
        print('Error: Invalid JSON data in playersDB.json')
        return nil
    end

    for _, playerData in ipairs(data.players) do
        if playerData.license == license then
            return playerData.playTime
        end
    end

    print('Error: Player not found in playersDB')
    return nil
end

QBCore.Commands.Add('playtime', 'Check your total playtime on the server', {}, false, function(source, args)
    local playTime = getPlayerPlaytime(source)
    if playTime then
        local years, months, days, hours, minutes = calculatePlaytime(playTime)
        TriggerClientEvent('am-playtime:showPlaytime', source, years, months, days, hours, minutes)
    else
        TriggerClientEvent('QBCore:Notify', source, 'Unable to retrieve playtime', 'error')
        print('Failed to retrieve playtime for player ' .. tostring(source))
    end
end)
