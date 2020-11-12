ESX = nil
PlayerData = {}
bekleme = true

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterCommand("aimedic", function(source, args, raw)
    ESX.TriggerServerCallback('esx_ambulancejob:getDeathStatus', function(isDead)
		if isDead and bekleme then
            ESX.TriggerServerCallback('pazzodoktor:doktorsOnline', function(EMSOnline, hasEnoughMoney)
				if EMSOnline <= Config.Doktor and hasEnoughMoney then
					TriggerEvent("pazzodoktor:canlan")
					TriggerServerEvent('pazzodoktor:odeme')
					bekleme = false
				else
					if EMSOnline >= Config.Doktor then
					    ESX.ShowNotification(_U('to_many_medics'))
					else
						ESX.ShowNotification(_U('not_enough_money'))
					end	
				end
			end)
		else
			ESX.ShowNotification(_U('only_when_dead'))
		end
	end)
end)

AddEventHandler("pazzodoktor:canlan", function()
    player = GetPlayerPed(-1)
    playerPos = GetEntityCoords(player)

    local doktorkod = GetHashKey(doktorPed.model)
    RequestModel(doktorkod)

    while not HasModelLoaded(doktorkod) and RequestModel(doktorkod) do
        RequestModel(doktorkod)
        Citizen.Wait(0)
    end

    	if DoesEntityExist(doktorkod) then
			DoktorNPC(playerPos.x, playerPos.y, playerPos.x, doktorkod)
		else
			DoktorNPC(playerPos.x, playerPos.y, playerPos.x, doktorkod)
		end
		ClearPedTasksImmediately(player)
end)

function DoktorNPC(x, y, z, doktorkod)
        
        DoktorP = CreatePed(4, doktorkod, GetEntityCoords(player), spawnHeading, true, false)  
		
		RequestAnimDict("mini@cpr@char_a@cpr_str")
		while not HasAnimDictLoaded("mini@cpr@char_a@cpr_str") do
		Citizen.Wait(1000)
		end
		
		TaskPlayAnim(DoktorP, "mini@cpr@char_a@cpr_str","cpr_pumpchest",1.0, 1.0, -1, 9, 1.0, 0, 0, 0)
		
		cagirma(DoktorP)
end

function cagirma(DoktorP)
	if Config.MythicProgbar then
        exports['mythic_progbar']:Progress({
        	name = "unique_action_name",
        	duration = 20000,
        	label = _U('getting_treatment'),
        	useWhileDead = true,
        	canCancel = false,
        	controlDisables = {
        		disableMovement = true,
        		disableCarMovement = true,
        		disableMouse = false,
        		disableCombat = true,
        	},
        })
        Citizen.Wait(20000)
        	ClearPedTasks(DoktorP)
			Tedavi(DoktorP)
	else
		ESX.ShowNotification(_U('getting_treatment'))
	end	
end

function Tedavi(DoktorP)
    Citizen.Wait(500)
	TriggerEvent('esx_ambulancejob:revive')
	exports['mythic_notify']:DoHudText('success', _U('treatment_done')..Config.Price..Config.MoneyFormat)
	RemovePedElegantly(DoktorP)
	bekleme = true
end

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(0)
    end
end