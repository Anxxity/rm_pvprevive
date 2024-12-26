local isDead = false
-- checking if player is dead and showing TextUI
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500) 
        local playerPed = PlayerPedId()
        if IsPedDeadOrDying(playerPed, true) then --checking if dead
            if not isDead then  
                isDead = true   
                Citizen.Wait(2000)  --waiting 2 sec
                if IsPedDeadOrDying(playerPed, true) then
                     --calling function to shown text ui
                end
            end
        elseif isDead then
            isDead = false
             --calling function to hide text ui
        end
        
    end
end)

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