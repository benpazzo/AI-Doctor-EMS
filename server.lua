Config = {}
Config.Ucret = 2000

local CopsConnected  = 0
ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function CountCops()

	local xPlayers = ESX.GetPlayers()

	CopsConnected = 0

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'ambulance' then
			CopsConnected = CopsConnected + 1
		end
	end

	SetTimeout(120 * 1000, CountCops)
end

CountCops()


ESX.RegisterServerCallback('ai_mechanic:doktor', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	cb(CopsConnected)
end)

RegisterServerEvent('ai_mechanic:odeme')
AddEventHandler('ai_mechanic:odeme', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if xPlayer.getBank() >= Config.Ucret then

	xPlayer.removeBank(Config.Ucret)
	TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = 'Muayene için $2000 ödeme yaptın.' })
	TriggerClientEvent('knb:mech', source)
	
	else
	
	TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Bankanda yeteri kadar para yok.' })
	
	end
end)


TriggerEvent('es:addCommand', 'doktor', function(source)
    TriggerEvent('ai_mechanic:odeme', source)
    end)