playerPed = PlayerPedId()
lib.onCache('ped', function(value)
    playerPed = value
end)

local blacklistedWeapons = {
    `weapon_flashlight`,
    `weapon_stungun`,
    `weapon_petrolcan`
}

local function robPlayer(entity)
    local playerId = NetworkGetPlayerIndexFromPed(entity)
    local serverId = GetPlayerServerId(playerId)
    lib.progressCircle({
        duration = 5200,
        position = 'bottom',
        useWhileDead = false,
        canCancel = false,
        disable = {
            car = true,
            move = false,
        },
        anim = {            
            dict = 'mini@repair',
            clip = 'fixing_a_player'
        },
    }) 

    exports.ox_inventory:openInventory('player', serverId)
end

local function canRobPlayer(entity)
    if IsEntityDead(entity) then
        return false
    end

    if not IsEntityPlayingAnim(entity, 'missminuteman_1ig_2', 'handsup_base', 3) then
        return false
    end

    if not IsPedArmed(playerPed, 1 | 4) then
        return false
    end

    local selectedWeapon = GetSelectedPedWeapon(playerPed)
    for i = 1, #blacklistedWeapons do
        if selectedWeapon == blacklistedWeapons[i] then
            return false
        end
    end
    
    if GetVehiclePedIsIn(playerPed, false) ~= 0 then
        return false
    end

    return true
end

exports.ox_target:addGlobalPlayer({
    name = 'robPlayer',
    icon = 'fa-solid fa-mask',
    label = 'Rob player',
    distance = 1.5,
    onSelect = function(data)
        robPlayer(data.entity)
    end,
    canInteract = function(entity, distance, coords, name, bone)
        return canRobPlayer(entity)
    end
})