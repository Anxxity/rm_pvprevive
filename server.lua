local alphaClients = {}

RegisterCommand('alpha', function(source, rawCommand)
	alphaClients[source] = alphaClients[source] and nil or true
	TriggerClientEvent('alphaClients', -1, source, alphaClients[source])
end)
