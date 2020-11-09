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


ESX.RegisterServerCallback('pazzodoktor:doktor', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	cb(CopsConnected)
end)

RegisterServerEvent('pazzodoktor:odeme')
AddEventHandler('pazzodoktor:odeme', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_ambulance', function(account)
              account.addMoney(Config.Ucret)
              xPlayer.removeBank(Config.Ucret)
			  end)
end)

ESX.RegisterServerCallback('pazzodoktor:checkMoney', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	cb(xPlayer.getBank('money') >= Config.Ucret)
end)