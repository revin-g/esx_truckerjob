ESX = nil
random_seed = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_truckerjob:pay')
AddEventHandler('esx_truckerjob:pay', function(amount)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.addMoney(tonumber(amount))
end)

RegisterServerEvent('esx_truckerjob:set_random_seed')
AddEventHandler('esx_truckerjob:set_random_seed', function(seed)
	random_seed = seed
end)

ESX.RegisterServerCallback('esx_truckerjob:get_company_list', function(source, cb)
	math.randomseed(random_seed)

	local company_list = {}
	local company_index = GetTableKeys(Config.Companies)
	local company_count = math.random(1, #company_index)
	
	for i = 1, company_count, 1 do
		table.insert(company_list, company_index[math.random(1, #company_index)])
	end

	cb(company_list)
end)

function GetTableKeys(tab)
	local keyset = {}
	for k,v in pairs(tab) do
	  keyset[#keyset + 1] = k
	end
	return keyset
end
