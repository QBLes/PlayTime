local QBCore = exports['qb-core']:GetCoreObject()

local displayPlaytime = false
local playtimeInfo = ""
local displayDuration = 10000 -- 10 seconds
local displayStartTime = 0

local function DrawPlaytimeInfo()
    if displayPlaytime and GetGameTimer() - displayStartTime < displayDuration then
        DrawRect(0.5, 0.955, 0.20, 0.06, 0, 0, 0, 180)
        SetTextFont(4)
        SetTextProportional(0)
        SetTextScale(0.45, 0.45)
        SetTextColour(255, 255, 255, 255)
        SetTextEntry("STRING")
        SetTextCentre(true)
        AddTextComponentString("PlayTime")
        DrawText(0.5, 0.925)
        SetTextFont(4)
        SetTextProportional(0)
        SetTextScale(0.35, 0.35)
        SetTextColour(255, 255, 255, 255)
        SetTextEntry("STRING")
        SetTextCentre(true)
        AddTextComponentString(playtimeInfo)
        DrawText(0.5, 0.952)
    end
end

RegisterNetEvent('am-playtime:showPlaytime')
AddEventHandler('am-playtime:showPlaytime', function(years, months, days, hours, minutes)
    playtimeInfo = string.format("~g~%d~w~ Year%s, ~y~%d~w~ Month%s, ~b~%d~w~ Day%s, ~p~%d~w~ Hour%s, ~o~%d~w~ Minute%s", 
        years, years ~= 1 and "s" or "",
        months, months ~= 1 and "s" or "",
        days, days ~= 1 and "s" or "",
        hours, hours ~= 1 and "s" or "",
        minutes, minutes ~= 1 and "s" or "")
    displayPlaytime = true
    displayStartTime = GetGameTimer()
end)

CreateThread(function()
    while true do
        Wait(0)
        DrawPlaytimeInfo()
    end
end)