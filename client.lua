
local isDead = false
local isInvincible = false
local alphaClients = {}

-- Main thread to monitor player death
Citizen.CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        if IsPedDeadOrDying(playerPed, true) then
            if not isDead then
                isDead = true
                Citizen.Wait(2000)
                if IsPedDeadOrDying(playerPed, true) then
                    showReviveUI()
                end
            end
        elseif isDead then
            isDead = false
            lib.hideTextUI()
        end
        Citizen.Wait(500)
    end
end)

-- Show revive UI
function showReviveUI()
    lib.showTextUI('[E] - Revive', {
        position = 'bottom-center',
        style = {
            backgroundColor = '#FF4C4C',
            color = 'white'
        }
    })

    Citizen.CreateThread(function()
        while isDead do
            if IsControlJustPressed(0, 38) then -- Press 'E'
                lib.hideTextUI()
                startReviveProcess()
                break
            end
            Citizen.Wait(0)
        end
    end)
end

-- Handle the revive process
function startReviveProcess()
    local success = lib.progressBar({
        duration = Config.produration, 
        position = 'bottom',
        useWhileDead = true,
        canCancel = false,
    })

    if success then
        revivePlayer()
    else          
        lib.showTextUI('Reving', {
            position = "bottom-center",
            icon = 'notes-medical',
            style = {
                borderRadius = 0,
                backgroundColor = '#48BB78',
                color = 'white'
            }
        })
        lib.timer(Config.produration, revivePlayer, true)
    end
end

-- Revive the player
function revivePlayer()
    local playerPed = PlayerPedId()
    lib.hideTextUI()
    ResurrectPed(playerPed)
    SetEntityHealth(playerPed, 200)
    ClearPedBloodDamage(playerPed)
    TriggerEvent('esx_status:set', 'health', 100)
    ClearPedTasksImmediately(playerPed)
    LocalPlayer.state:set("dead", false, true)
    isDead = false
    enableTemporaryInvincibility(playerPed)
end

-- Enable temporary invincibility with visual effects
function enableTemporaryInvincibility(playerPed)
    SetEntityInvincible(playerPed, true)
    isInvincible = true

    ExecuteCommand("alpha")
    Citizen.SetTimeout(Config.invtime, function()
        SetEntityInvincible(playerPed, false)
        isInvincible = false
    end)
end

-- Handle alpha effects for clients
RegisterNetEvent('alphaClients', function(author, enable)
    local targetPed = GetPlayerPed(GetPlayerFromServerId(author))
    if enable then
        SetEntityAlpha(targetPed, 102, false)
        alphaClients[author] = targetPed
        Citizen.SetTimeout(Config.invtime, function()
            ResetEntityAlpha(targetPed)
            alphaClients[author] = nil
        end)
    else
        ResetEntityAlpha(targetPed)
        alphaClients[author] = nil
    end
end)

-- Apply alpha effects
Citizen.CreateThread(function()
    while true do
        for _, ped in pairs(alphaClients) do
            SetEntityAlpha(ped, 102, false)
        end
        Citizen.Wait(0)
    end
end)

-- Disable actions while invincible
Citizen.CreateThread(function()
    while true do
        if isInvincible then
            local playerPed = PlayerPedId()
            DisablePlayerFiring(playerPed, true) -- Disable firing
            DisableControlAction(0, 24, true)    -- Disable LEFT MOUSE BUTTON (Shoot)
        end
        Citizen.Wait(0)
    end
end)

-- Anti-whipping measures
Citizen.CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        if IsPedArmed(playerPed, 6) then
            DisableControlAction(1, 140, true) -- Disable melee attack
            DisableControlAction(1, 141, true) -- Disable alternative melee
            DisableControlAction(1, 142, true) -- Disable another melee action
        end
        Citizen.Wait(10)
    end
end)
