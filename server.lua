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
        local osrc = GetPlayerIdentifier(id)
        QBCore.Debug(osrc)
        local Player = QBCore.Functions.GetPlayer(osrc)
        QBCore.Debug(Player)
        local citizenid = Player.PlayerData.citizenid
        QBCore.Debug(citizenid)
        local playerskin = MySQL.query.await('SELECT * FROM playerskins WHERE citizenid = ? AND active = ?', {citizenid, 1})
        if playerskin[1] ~= nil then
            pskin = json.decode(playerskin[1].skin)
            pskin.model = pedmodel
            newskin = json.encode(pskin)
            local affectedRows = MySQL.update.await('UPDATE playerskins SET skin = ? WHERE citizenid = ? and active = 1', {newskin, citizenid})
            if affectedRows then
                TriggerClientEvent('ik-giveped:client:SetModel', id, pedmodel)
            end
            MySQL.update('UPDATE playerskins SET model = ? WHERE citizenid = ? and active = 1', {pedmodel, citizenid})
        end
    else
        TriggerClientEvent("QBCore:Notify", src, "Player is not online!", "error")
    end
end)

QBCore.Commands.Add('giveped', "Give ped to a player", {}, false, function(source)
    local src = source
    TriggerClientEvent('ik-giveped:client:openMenu', src)
end, 'admin')