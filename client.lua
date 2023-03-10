local QBCore = exports['qb-core']:GetCoreObject()

local blockedPeds = {
    "mp_m_freemode_01",
    "mp_f_freemode_01",
    "tony",
    "g_m_m_chigoon_02_m",
    "u_m_m_jesus_01",
    "a_m_y_stbla_m",
    "ig_terry_m",
    "a_m_m_ktown_m",
    "a_m_y_skater_m",
    "u_m_y_coop",
    "ig_car3guy1_m",
}

RegisterNetEvent("ik-giveped:client:openMenu", function() 
    local dialog = exports['qb-input']:ShowInput({
        header = "Give Ped Character",
        submitText = "Give character",
        inputs = {
            {
                text = "Player ID (#)", 
                name = "id",
                type = "text",
                isRequired = true,
            },
            {
                text = "Ped Model",
                name = "pedmodel",
                type = "text",
                isRequired = true,
            },
        },
    })

    if dialog ~= nil then
        if dialog.id and dialog.pedmodel then
            TriggerServerEvent("ik-giveped:server:setPed", dialog.id, dialog.pedmodel)
        else
            QBCore.Functions.Notify('You need to fill in both values!', 'error', 4500)
        end
    end
end)

local function LoadPlayerModel(skin)
    RequestModel(skin)
    while not HasModelLoaded(skin) do
      Wait(0)
    end
end

local function isPedAllowedRandom(skin)
    local retval = false
    for _, v in pairs(blockedPeds) do
        if v ~= skin then
            retval = true
        end
    end
    return retval
end

RegisterNetEvent('ik-giveped:client:SetModel', function(skin)
    local ped = PlayerPedId()
    local model = GetHashKey(skin)
    SetEntityInvincible(ped, true)

    if IsModelInCdimage(model) and IsModelValid(model) then
        LoadPlayerModel(model)
        SetPlayerModel(PlayerId(), model)

        if isPedAllowedRandom(skin) then
            SetPedRandomComponentVariation(ped, true)
        end

		SetModelAsNoLongerNeeded(model)
	end
	SetEntityInvincible(ped, false)
    Wait(500)
    TriggerEvent('ik-giveped:client:setPlayerSkin')
end)

RegisterNetEvent('ik-giveped:client:setPlayerSkin', function()
    local ped = PlayerPedId()
    local appearance = exports['fivem-appearance']:getPedAppearance(ped)
    TriggerServerEvent('fivem-appearance:server:saveAppearance', appearance)
end)