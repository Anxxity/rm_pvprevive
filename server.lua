local alphaClients = {}

RegisterCommand('alpha', function(source, rawCommand)
	alphaClients[source] = alphaClients[source] and nil or true
	TriggerClientEvent('alphaClients', -1, source, alphaClients[source])
end)


RegisterNetEvent('get_bucket')
AddEventHandler('get_bucket', function()
    local targetId = source
    local routingBucket = GetPlayerRoutingBucket(targetId)
    TriggerClientEvent('get_bucket_response', targetId, routingBucket) -- Send routing bucket value back to the client
end)
