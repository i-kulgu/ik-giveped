local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent("ik-giveped:server:setPed",function(id,pedmodel)
    local src = source
    local online = false
    for _, playerId in ipairs(GetPlayers()) do
        if playerId == id then
            online = true
            break
        end
    end
    if online then
        TriggerClientEvent('ik-giveped:client:SetModel', id, pedmodel)
    else
        TriggerClientEvent("QBCore:Notify", src, "Player is not online!", "error")
    end
end)

QBCore.Commands.Add('giveped', "Give ped character to player", {}, false, function(source)
    local src = source
    TriggerClientEvent('ik-giveped:client:openMenu', src)
end, 'admin')