ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)



ESX.RegisterServerCallback('pazzodoktor:doktorsOnline', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xPlayers = ESX.GetPlayers()
	local medicsOnline = 0
	local enoughMoney = false
	if xPlayer.getMoney() >= Config.Price then
		enoughMoney = true
	else
		if xPlayer.getAccount('bank').money >= Config.Price then
		    enoughMoney = true
		end
	end

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'ambulance' then
			medicsOnline = medicsOnline + 1
		end
	end

	cb(medicsOnline, enoughMoney)
end)

RegisterServerEvent('pazzodoktor:odeme')
AddEventHandler('pazzodoktor:odeme', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_ambulance', function(account)
		account.addMoney(Config.Price)
		if xPlayer.getMoney() >= Config.Price then
			xPlayer.removeMoney(Config.Price)
		else
			xPlayer.removeAccountMoney('bank', Config.Price)
		end
	end)
end)