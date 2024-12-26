local isDead = false
-- checking if player is dead and showing OX_TextUI
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500) 
        local playerPed = PlayerPedId()
        if IsPedDeadOrDying(playerPed, true) then --checking if dead
            if not isDead then  
                isDead = true   
                Citizen.Wait(2000)  --waiting 2 sec
                if IsPedDeadOrDying(playerPed, true) then
                    showReviveUI()   --calling function to shown text ui
                end
            end
        elseif isDead then
            isDead = false
            lib.hideTextUI() --calling function to hide text ui
        end
        
    end
end)

function startReviveProcess() 

    local success = lib.progressBar({
        duration = 3000, -- 3 seconds
        position = 'bottom',
        useWhileDead = true,
        canCancel = false,
    })

    if success then
        revivePlayer()  -- calling to reviveplayer 
    end
end

function revivePlayer()
end

--anti wipping added for pvp 
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        
        if IsPedArmed(PlayerPedId(), 6) then
	        DisableControlAction(1, 140, true)
            DisableControlAction(1, 141, true)
            DisableControlAction(1, 142, true)
        end
        
    end
end)