ESX = nil 
 
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) 

ESX.RegisterServerCallback('ar_teleportevent:callbackgetbackposition', function (source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local identifier = GetPlayerIdentifier(source)

	MySQL.Async.fetchAll("SELECT * FROM `positionevent` WHERE `identifier`=@identifier ",{
		['@identifier'] = identifier
	}, function(result)  
		if result[1] ~= nil then
            local position = json.decode(result[1].position)
			cb(position)
        else
            cb('garage')
		end
	end)
end)

RegisterServerEvent('ar_teleportevent:sv:getbackposition')
AddEventHandler('ar_teleportevent:sv:getbackposition', function(coords)
	local xPlayer = ESX.GetPlayerFromId(source)
	local identifier = GetPlayerIdentifier(source)
	local position = json.encode(coords)
    print(position)
    MySQL.Async.fetchAll("SELECT * FROM `positionevent` WHERE `identifier`=@identifier ",{
		['@identifier'] = identifier
	}, function(result)  
		if result[1] ~= nil then
            MySQL.Async.execute("UPDATE `positionevent` SET `position`=@position WHERE identifier=@identifier",{
                ['@position'] = position,
                ['@identifier'] = identifier
            })
        else
            MySQL.Async.execute('INSERT INTO positionevent (position, identifier) VALUES (@position, @identifier)', {
				['@position'] = position,
				['@identifier'] = identifier
			}, function(affectedRows)
			end)
		end
	end)
end)


