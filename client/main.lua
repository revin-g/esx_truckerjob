--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- ORIGINAL SCRIPT BY Marcio FOR CFX-ESX
-- MODIFY by RevIn-G (Revolutionary Infinite Gaming) [DANDYYeah, GRINYeah]
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local Keys = {
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

local namezone = "Delivery"
local namezonenum = 0
local namezoneregion = 0
local MissionRegion = 0
local vehiclemaxhealth = 1000
local moneywithdrawn = 0
local deliveryTotalPaid = 0
local deliverynumber = 0
local delivery_vehicle = nil
local delivery_trailer = nil
local delivery_depot = nil
local MissionReturnTruck = false
local MissionNum = 0
local MissionFindVehicle = false
local MissionDelivery = false
local IsBusy = false
local IsReturnTruckState = false
local PlayerData = {}
local GUI = {}
local hasAlreadyEnteredMarker = false
local lastZone = nil
local Blips = {}
local vehicleplate = ""
local currentvehicleplate = ""
local CurrentAction = nil
local CurrentActionMsg = ''
local CurrentActionData = {}

GUI.Time = 0
ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	Citizen.Wait(5000)
	PlayerData = ESX.GetPlayerData()
end)
--------------------------------------------------------------------------------

-------------------------------------------------
-- Event Handler
-------------------------------------------------
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

AddEventHandler('esx_truckerjob:hasEnteredMarker', function(zone)
	ESX.UI.Menu.CloseAll()

	local playerPed = GetPlayerPed(-1)

	if zone == 'CloakRoom' then
		MenuCloakRoom()
	end

	if IsJobTrucker() then
		if zone == 'Destination' and MissionDelivery then
			if IsPedSittingInAnyVehicle(playerPed) and IsDeliveryVehicle() then
				VerifyCurrentVehiclePlate()
				
				if vehicleplate == currentvehicleplate then
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

		-- deprecated
		if zone == namezone then
			if MissionDelivery and MissionNum == namezonenum and MissionRegion == namezoneregion then
				if IsPedSittingInAnyVehicle(playerPed) and IsDeliveryVehicle() then
					VerifyCurrentVehiclePlate()
					
					if vehicleplate == currentvehicleplate then
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

		if zone == 'ReturnTruck' and MissionReturnTruck then
			if IsPedSittingInAnyVehicle(playerPed) and IsDeliveryVehicle() then
				VerifyCurrentVehiclePlate()

				if vehicleplate == currentvehicleplate then
					CurrentAction     = 'returntruck'
					CurrentActionMsg  = _U('return')
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
--------------------------------------------------------------------------------

-------------------------------------------------
-- Thread / Coroutine
-------------------------------------------------
-- Key Controls
Citizen.CreateThread(function()
    while true do

        Citizen.Wait(0)

        if CurrentAction ~= nil then

        	SetTextComponentFormat('STRING')
        	AddTextComponentString(CurrentActionMsg)
       		DisplayHelpTextFromStringLabel(0, 0, 1, -1)

            if IsControlJustReleased(0, Keys['E']) and IsJobTrucker() then

				if CurrentAction == 'delivery' then
					if delivery_trailer then
						finish_trailer_delivery()
					else
						newdestination()
					end
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

        if IsControlJustReleased(0, Keys['F6']) and not IsDead and PlayerData.job ~= nil and PlayerData.job.name == 'trucker' then
            OpenMobileTruckerActionsMenu()
        end
    end
end)

-- CREATE BLIPS
Citizen.CreateThread(function()
	for company, values in pairs(Config.Companies) do
		if values.CloakRoom then
			local blip = AddBlipForCoord(values.CloakRoom.x, values.CloakRoom.y, values.CloakRoom.z)
		  
			SetBlipSprite(blip, 477)
			SetBlipDisplay(blip, 4)
			SetBlipScale(blip, 1.0)
			SetBlipColour(blip, 5)
			SetBlipAsShortRange(blip, true)
		
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(_U('blip_job'))
			EndTextCommandSetBlipName(blip)
		end
	end
end)

-- DISPLAY MARKERS
Citizen.CreateThread(function()
	while true do
		Wait(0)
		
		if IsJobTrucker() then
			for company, values in pairs(Config.Companies) do
				if values.CloakRoom and IsPlayerInArea({ coords = values.CloakRoom, size = Config.DrawDistance }) then
					SimpleDrawMarker({
						coords = values.CloakRoom,
						size = {
							x = 1.0,
							y = 1.0,
							z = 1.0
						}
					})
				end
			end

			if MissionDelivery or MissionReturnTruck then
				SimpleDrawMarker({ coords = destination.Pos })
			end

			if MissionFindVehicle or MissionDelivery or MissionReturnTruck then
				if IsPedSittingInAnyVehicle(GetPlayerPed(-1)) and IsDeliveryVehicle() then
					VerifyCurrentVehiclePlate()

					if MissionFindVehicle and vehicleplate == currentvehicleplate then
						MissionFindVehicle = false

						if IsReturnTruckState then
							MissionDeliveryStopReturnDepot()
						else
							MissionDeliveryLetsGo()
						end
					end
				else
					if MissionDelivery or MissionReturnTruck then
						MissionDelivery = false
						MissionReturnTruck = false
						MissionDeliveryFindVehicle()
					end
				end
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

			if MissionDelivery and destination then
				if(GetDistanceBetweenCoords(coords, destination.Pos.x, destination.Pos.y, destination.Pos.z * 1.0, true) < 5) then
					isInMarker  = true
					currentZone = 'Destination'
				end
			end

			for company, values in pairs(Config.Companies) do
				if values.CloakRoom and IsPlayerInArea({ coords = values.CloakRoom }) then
					isInMarker  = true
					currentZone = 'CloakRoom'
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
--------------------------------------------------------------------------------

-------------------------------------------------
-- Menus
-------------------------------------------------
function MenuCloakRoom()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'cloakroom',
		{
			title    = _U('cloakroom'),
			align    = 'top-left',
			elements = {
				{label = _U('job_wear'), value = 'job_wear'},
				{label = _U('citizen_wear'), value = 'citizen_wear'}
			}
		},
		function(data, menu)
			if data.current.value == 'citizen_wear' then
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
	    			TriggerEvent('skinchanger:loadSkin', skin)
				end)
			end
			if data.current.value == 'job_wear' then
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

function MenuVanMissionSpawner(selected_company_name)
	local elements = {}

	for i=1, #Config.Vans, 1 do
		table.insert(elements, {label = GetLabelText(GetDisplayNameFromVehicleModel(Config.Vans[i])), value = Config.Vans[i]})
	end

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'vehiclespawner',
		{
			title    = _U('vehiclespawner'),
			align    = 'top-left',
			elements = elements
		},
		function(data, menu)
			local spawn_point = GetSafeSpawnPoint(Config.Companies[selected_company_name].Markers, 'S')

			if spawn_point then
				ESX.Game.SpawnVehicle(data.current.value, spawn_point.coord, spawn_point.heading, function(vehicle)
					platenum = math.random(10000, 99999)
					SetVehicleNumberPlateText(vehicle, "ETJ"..platenum)             
					vehicleplate = "ETJ"..platenum
					delivery_vehicle = vehicle 
					delivery_depot = Config.Companies[selected_company_name]

					MissionDeliverySelect()
				end)
			end

			ESX.UI.Menu.CloseAll()
		end,
		function(data, menu)
			menu.close()
		end
	)
end

function MenuTruckMissionSpawner(selected_company_name)
	local elements = {}

	for i=1, #Config.Trucks, 1 do
		table.insert(elements, {label = GetLabelText(GetDisplayNameFromVehicleModel(Config.Trucks[i])), value = Config.Trucks[i]})
	end

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'vehiclespawner',
		{
			title    = _U('vehiclespawner'),
			align    = 'top-left',
			elements = elements
		},
		function(data, menu)
			local spawn_point = GetSafeSpawnPoint(Config.Companies[selected_company_name].Markers)

			if spawn_point then
				ESX.Game.SpawnVehicle(data.current.value, spawn_point.coord, spawn_point.heading, function(vehicle)
					platenum = math.random(10000, 99999)
					SetVehicleNumberPlateText(vehicle, "ETJ"..platenum)             
					vehicleplate = "ETJ"..platenum
					delivery_vehicle = vehicle
					delivery_depot = Config.Companies[selected_company_name]

					MissionDeliverySelect()
				end)
			end

			ESX.UI.Menu.CloseAll()
		end,
		function(data, menu)
			menu.close()
		end
	)
end

function MenuTractorTruckMissionSpawner(selected_company_name)
	local elements = {}
	
	TriggerServerEvent("esx_truckerjob:set_random_seed", GetClockHours())
	ESX.TriggerServerCallback('esx_truckerjob:get_company_list', function(company_list)
		for i = 1, #company_list, 1 do
			local delivery_company_name = company_list[i]
			
			if delivery_company_name ~= selected_company_name then
				local selected_company = Config.Companies[selected_company_name]
				local delivery_company = Config.Companies[delivery_company_name]
				local delivery_truck = Config.TractorTrucks[math.random(1, #Config.TractorTrucks)]
				local available_trailer_types = ''

				for type in string.gmatch(delivery_company.Type, "[" .. selected_company.Type .. "]") do
					available_trailer_types = available_trailer_types .. type
				end
		
				if available_trailer_types ~= '' then
					trailer_type_index = math.random(1, #available_trailer_types)
					trailer_type = string.sub(available_trailer_types, trailer_type_index, trailer_type_index)

					if delivery_truck == 'barracks2' and trailer_type ~= 'M' then
						-- TODO: improve this condition
						delivery_truck = 'packer'
					end

					local travel_distance = CalculateTravelDistanceBetweenPoints(
						selected_company.Markers[1].Coords.x,
						selected_company.Markers[1].Coords.y,
						selected_company.Markers[1].Coords.z,
						delivery_company.Markers[1].Coords.x,
						delivery_company.Markers[1].Coords.y,
						delivery_company.Markers[1].Coords.z
					)

					table.insert(elements, {
						label = '[' .. trailer_type .. '] ' ..
							GetLabelText(GetDisplayNameFromVehicleModel(delivery_truck)) ..
							' to ' .. delivery_company_name ..
							' (' .. math.ceil(travel_distance/100)/10 .. ')',
						value = {
							company = {
								origin = selected_company,
								destination = delivery_company
							},
							truck = delivery_truck,
							trailer_type = trailer_type
						}
					})
				end
			end
		end

		ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'dummy',
			{
				title    = _U('vehiclespawner'),
				align    = 'top-left',
				elements = {{label = 'Loading ' .. #company_list .. ' companies . . .', value = nil}}
			},
			function(data, menu)
				menu.close()
			end,
			function(data, menu)
				menu.close()
			end
		)
	end)

	Citizen.Wait(500)
	ESX.UI.Menu.Close('default', GetCurrentResourceName(), 'dummy')

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'vehiclespawner',
		{
			title    = _U('vehiclespawner'),
			align    = 'top-left',
			elements = elements
		},
		function(data, menu)
			local origin = data.current.value.company.origin
			local truck = data.current.value.truck
			local trailer_type = data.current.value.trailer_type
			
			destination = data.current.value.company.destination
			destination['Pos'] = destination.Markers[math.random(1, #destination.Markers)].Coords

			local spawn_point = GetSafeSpawnPoint(origin.Markers)
			if spawn_point then
				ESX.Game.SpawnVehicle(truck, spawn_point.coord, spawn_point.heading, function(vehicle)
					platenum = math.random(10000, 99999)
					SetVehicleNumberPlateText(vehicle, "ETJ"..platenum)             
					vehicleplate = "ETJ"..platenum
					delivery_vehicle = vehicle

					ESX.Game.SpawnVehicle(GetTrailerByType(trailer_type), spawn_point.coord, spawn_point.heading, function(trailer)
						delivery_trailer = trailer
						AttachVehicleToTrailer(delivery_vehicle, trailer, 1.1)
					end)

					MissionDeliveryFindVehicle()
				end)
			end

			ESX.UI.Menu.CloseAll()
		end,
		function(data, menu)
			menu.close()
		end
	)
end

function MenuJobType(selected_company_name)
	local elements = {}
	table.insert(elements, {label = 'Trailers', value = 'missiontrailers'})
	table.insert(elements, {label = 'Trucks', value = 'missiontrucks'})
	table.insert(elements, {label = 'Vans', value = 'missionvans'})

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'job_type_actions', {
		title    = 'Select Job Type',
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		if IsBusy then return end

		if data.current.value == 'missionvans' then
			MenuVanMissionSpawner(selected_company_name)
		elseif data.current.value == 'missiontrucks' then
			MenuTruckMissionSpawner(selected_company_name)
		elseif data.current.value == 'missiontrailers' then
			MenuTractorTruckMissionSpawner(selected_company_name)
		end
	end, function(data, menu)
		menu.close()
	end)
end

function MenuCompanySelect()
	local is_empty = true
	local elements = {}
	local sorted_companies = {}

	for company_name, company_values in pairs(Config.Companies) do
		local coords = company_values.Markers[1].Coords

		if IsPlayerInArea({ coords = coords, size = Config.CompanyRange }) then
			is_empty = false
			sorted_companies[SimpleGetDistanceFromPlayer(coords)] = company_name
		end
	end

	if is_empty then
		table.insert(elements, {
			label = '- No nearest company -',
			value = nil
		})
	else
		for company_distance, company_name in spairs(sorted_companies) do
			table.insert(elements, {
				label = company_name .. ' (' .. math.ceil(company_distance) .. ')',
				value = company_name
			})
		end
	end

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'company_selector',
		{
			title    = 'Select Company',
			align    = 'top-left',
			elements = elements
		},
		function(data, menu)
			if data.current.value ~= nil then
				MenuJobType(data.current.value)
			else
				ESX.UI.Menu.CloseAll()
			end
		end,
		function(data, menu)
			menu.close()
		end
	)
end

function OpenMobileTruckerActionsMenu()
	local elements = {}
	if not MissionReturnTruck then
		if MissionDelivery or MissionFindVehicle then
			table.insert(elements, {label = _U('mobile_action_cancel_job'), value = 'cancelmission'})
		else
			table.insert(elements, {label = _U('mobile_action_select_job'), value = 'selectjob'})
		end
	end

	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mobile_trucker_actions', {
		title    = _U('mobile_action_title'),
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		if IsBusy then return end

		if data.current.value == 'selectjob' then
			MenuCompanySelect()
		elseif data.current.value == 'cancelmission' then
			returntruckcancelmission_true()
			menu.close()
		end
	end, function(data, menu)
		menu.close()
	end)
end
--------------------------------------------------------------------------------

-------------------------------------------------
-- Functions
-------------------------------------------------
function IsDeliveryVehicle()
	for i=1, #Config.Vans, 1 do
		if IsVehicleModel(GetVehiclePedIsUsing(GetPlayerPed(-1)), Config.Vans[i]) then
			return true
		end
	end

	for i=1, #Config.Trucks, 1 do
		if IsVehicleModel(GetVehiclePedIsUsing(GetPlayerPed(-1)), Config.Trucks[i]) then
			return true
		end
	end

	for i=1, #Config.TractorTrucks, 1 do
		if IsVehicleModel(GetVehiclePedIsUsing(GetPlayerPed(-1)), Config.TractorTrucks[i]) then
			return true
		end
	end

	return false
end

function IsJobTrucker()
	return (PlayerData.job ~= nil and PlayerData.job.name == 'trucker')
end

function IsPlayerInArea(params)
	local coords = params.coords -- mandatory
	local size = params.size or 2

	return GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), coords.x, coords.y, coords.z, true) < size
end

-- Selection new mission delivery
function MissionDeliverySelect()
    TriggerServerEvent('esx:clientLog', "MissionDeliverySelect num")
    TriggerServerEvent('esx:clientLog', MissionRegion)
	if MissionRegion == 0 then

            TriggerServerEvent('esx:clientLog', "MissionDeliverySelect 1")
		-- MissionRegion = math.random(1,2)
		MissionRegion = 1
	end
	
	if MissionRegion == 1 then -- Los santos
            TriggerServerEvent('esx:clientLog', "MissionDeliverySelect 2")
		MissionNum = math.random(1, 10)
	
		-- MissionNum = 1
		-- destination = Config.Delivery.DeliveryTestLS
		-- namezone = "DeliveryTestLS"
		-- namezonenum = 1
		-- namezoneregion = 1
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
	
	MissionDeliveryFindVehicle()
end

function MissionDeliveryFindVehicle()
	if Blips['vehicle'] ~= nil then
		RemoveBlip(Blips['vehicle'])
		Blips['vehicle'] = nil
	end

	if Blips['delivery'] ~= nil then
		RemoveBlip(Blips['delivery'])
		Blips['delivery'] = nil
	end
	
	Blips['vehicle'] = AddBlipForEntity(delivery_vehicle)
	SetBlipRoute(Blips['vehicle'], true)
	SetBlipRouteColour(Blips['vehicle'], 2) 
	SetBlipColour(Blips['vehicle'], 2)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('Delivery Vehicle')
	EndTextCommandSetBlipName(Blips['vehicle'])

	ESX.ShowNotification('Go to the delivery ~g~vehicle')
	MissionFindVehicle = true
end

-- Active mission delivery
function MissionDeliveryLetsGo()
	if Blips['vehicle'] ~= nil then
		RemoveBlip(Blips['vehicle'])
		Blips['vehicle'] = nil
	end

	if Blips['delivery'] ~= nil then
		RemoveBlip(Blips['delivery'])
		Blips['delivery'] = nil
	end
	
	Blips['delivery'] = AddBlipForCoord(destination.Pos.x,  destination.Pos.y,  destination.Pos.z * 1.0)
	SetBlipRoute(Blips['delivery'], true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(_U('blip_delivery'))
	EndTextCommandSetBlipName(Blips['delivery'])
	
	if MissionRegion == 1 then -- Los santos
		ESX.ShowNotification(_U('meet_ls'))
	elseif MissionRegion == 2 then -- Blaine County
		ESX.ShowNotification(_U('meet_bc'))
	elseif MissionRegion == 0 then -- Random 1 or 2
		ESX.ShowNotification(_U('meet_del'))
	end

	if not destination.Paye then
		destination['Paye'] = FeeCalculationByRange({ coords = destination.Pos })
		ESX.ShowNotification('Calculated Fee: ' .. destination.Paye)
	end

	MissionDelivery = true
end

-- Deposit return
function MissionDeliveryStopReturnDepot()
	if Blips['vehicle'] ~= nil then
		RemoveBlip(Blips['vehicle'])
		Blips['vehicle'] = nil
	end

	if Blips['delivery'] ~= nil then
		RemoveBlip(Blips['delivery'])
		Blips['delivery'] = nil
	end

	destination = delivery_depot
	destination['Pos'] = destination.Markers[math.random(1, #destination.Markers)].Coords
	
	Blips['delivery'] = AddBlipForCoord(destination.Pos.x,  destination.Pos.y,  destination.Pos.z)
	SetBlipRoute(Blips['delivery'], true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(_U('blip_depot'))
	EndTextCommandSetBlipName(Blips['delivery'])
	
	ESX.ShowNotification(_U('return_depot'))
	
	MissionRegion = 0
	MissionDelivery = false
	MissionNum = 0
	MissionReturnTruck = true
	IsReturnTruckState = true
end

function SaveVehiclePlate()
	vehicleplate = GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), false))
end

function VerifyCurrentVehiclePlate()
	currentvehicleplate = GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), false))
end

function newdestination()
	-- if Blips['delivery'] ~= nil then
	-- 	RemoveBlip(Blips['delivery'])
	-- 	Blips['delivery'] = nil
	-- end

	deliverynumber = deliverynumber+1
	deliveryTotalPaid = deliveryTotalPaid+destination.Paye

	if deliverynumber >= Config.MaxDelivery then
		MissionDeliveryStopReturnDepot()
	else

		deliverymore = math.random(0, 100)
		
		if deliverymore <= 10 then
			MissionDeliveryStopReturnDepot()
		elseif deliverymore <= 99 then
			MissionDeliverySelect()
		elseif deliverymore <= 100 then
			if MissionRegion == 1 then
				MissionRegion = 2
			elseif MissionRegion == 2 then
				MissionRegion = 1
			end
			MissionDeliverySelect()	
		end
	end
end

function finish_trailer_delivery()
	if Blips['delivery'] ~= nil then
		RemoveBlip(Blips['delivery'])
		Blips['delivery'] = nil
	end
	MissionDelivery = false
	
	deliveryTotalPaid = deliveryTotalPaid+destination.Paye
	givepayroll()
end

function returntruck_true()
	if Blips['delivery'] ~= nil then
		RemoveBlip(Blips['delivery'])
		Blips['delivery'] = nil
	end
	
	MissionReturnTruck = false
	IsReturnTruckState = false
	deliverynumber = 0
	MissionRegion = 0
	
	givepayroll()
end

function returntruck_false()
	
	if deliverynumber >= Config.MaxDelivery then
		ESX.ShowNotification(_U('need_it'))
	else
		ESX.ShowNotification(_U('ok_work'))
		newdestination()
	end
end

function returnlosttruck_true()
	if Blips['delivery'] ~= nil then
		RemoveBlip(Blips['delivery'])
		Blips['delivery'] = nil
	end

	MissionReturnTruck = false
	IsReturnTruckState = false
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

	if Blips['vehicle'] ~= nil then
		RemoveBlip(Blips['vehicle'])
		Blips['vehicle'] = nil
	end
	
	MissionDelivery = false
	MissionFindVehicle = false
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
	
	MissionDelivery = false
	deliverynumber = 0
	MissionRegion = 0
	
	givemoveyinthetruck()
end

function returnlosttruckcancelmission_false()	
	ESX.ShowNotification(_U('resume_delivery'))
end

function givepayroll()
	vehiclehealth = GetVehicleEngineHealth(delivery_vehicle)
	moneywithdrawncalculation = round(vehiclemaxhealth-vehiclehealth)
	
	if moneywithdrawncalculation <= 0 then
		moneywithdrawn = 0
	else
		moneywithdrawn = moneywithdrawncalculation
	end

    -- ESX.Game.DeleteVehicle(delivery_trailer)
    ESX.Game.DeleteVehicle(delivery_vehicle)
    -- DeleteEntity(delivery_trailer)
	DeleteEntity(delivery_vehicle)
	delivery_trailer = nil
	delivery_vehicle = nil
	delivery_depot = nil

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
	moneywithdrawn = Config.VehiclePrice
	
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

--- Type List: NCLTVMS
--    N - Normal
--    C - Company
--    L - Log
--    T - Tanker
--    V - Vehicle
--    M - Military
--    S - Special
function GetTrailerByType(type)
	local trailers = {}

	if type == 'N' then
		trailers = { 'TRFlat', 'Trailers', 'DockTrailer' }
	elseif type == 'C' then
		trailers = { 'Trailers2', 'Trailers3' }
	elseif type == 'L' then
		trailers = { 'TrailerLogs' }
	elseif type == 'T' then
		trailers = { 'Tanker', 'Tanker2', 'ArmyTanker' }
	elseif type == 'V' then
		trailers = { 'TR2', 'TR3', 'TR4' }
	elseif type == 'M' then
		trailers = { 'ArmyTanker', 'ArmyTrailer', 'ArmyTrailer2' }
	elseif type == 'S' then
		trailers = { 'TVTrailer' }
	end

	local result = trailers[math.random(1, #trailers)]
	ESX.ShowNotification('Trailer Type: ' .. type .. ' - ' .. result)
	return trailers[math.random(1, #trailers)]
end

function GetSafeSpawnPoint(markers, type)
	local type = type or 'L'
	local overlap_vehicle = nil
	local safe_coord = nil
	local safe_heading = nil

	for i = 1, #markers do
		local marker = markers[i]
		
		if type == 'S' or string.find(marker.Type, type) then
			overlap_vehicle = ESX.Game.GetVehiclesInArea(marker.Coords, 15)
			if #overlap_vehicle == 0 then
				safe_coord = marker.Coords
				safe_heading = marker.Heading

				break
			end
		end
	end

	if safe_coord and safe_heading then
		return {
			coord = safe_coord,
			heading = safe_heading
		}
	else
		ESX.ShowNotification('spawn area blocked by other vehicle!')

		return nil
	end
end

function SimpleGetDistanceFromPlayer(coords)
	return GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), coords.x, coords.y, coords.z, true)
end

function SimpleDrawMarker(params)
	local coords = params.coords -- mandatory
	local type = params.type or 1
	local size = params.size or { x = 5.0, y = 5.0, z = 3.0 }
	local color = params.color or { r = 204, g = 204, b = 0 }

	DrawMarker(
		type,
		coords.x * 1.0,
		coords.y * 1.0,
		coords.z * 1.0,
		0.0,
		0.0,
		0.0,
		0,
		0.0,
		0.0,
		size.x,
		size.y,
		size.z,
		color.r,
		color.g,
		color.b,
		100,
		false,
		true,
		2,
		false,
		false,
		false,
		false)
end

function FeeCalculationByRange(params)
	local coords = params.coords -- mandatory
	local base_fee = params.base_fee or 10

	-- ESX.ShowNotification(CalculateTravelDistanceBetweenPoints(GetEntityCoords(GetPlayerPed(-1)), coords.x, coords.y, coords.z))
	return math.ceil(GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), coords.x, coords.y, coords.z, true) * base_fee)
end

-------------------------------------------------
-- Operation Functions
-------------------------------------------------
function round(num, numDecimalPlaces)
    local mult = 5^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

function GetTableKeys(tab)
	local keyset = {}
	for k,v in pairs(tab) do
	  keyset[#keyset + 1] = k
	end
	return keyset
end

function spairs(t, order)
    -- collect the keys
    local keys = {}
    for k in pairs(t) do keys[#keys+1] = k end

    -- if order function given, sort by it by passing the table and keys a, b,
    -- otherwise just sort the keys 
    if order then
        table.sort(keys, function(a,b) return order(t, a, b) end)
    else
        table.sort(keys)
    end

    -- return the iterator function
    local i = 0
    return function()
        i = i + 1
        if keys[i] then
            return keys[i], t[keys[i]]
        end
    end
end
--------------------------------------------------------------------------------
