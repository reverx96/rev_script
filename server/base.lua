ESX = exports['es_extended']:getSharedObject()



ESX.RegisterServerCallback('rev:checkadmin', function(source, cb)
    xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer ~= nil then
        grupa = xPlayer.getGroup()
        cb(grupa)
    else
        cb('user')
    end
end)


RegisterNetEvent('kostka:napis')
AddEventHandler('kostka:napis', function(text)
local _source = source
color = {r = 255, g = 0, b = 0, alpha = 0.8}
    TriggerClientEvent("sendProximityMessageKostka", -1, _source, _source, text)
    TriggerClientEvent('esx_rpchat:triggerDisplay', -1, text, _source, color)
end)



RegisterServerEvent("chat:specialMessage")
AddEventHandler("chat:specialMessage", function( temp, kto, msg)
	TriggerClientEvent('chat:addMessage',-1, { templateId = temp, args={kto,msg}})
end)


RegisterCommand('setbucket', function(source, args)
    local xPlayer = ESX.GetPlayerFromId(source)
    if (xPlayer.group == 'best' or xPlayer.group == 'superadmin' or xPlayer.group == 'admin' or xPlayer.group == 'mod' or xPlayer.group == 'support' or xPlayer.group == 'trialsupport') then
    playerID = tostring(args[1])
    playerIDk = args[1]
    SetPlayerRoutingBucket(playerID, 0)
    TriggerClientEvent('many-apartaments:ExitHouseCommand', playerIDk, source)
    end
end)

ESX.RegisterServerCallback('rev:hasItem_count', function(source, cb, item, count)
    local src = source
    local player = ESX.GetPlayerFromId(src)
    local playerItem = player.getInventoryItem(item)

    if player and playerItem ~= nil then
        if playerItem.count >= count then
            cb(true, playerItem.label)
			player.removeInventoryItem(item, 1)
        else
            cb(false, playerItem.label)
            TriggerClientEvent('esx:showNotification', source, 'Nie masz potrzebnych przedmiotów!')
        end
    else
        print('[many-info] Nie znaleziono przedmiotów w bazie danych')
    end
end)

ESX.RegisterServerCallback('rev:hasItem', function(source, cb, item)
    local src = source
    local player = ESX.GetPlayerFromId(src)
    local playerItem = player.getInventoryItem(item)

    if player and playerItem ~= nil then
        if playerItem.count >= 1 then
            cb(true, playerItem.label)
			player.removeInventoryItem(item, 1)
        else
            cb(false, playerItem.label)
            TriggerClientEvent('esx:showNotification', source, 'Nie masz potrzebnych przedmiotów!')
        end
    else
        print('[many-info] Nie znaleziono przedmiotów w bazie danych')
    end
end)

ESX.RegisterServerCallback('rev:getItemAmount', function(source, cb, item)
	--print('callback'+item)
	local xPlayer = ESX.GetPlayerFromId(source)
	local qtty = xPlayer.getInventoryItem(item).count
	cb(qtty)
end)

--Licytacja komenda

RegisterNetEvent('rev_script:licytacja')
AddEventHandler('rev_script:licytacja', function(id)
if (xPlayer.group == 'best' or xPlayer.group == 'headadmin' or xPlayer.group == 'admin' ) then
    if id[1]== nil then
        TriggerClientEvent("pNotify:SendNotification", source, {text = "Nie podałeś ID gracza"})
        return
    elseif GetPlayerPing(id[1])== 0 then
        TriggerClientEvent("pNotify:SendNotification", source, {text = "Niema nikogo o takim ID"})
        return
    elseif id[2] == nil then
        TriggerClientEvent("pNotify:SendNotification", source, {text = "Nie podałeś modelu pojazdu"})
        return
    elseif id[3] == nil then
        TriggerClientEvent("pNotify:SendNotification", source, {text = "Nie podałeś ceny pojazdu"})
        return
    elseif id[4] == nil then
        TriggerClientEvent("pNotify:SendNotification", source, {text = "[0-4] Nie podałeś tablic pojazdu"})
        return
    elseif id[5] == nil then
        TriggerClientEvent("pNotify:SendNotification", source, {text = "[4-8] Nie podałeś tablic pojazdu"})
        return
    end
TriggerClientEvent("pNotify:SendNotification", source, {text = 'Dodano pojazd dla ID: ' .. id[1] .. '<br>Model: ' .. id[2] ..'<br>Cena pojazdu: '.. id[3] ..'<br>Tablice: '.. id[4] ..' '..id[5]})
local xPlayer = ESX.GetPlayerFromId(id[1])
local osoba = id[1]
local vehicle = id[2]
local kasa = tonumber(id[3])
local tablice = id[4]..''..id[5]
xPlayer.removeAccountMoney('bank', kasa)
TriggerClientEvent('esx_rpchatt:pobieraniemodelu', osoba, vehicle, tablice, osoba)
end
end, function(source, args, user)
end)

RegisterNetEvent('esx_rpchatt:dodajpojazd')
AddEventHandler('esx_rpchatt:dodajpojazd', function(vehicle, newPlate, id, model)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(id)
    --if (xPlayer.group == 'best' or xPlayer.group == 'headadmin' or xPlayer.group == 'admin' ) then
    MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle, state, modelname) VALUES (@owner, @plate, @vehicle, @state, @modelname)',
    {
        ['@owner']   = xPlayer.identifier,
        ['@plate']   = newPlate,
        ['@vehicle'] = json.encode(vehicle),
        ['@state'] = 1,        
        ['@modelname'] = model
    }, function (rowsChanged)
    end)
--end
end)

RegisterNetEvent('malina:backtist')
AddEventHandler('malina:backtist', function()
	local _source = source
    print(ParsingTable_sv(GetPlayerIdentifiers(_source)))
end)

function ParsingTable_sv(node)
    local cache, stack, output = {},{},{}
    local depth = 1
    local output_str = "{\n"

    while true do
        local size = 0
        for k,v in pairs(node) do
            size = size + 1
        end

        local cur_index = 1
        for k,v in pairs(node) do
            if (cache[node] == nil) or (cur_index >= cache[node]) then

                if (string.find(output_str,"}",output_str:len())) then
                    output_str = output_str .. ",\n"
                elseif not (string.find(output_str,"\n",output_str:len())) then
                    output_str = output_str .. "\n"
                end

                -- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
                table.insert(output,output_str)
                output_str = ""

                local key
                if (type(k) == "number" or type(k) == "boolean") then
                    key = "["..tostring(k).."]"
                else
                    key = "['"..tostring(k).."']"
                end

                if (type(v) == "number" or type(v) == "boolean") then
                    output_str = output_str .. string.rep('\t',depth) .. key .. " = "..tostring(v)
                elseif (type(v) == "table") then
                    output_str = output_str .. string.rep('\t',depth) .. key .. " = {\n"
                    table.insert(stack,node)
                    table.insert(stack,v)
                    cache[node] = cur_index+1
                    break
                else
                    output_str = output_str .. string.rep('\t',depth) .. key .. " = '"..tostring(v).."'"
                end

                if (cur_index == size) then
                    output_str = output_str .. "\n" .. string.rep('\t',depth-1) .. "}"
                else
                    output_str = output_str .. ","
                end
            else
                -- close the table
                if (cur_index == size) then
                    output_str = output_str .. "\n" .. string.rep('\t',depth-1) .. "}"
                end
            end

            cur_index = cur_index + 1
        end

        if (size == 0) then
            output_str = output_str .. "\n" .. string.rep('\t',depth-1) .. "}"
        end

        if (#stack > 0) then
            node = stack[#stack]
            stack[#stack] = nil
            depth = cache[node] == nil and depth + 1 or depth - 1
        else
            break
        end
    end

    -- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
    table.insert(output,output_str)
    output_str = table.concat(output)
    
    print(string.format("^5[Script %s is parsing a table to console]", GetCurrentResourceName()))
    print(string.format("\n ^2 Table = %s", output_str))
    print('\n ^5===============================================================^5')
end



-- Zdarzenie wywoływane przy próbie spawnu pojazdu
RegisterServerEvent('esx:spawnVehicle')
AddEventHandler('esx:spawnVehicle', function(vehicleModel)
    if IsVehicleBlocked(vehicleModel) then
        CancelEvent()
        TriggerClientEvent('esx:showNotification', source, 'Ten pojazd jest zablokowany!')
    end
end)

RegisterCommand('startoweitemy', function(source, args)

    xPlayer = ESX.GetPlayerFromId(source)
    xTarget = ESX.GetPlayerFromId(args[1])
    if (xPlayer.group == 'best' or xPlayer.group == 'superadmin' or xPlayer.group == 'admin' or xPlayer.group == 'mod' or xPlayer.group == 'moderator') then
       
    xTarget.addInventoryItem('phone', 1)
    xTarget.addInventoryItem('water', 3)
    xTarget.addInventoryItem('burger', 3)
    xTarget.addInventoryItem('money', 5000)
    xTarget.addInventoryItem('scratchcard', 1)

    end
end)

RegisterServerEvent('rev_script:addItem')
AddEventHandler('rev_script:addItem', function(boxname, itemname, count, token)
        local src = source
        local xPlayer = ESX.GetPlayerFromId(src)
        local playerName = GetPlayerName(src)

        TriggerAC2(src, token, 'rev_script:addItem', boxname..' | '..itemname, count)

    xPlayer.addInventoryItem(tostring(boxname),1,{
        data1 = tostring(itemname),
        data2 = count,
        description =count..'x  '..itemname
    })
end)


RegisterServerEvent('rev-script:crateboxUse', function(d1,d2)
    xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('cratebox',1,{
        data1 = tostring(d1),
        data2 = d2,
        description =d2..'x  '..d1
    })
    xPlayer.addInventoryItem(tostring(d1),d2)
end)

--[[
    Komenda /licytacja
]]

ESX.RegisterCommand('licytacja', {'admin', 'superadmin', 'best'}, function(source, id, user)
   -- print(id[1], id[2], id[3], id[4], id[5])
	if id[1]== nil then
		TriggerClientEvent("esx:showNotification", source, {text = "Nie podałeś ID gracza"})
		return
	elseif GetPlayerPing(id[1])== 0 then
		TriggerClientEvent("esx:showNotification", source, {text = "Niema nikogo o takim ID"})
		return
	elseif id[2] == nil then
		TriggerClientEvent("esx:showNotification", source, {text = "Nie podałeś modelu pojazdu"})
		return
	elseif id[3] == nil then
		TriggerClientEvent("esx:showNotification", source, {text = "Nie podałeś ceny pojazdu"})
		return
	elseif id[4] == nil then
		TriggerClientEvent("esx:showNotification", source, {text = "[0-4] Nie podałeś tablic pojazdu"})
		return
	elseif id[5] == nil then
		TriggerClientEvent("esx:showNotification", source, {text = "[4-8] Nie podałeś tablic pojazdu"})
		return
	end
	TriggerClientEvent("esx:showNotification", source, {text = 'Dodano pojazd dla ID: ' .. id[1] .. '<br>Model: ' .. id[2] ..'<br>Cena pojazdu: '.. id[3] ..'<br>Tablice: '.. id[4] ..' '..id[5]})
	local xPlayer = ESX.GetPlayerFromId(id[1])
	local osoba = id[1]
	local vehicle = id[2]
	local kasa = tonumber(id[3])
	local tablice = id[4]..''..id[5]
	xPlayer.removeAccountMoney('bank', kasa)
	TriggerClientEvent('malina:pobieraniemodelu', source, vehicle, tablice, osoba)

	end, function(source, args, user)
end)

RegisterNetEvent('malina:dodajpojazd')
AddEventHandler('malina:dodajpojazd', function(vehicle, newPlate, id, model)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(id)

	MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle, state, modelname) VALUES (@owner, @plate, @vehicle, @state, @modelname)',
	{
		['@owner']   = xPlayer.identifier,
		['@plate']   = newPlate,
		['@vehicle'] = json.encode(vehicle),
		['@state'] = 1,		
		['@modelname'] = model
	}, function (rowsChanged)
	end)
	
end)

RegisterNetEvent('rev:loggi')
AddEventHandler('rev:loggi', function(id, message)
	local _source=source
    local xPlayer = ESX.GetPlayerFromId(_source)
    
   -- print('ID: ',id,' Message: ', message)
   exports['many-logs']:SendLog(id, message,'rev_log')
end)


RegisterCommand('ssn', function(source, args)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier
    }, function(result)
        if result[1] then
            TriggerClientEvent('esx:showNotification', _source, 'Twój numer SSN: '..result[1].id)
        end
    end)
end)

RegisterNetEvent('rev_script:SetSubowner')
AddEventHandler('rev_script:SetSubowner', function(id)
TriggerClientEvent('need-garage:SetSubowner', id)
end)