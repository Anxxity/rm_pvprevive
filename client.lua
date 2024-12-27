local isDead = false
local isinv = false
-- checking if player is dead and showing OX_TextUI
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500) 
        local playerPed = PlayerPedId()

        if IsPedDeadOrDying(playerPed, true) then--checking if dead
            if not isDead then
                isDead = true
                Citizen.Wait(2000)  
                if IsPedDeadOrDying(playerPed, true) then --? 
                    showReviveUI()   --calling function to shown text ui
                end
            end
        elseif isDead then
            isDead = false
            lib.hideTextUI() --calling function to hide text ui
        end

        if isinv then
            -- print("disco") --for testing
            DisablePlayerFiring(playerPed, true)  -- Disable firing
            DisableControlAction(0, 24, true)     -- Disable LEFT MOUSE BUTTON (Shoot)
        end
        
        
    end
end)

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
            Citizen.Wait(0)
            if IsControlJustPressed(0, 38) then 
                lib.hideTextUI()
                startReviveProcess()  -- calling to reviveplayer 
                break
            end
        end
    end)
end

function startReviveProcess()

    local success = lib.progressBar({
        duration = 3000, -- 3 seconds
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
        local timer = lib.timer(3000, function()
         
            revivePlayer()
        end, true)
    end
end

function revivePlayer()
    lib.hideTextUI()
    local playerPed = PlayerPedId()
    ResurrectPed(playerPed)                  --
    SetEntityHealth(playerPed, 200)          --
    ClearPedBloodDamage(playerPed)           --
    SetEntityInvincible(playerPed, false)    --
    ClearPedTasksImmediately(playerPed)      --
    LocalPlayer.state:set("dead", false, true) --ox inventory to set busy status yo false
    isDead = false
    SetEntityInvincible(playerPed, true)
    Citizen.Wait(5000)
    SetEntityInvincible(playerPed, false)

end