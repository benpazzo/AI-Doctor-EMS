Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX = nil
PLayerData = {}
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

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
	    if bekleme then
	        if IsControlJustReleased(0, Keys['G']) and isDead then
	            ESX.TriggerServerCallback('pazzodoktor:checkMoney', function(hasEnoughMoney)
	                if hasEnoughMoney then
	                    ESX.TriggerServerCallback('pazzodoktor:doktor', function(CopsConnected)
	                        if CopsConnected <= Config.doktor then
	                            TriggerEvent("pazzodoktor:canlan")
	                            TriggerServerEvent('pazzodoktor:odeme')
	                            bekleme = false
	                        end
		                end)
		            end
				end)
			end
		end
	end
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
		
		cagirma()
end

function cagirma()
exports['mythic_progbar']:Progress({
	name = "unique_action_name",
	duration = 20000,
	label = 'Doktor tedavi ediyor',
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
	Tedavi()
	
end

function Tedavi(player)
    Citizen.Wait(500)
	TriggerEvent('esx_ambulancejob:revive', formattedCoords)
	exports['mythic_notify']:DoHudText('success', 'Tedavin yapıldı. 2000$ ödeme alındı.')
	DeleteEntity(DoktorP)
	bekleme = true
end

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(0)
    end
end