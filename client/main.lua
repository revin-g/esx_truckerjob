--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- ORIGINAL SCRIPT BY Marcio FOR CFX-ESX
-- Script serveur No Brain 
-- www.nobrain.org
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)
--------------------------------------------------------------------------------
-- DO NOT MODIFY
--------------------------------------------------------------------------------
local namezone = "Delivery"
local namezonenum = 0
local namezoneregion = 0
local MissionRegion = 0
local vehiclemaxhealth = 1000
local moneywithdrawn = 0
local deliveryTotalPaid = 0
local deliverynumber = 0
local MissionReturnTruck = false
local MissionNum = 0
local MissionDelivery = false
local isInService = false
local PlayerData              = nil
local GUI                     = {}
GUI.Time                      = 0
local hasAlreadyEnteredMarker = false
local lastZone                = nil
local Blips                   = {}

local vehicleplate = ""
local currentvehicleplate = ""
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}
--------------------------------------------------------------------------------
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

-- MENUS
function MenuCloakRoom()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'cloakroom',
		{
			title    = _U('cloakroom'),
			elements = {
				{label = _U('job_wear'), value = 'job_wear'},
				{label = _U('citizen_wear'), value = 'citizen_wear'}
			}
		},
		function(data, menu)
			if data.current.value == 'citizen_wear' then
				isInService = false
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
	    			TriggerEvent('skinchanger:loadSkin', skin)
				end)
			end
			if data.current.value == 'job_wear' then
				isInService = true
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
	    			if skin.sex == 0 then
	    				TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
					else
	    				TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
					end
				end)
			end
			menu.close()
		end,
		function(data, menu)
			menu.close()
		end
	)
end

function MenuVehicleSpawner()
	local elements = {}

	for i=1, #Config.Trucks, 1 do
		table.insert(elements, {label = GetLabelText(GetDisplayNameFromVehicleModel(Config.Trucks[i])), value = Config.Trucks[i]})
	end


	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'vehiclespawner',
		{
			title    = _U('vehiclespawner'),
			elements = elements
		},
		function(data, menu)
			ESX.Game.SpawnVehicle(data.current.value, Config.Zones.VehicleSpawnPoint.Pos, 270.0, function(vehicle)
				platenum = math.random(10000, 99999)
				SetVehicleNumberPlateText(vehicle, "WAL"..platenum)             
                MissionDeliverySelect()
				vehicleplate = "WAL"..platenum
				if data.current.value == 'phantom3' then
					ESX.Game.SpawnVehicle("trailers2", Config.Zones.VehicleSpawnPoint.Pos, 270.0, function(trailer)
					    AttachVehicleToTrailer(vehicle, trailer, 1.1)
					end)
				end				
				TaskWarpPedIntoVehicle(GetPlayerPed(-1), vehicle, -1)   
			end)

			menu.close()
		end,
		function(data, menu)
			menu.close()
		end
	)
end

function IsATruck()
	local isATruck = false
	local playerPed = GetPlayerPed(-1)
	for i=1, #Config.Trucks, 1 do
		if IsVehicleModel(GetVehiclePedIsUsing(playerPed), Config.Trucks[i]) then
			isATruck = true
			break
		end
	end
	return isATruck
end

function IsJobTrucker()
	if PlayerData ~= nil then
		local isJobTrucker = false
		if PlayerData.job.name ~= nil and PlayerData.job.name == 'trucker' then
			isJobTrucker = true
		end
		return isJobTrucker
	end
end

AddEventHandler('esx_truckerjob:hasEnteredMarker', function(zone)

	local playerPed = GetPlayerPed(-1)

	if zone == 'CloakRoom' then
		MenuCloakRoom()
	end

	if zone == 'VehicleSpawner' then
		if isInService and IsJobTrucker() then
			if MissionReturnTruck or MissionDelivery then
				CurrentAction = 'hint'
                CurrentActionMsg  = _U('already_have_truck')
			else
				MenuVehicleSpawner()
			end
		end
	end

	if zone == namezone then
		if isInService and MissionDelivery and MissionNum == namezonenum and MissionRegion == namezoneregion and IsJobTrucker() then
			if IsPedSittingInAnyVehicle(playerPed) and IsATruck() then
				VerifyCurrentVehiclePlate()
				
				if vehicleplate == currentvehicleplate then
					if Blips['delivery'] ~= nil then
						RemoveBlip(Blips['delivery'])
						Blips['delivery'] = nil
					end

					CurrentAction     = 'delivery'
                    CurrentActionMsg  = _U('delivery')
				else
					CurrentAction = 'hint'
                    CurrentActionMsg  = _U('not_your_truck')
				end
			else
				CurrentAction = 'hint'
                CurrentActionMsg  = _U('not_your_truck2')
			end
		end
	end

	if zone == 'CancelMission' then
		if isInService and MissionDelivery and IsJobTrucker() then
			if IsPedSittingInAnyVehicle(playerPed) and IsATruck() then
				VerifyCurrentVehiclePlate()

                TriggerServerEvent('esx:clientLog', "3'" .. json.encode(vehicleplate) .. "' '" .. json.encode(currentvehicleplate) .. "'")
				
				if vehicleplate == currentvehicleplate then
                    CurrentAction     = 'returntruckcancelmission'
                    CurrentActionMsg  = _U('cancel_mission')
				else
					CurrentAction = 'hint'
                    CurrentActionMsg  = _U('not_your_truck')
				end
			else
                CurrentAction     = 'returnlosttruckcancelmission'
			end
		end
	end

	if zone == 'ReturnTruck' then
		if isInService and MissionReturnTruck and IsJobTrucker() then
			if IsPedSittingInAnyVehicle(playerPed) and IsATruck() then
				VerifyCurrentVehiclePlate()

				if vehicleplate == currentvehicleplate then
                    CurrentAction     = 'returntruck'
				else
                    CurrentAction     = 'returntruckcancelmission'
                    CurrentActionMsg  = _U('not_your_truck')
				end
			else
                CurrentAction     = 'returnlosttruck'
			end
		end
	end

end)

AddEventHandler('esx_truckerjob:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()    
    CurrentAction = nil
    CurrentActionMsg = ''
end)

function nouvelledestination()
	deliverynumber = deliverynumber+1
	deliveryTotalPaid = deliveryTotalPaid+destination.Paye

	if deliverynumber >= Config.MaxDelivery then
		MissionDeliveryStopRetourDepot()
	else

		livraisonsuite = math.random(0, 100)
		
		if livraisonsuite <= 10 then
			MissionDeliveryStopRetourDepot()
		elseif livraisonsuite <= 99 then
			MissionDeliverySelect()
		elseif livraisonsuite <= 100 then
			if MissionRegion == 1 then
				MissionRegion = 2
			elseif MissionRegion == 2 then
				MissionRegion = 1
			end
			MissionDeliverySelect()	
		end
	end
end

function returntruck_true()
	if Blips['delivery'] ~= nil then
		RemoveBlip(Blips['delivery'])
		Blips['delivery'] = nil
	end
	
	if Blips['cancelmission'] ~= nil then
		RemoveBlip(Blips['cancelmission'])
		Blips['cancelmission'] = nil
	end
	
	MissionReturnTruck = false
	deliverynumber = 0
	MissionRegion = 0
	
	givepayroll()
end

function returntruck_false()
	
	if deliverynumber >= Config.MaxDelivery then
		ESX.ShowNotification(_U('need_it'))
	else
		ESX.ShowNotification(_U('ok_work'))
		nouvelledestination()
	end
end

function returnlosttruck_true()
	if Blips['delivery'] ~= nil then
		RemoveBlip(Blips['delivery'])
		Blips['delivery'] = nil
	end
	
	if Blips['cancelmission'] ~= nil then
		RemoveBlip(Blips['cancelmission'])
		Blips['cancelmission'] = nil
	end
	MissionReturnTruck = false
	deliverynumber = 0
	MissionRegion = 0
	
	givemoveyinthetruck()
end

function returnlosttruck_false()
	ESX.ShowNotification(_U('scared_me'))
end

function returntruckcancelmission_true()
	if Blips['delivery'] ~= nil then
		RemoveBlip(Blips['delivery'])
		Blips['delivery'] = nil
	end
	
	if Blips['cancelmission'] ~= nil then
		RemoveBlip(Blips['cancelmission'])
		Blips['cancelmission'] = nil
	end
	
	MissionDelivery = false
	deliverynumber = 0
	MissionRegion = 0
	
	givepayroll()
end

function returntruckcancelmission_false()	
	ESX.ShowNotification(_U('resume_delivery'))
end

function returnlosttruckcancelmission_true()
	if Blips['delivery'] ~= nil then
		RemoveBlip(Blips['delivery'])
		Blips['delivery'] = nil
	end
	
	if Blips['cancelmission'] ~= nil then
		RemoveBlip(Blips['cancelmission'])
		Blips['cancelmission'] = nil
	end
	
	MissionDelivery = false
	deliverynumber = 0
	MissionRegion = 0
	
	givemoveyinthetruck()
end

function returnlosttruckcancelmission_false()	
	ESX.ShowNotification(_U('resume_delivery'))
end

function round(num, numDecimalPlaces)
    local mult = 5^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

function givepayroll()
	ped = GetPlayerPed(-1)
	vehicle = GetVehiclePedIsIn(ped, false)
	vehiclehealth = GetVehicleEngineHealth(vehicle)
	moneywithdrawncalculation = round(vehiclemaxhealth-vehiclehealth)
	
	if moneywithdrawncalculation <= 0 then
		moneywithdrawn = 0
	else
		moneywithdrawn = moneywithdrawncalculation
	end

    ESX.Game.DeleteVehicle(vehicle)

	local amount = deliveryTotalPaid-moneywithdrawn
	
	if vehiclehealth >= 1 then
		if deliveryTotalPaid == 0 then
			ESX.ShowNotification(_U('not_delivery'))
			ESX.ShowNotification(_U('pay_repair'))
			ESX.ShowNotification(_U('repair_minus')..moneywithdrawn)
			TriggerServerEvent("esx_truckerjob:pay", amount)
			deliveryTotalPaid = 0
		else
			if moneywithdrawn <= 0 then
				ESX.ShowNotification(_U('shipments_plus')..deliveryTotalPaid)
				TriggerServerEvent("esx_truckerjob:pay", amount)
				deliveryTotalPaid = 0
			else
				ESX.ShowNotification(_U('shipments_plus')..deliveryTotalPaid)
				ESX.ShowNotification(_U('repair_minus')..moneywithdrawn)
					TriggerServerEvent("esx_truckerjob:pay", amount)
				deliveryTotalPaid = 0
			end
		end
	else
		if deliveryTotalPaid ~= 0 and amount <= 0 then
			ESX.ShowNotification(_U('truck_state'))
			deliveryTotalPaid = 0
		else
			if moneywithdrawn <= 0 then
				ESX.ShowNotification(_U('shipments_plus')..deliveryTotalPaid)
					TriggerServerEvent("esx_truckerjob:pay", amount)
				deliveryTotalPaid = 0
			else
				ESX.ShowNotification(_U('shipments_plus')..deliveryTotalPaid)
				ESX.ShowNotification(_U('repair_minus')..moneywithdrawn)
				TriggerServerEvent("esx_truckerjob:pay", amount)
				deliveryTotalPaid = 0
			end
		end
	end
end

function givemoveyinthetruck()
	ped = GetPlayerPed(-1)
	moneywithdrawn = Config.TruckPrice
	
	-- give pay
	local amount = deliveryTotalPaid-moneywithdrawn
	
	if deliveryTotalPaid == 0 then
		ESX.ShowNotification(_U('no_delivery_no_truck'))
		ESX.ShowNotification(_U('truck_price')..moneywithdrawn)
					TriggerServerEvent("esx_truckerjob:pay", amount)
		deliveryTotalPaid = 0
	else
		if amount >= 1 then
			ESX.ShowNotification(_U('shipments_plus')..deliveryTotalPaid)
			ESX.ShowNotification(_U('truck_price')..moneywithdrawn)
					TriggerServerEvent("esx_truckerjob:pay", amount)
			deliveryTotalPaid = 0
		else
			ESX.ShowNotification(_U('truck_state'))
			deliveryTotalPaid = 0
		end
	end
end

-- Key Controls
Citizen.CreateThread(function()
    while true do

        Citizen.Wait(0)

        if CurrentAction ~= nil then

        	SetTextComponentFormat('STRING')
        	AddTextComponentString(CurrentActionMsg)
       		DisplayHelpTextFromStringLabel(0, 0, 1, -1)

            if IsControlJustReleased(0, 38) and IsJobTrucker() then

                if CurrentAction == 'delivery' then
                    nouvelledestination()
                end

                if CurrentAction == 'returntruck' then
                    returntruck_true()
                end

                if CurrentAction == 'returnlosttruck' then
                    returnlosttruck_true()
                end

                if CurrentAction == 'returntruckcancelmission' then
                    returntruckcancelmission_true()
                end

                if CurrentAction == 'returnlosttruckcancelmission' then
                    returnlosttruckcancelmission_true()
                end

                CurrentAction = nil
            end

        end

    end
end)

-- DISPLAY MISSION MARKERS AND MARKERS
Citizen.CreateThread(function()
	while true do
		Wait(0)
		
		if MissionDelivery then
			DrawMarker(destination.Type, destination.Pos.x, destination.Pos.y, destination.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, destination.Size.x, destination.Size.y, destination.Size.z, destination.Color.r, destination.Color.g, destination.Color.b, 100, false, true, 2, false, false, false, false)
			DrawMarker(Config.Delivery.CancelMission.Type, Config.Delivery.CancelMission.Pos.x, Config.Delivery.CancelMission.Pos.y, Config.Delivery.CancelMission.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.Delivery.CancelMission.Size.x, Config.Delivery.CancelMission.Size.y, Config.Delivery.CancelMission.Size.z, Config.Delivery.CancelMission.Color.r, Config.Delivery.CancelMission.Color.g, Config.Delivery.CancelMission.Color.b, 100, false, true, 2, false, false, false, false)
		elseif MissionReturnTruck then
			DrawMarker(destination.Type, destination.Pos.x, destination.Pos.y, destination.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, destination.Size.x, destination.Size.y, destination.Size.z, destination.Color.r, destination.Color.g, destination.Color.b, 100, false, true, 2, false, false, false, false)
		end

		local coords = GetEntityCoords(GetPlayerPed(-1))
		
		for k,v in pairs(Config.Zones) do

			if isInService and (IsJobTrucker() and v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
				DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
			end

		end

		for k,v in pairs(Config.Cloakroom) do

			if(IsJobTrucker() and v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
				DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
			end

		end
		
	end
end)

-- Activate menu when player is inside marker
Citizen.CreateThread(function()
	while true do
		
		Wait(0)
		
		if IsJobTrucker() then

			local coords      = GetEntityCoords(GetPlayerPed(-1))
			local isInMarker  = false
			local currentZone = nil

			for k,v in pairs(Config.Zones) do
				if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
					isInMarker  = true
					currentZone = k
				end
			end
			
			for k,v in pairs(Config.Cloakroom) do
				if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
					isInMarker  = true
					currentZone = k
				end
			end
			
			for k,v in pairs(Config.Delivery) do
				if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
					isInMarker  = true
					currentZone = k
				end
			end

			if isInMarker and not hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = true
				lastZone                = currentZone
				TriggerEvent('esx_truckerjob:hasEnteredMarker', currentZone)
			end

			if not isInMarker and hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = false
				TriggerEvent('esx_truckerjob:hasExitedMarker', lastZone)
			end

		end

	end
end)

-- CREATE BLIPS
Citizen.CreateThread(function()
	local blip = AddBlipForCoord(Config.Cloakroom.CloakRoom.Pos.x, Config.Cloakroom.CloakRoom.Pos.y, Config.Cloakroom.CloakRoom.Pos.z)
  
	SetBlipSprite (blip, 67)
	SetBlipDisplay(blip, 4)
	SetBlipScale  (blip, 1.2)
	SetBlipColour (blip, 5)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(_U('blip_job'))
	EndTextCommandSetBlipName(blip)
end)

-------------------------------------------------
-- Fonctions
-------------------------------------------------
-- Fonction selection nouvelle mission livraison
function MissionDeliverySelect()
    TriggerServerEvent('esx:clientLog', "MissionDeliverySelect num")
    TriggerServerEvent('esx:clientLog', MissionRegion)
	if MissionRegion == 0 then

            TriggerServerEvent('esx:clientLog', "MissionDeliverySelect 1")
		MissionRegion = math.random(1,2)
	end
	
	if MissionRegion == 1 then -- Los santos
            TriggerServerEvent('esx:clientLog', "MissionDeliverySelect 2")
		MissionNum = math.random(1, 10)
	
		if MissionNum == 1 then destination = Config.Delivery.Delivery1LS namezone = "Delivery1LS" namezonenum = 1 namezoneregion = 1
		elseif MissionNum == 2 then destination = Config.Delivery.Delivery2LS namezone = "Delivery2LS" namezonenum = 2 namezoneregion = 1
		elseif MissionNum == 3 then destination = Config.Delivery.Delivery3LS namezone = "Delivery3LS" namezonenum = 3 namezoneregion = 1
		elseif MissionNum == 4 then destination = Config.Delivery.Delivery4LS namezone = "Delivery4LS" namezonenum = 4 namezoneregion = 1
		elseif MissionNum == 5 then destination = Config.Delivery.Delivery5LS namezone = "Delivery5LS" namezonenum = 5 namezoneregion = 1
		elseif MissionNum == 6 then destination = Config.Delivery.Delivery6LS namezone = "Delivery6LS" namezonenum = 6 namezoneregion = 1
		elseif MissionNum == 7 then destination = Config.Delivery.Delivery7LS namezone = "Delivery7LS" namezonenum = 7 namezoneregion = 1
		elseif MissionNum == 8 then destination = Config.Delivery.Delivery8LS namezone = "Delivery8LS" namezonenum = 8 namezoneregion = 1
		elseif MissionNum == 9 then destination = Config.Delivery.Delivery9LS namezone = "Delivery9LS" namezonenum = 9 namezoneregion = 1
		elseif MissionNum == 10 then destination = Config.Delivery.Delivery10LS namezone = "Delivery10LS" namezonenum = 10 namezoneregion = 1
		end
		
	elseif MissionRegion == 2 then -- Blaine County

            TriggerServerEvent('esx:clientLog', "MissionDeliverySelect 3")
		MissionNum = math.random(1, 10)
	
		if MissionNum == 1 then destination = Config.Delivery.Delivery1BC namezone = "Delivery1BC" namezonenum = 1 namezoneregion = 2
		elseif MissionNum == 2 then destination = Config.Delivery.Delivery2BC namezone = "Delivery2BC" namezonenum = 2 namezoneregion = 2
		elseif MissionNum == 3 then destination = Config.Delivery.Delivery3BC namezone = "Delivery3BC" namezonenum = 3 namezoneregion = 2
		elseif MissionNum == 4 then destination = Config.Delivery.Delivery4BC namezone = "Delivery4BC" namezonenum = 4 namezoneregion = 2
		elseif MissionNum == 5 then destination = Config.Delivery.Delivery5BC namezone = "Delivery5BC" namezonenum = 5 namezoneregion = 2
		elseif MissionNum == 6 then destination = Config.Delivery.Delivery6BC namezone = "Delivery6BC" namezonenum = 6 namezoneregion = 2
		elseif MissionNum == 7 then destination = Config.Delivery.Delivery7BC namezone = "Delivery7BC" namezonenum = 7 namezoneregion = 2
		elseif MissionNum == 8 then destination = Config.Delivery.Delivery8BC namezone = "Delivery8BC" namezonenum = 8 namezoneregion = 2
		elseif MissionNum == 9 then destination = Config.Delivery.Delivery9BC namezone = "Delivery9BC" namezonenum = 9 namezoneregion = 2
		elseif MissionNum == 10 then destination = Config.Delivery.Delivery10BC namezone = "Delivery10BC" namezonenum = 10 namezoneregion = 2
		end
		
	end
	
	MissionDeliveryLetsGo()
end

-- Fonction active mission livraison
function MissionDeliveryLetsGo()
	if Blips['delivery'] ~= nil then
		RemoveBlip(Blips['delivery'])
		Blips['delivery'] = nil
	end
	
	if Blips['cancelmission'] ~= nil then
		RemoveBlip(Blips['cancelmission'])
		Blips['cancelmission'] = nil
	end
	
	Blips['delivery'] = AddBlipForCoord(destination.Pos.x,  destination.Pos.y,  destination.Pos.z)
	SetBlipRoute(Blips['delivery'], true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(_U('blip_delivery'))
	EndTextCommandSetBlipName(Blips['delivery'])
	
	Blips['cancelmission'] = AddBlipForCoord(Config.Delivery.CancelMission.Pos.x,  Config.Delivery.CancelMission.Pos.y,  Config.Delivery.CancelMission.Pos.z)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(_U('blip_goal'))
	EndTextCommandSetBlipName(Blips['cancelmission'])

	if MissionRegion == 1 then -- Los santos
		ESX.ShowNotification(_U('meet_ls'))
	elseif MissionRegion == 2 then -- Blaine County
		ESX.ShowNotification(_U('meet_bc'))
	elseif MissionRegion == 0 then
		ESX.ShowNotification(_U('meet_del'))
	end

	MissionDelivery = true
end

-- Deposit return function
function MissionDeliveryStopRetourDepot()
	destination = Config.Delivery.ReturnTruck
	
	Blips['delivery'] = AddBlipForCoord(destination.Pos.x,  destination.Pos.y,  destination.Pos.z)
	SetBlipRoute(Blips['delivery'], true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(_U('blip_depot'))
	EndTextCommandSetBlipName(Blips['delivery'])
	
	if Blips['cancelmission'] ~= nil then
		RemoveBlip(Blips['cancelmission'])
		Blips['cancelmission'] = nil
	end

	ESX.ShowNotification(_U('return_depot'))
	
	MissionRegion = 0
	MissionDelivery = false
	MissionNum = 0
	MissionReturnTruck = true
end

function SaveVehiclePlate()
	vehicleplate = GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), false))
end

function VerifyCurrentVehiclePlate()
	currentvehicleplate = GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), false))
end