local surrenderKeybind = lib.addKeybind({
    name = 'surrender',
    description = 'Surrend',
    defaultKey = 'Y',
    onPressed = function(self)
        if IsNuiFocused() then return end
        playerPed = playerPed or PlayerPedId()
        lib.hideTextUI()

        StopAnimTask(playerPed, 'missminuteman_1ig_2', 'handsup_base', 1.0)
        Wait(100)
        lib.requestAnimDict('random@arrests@busted', 100)
        TaskPlayAnim(playerPed, 'random@arrests@busted', 'idle_a', 1.5, 1.5, -1, 1, 0, false, false, false)
        
        lib.showTextUI('[Z] - Stop', {
            position = 'right-center',
            icon = 'hand'
        })
        self:disable(true)
    end
}) surrenderKeybind:disable(true)

local handsupKeybind = lib.addKeybind({
    name = 'handsup',
    description = 'Hands up',
    defaultKey = 'Z',
    onPressed = function(self)
        if IsNuiFocused() then return end
        playerPed = playerPed or PlayerPedId()
        lib.hideTextUI()
    
        if not handsUp then
            lib.requestAnimDict('missminuteman_1ig_2', 100)
            TaskPlayAnim(playerPed, 'missminuteman_1ig_2', 'handsup_base', 1.5, 1.5, -1, 50, 0, false, false, false)
            lib.showTextUI('[Y] - kneel down', {
                position = 'right-center',
                icon = 'hand'
            })
            surrenderKeybind:disable(false)
            handsUp = true
            return
        end

        StopAnimTask(playerPed, 'random@arrests@busted', 'idle_a', 1.0)
        StopAnimTask(playerPed, 'missminuteman_1ig_2', 'handsup_base', 1.0)
        handsUp = false
    end
}) handsupKeybind:disable(false)

local handsUp = false

RegisterCommand('handsup', function()
    if IsNuiFocused() then return end
    playerPed = playerPed or PlayerPedId()

    if not handsUp then
        lib.requestAnimDict('missminuteman_1ig_2', 100)
        TaskPlayAnim(playerPed, 'missminuteman_1ig_2', 'handsup_base', 1.5, 1.5, -1, 50, 0, false, false, false)
        handsUp = true
        return
    end

    StopAnimTask(playerPed, 'missminuteman_1ig_2', 'handsup_base', 1.0)
    handsUp = false
end, false)
RegisterKeyMapping('handsup', 'handsup', 'keyboard', 'Z')