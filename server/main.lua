ESX = exports['es_extended']:getSharedObject()


RegisterNetEvent('arevive')
AddEventHandler('arevive', function(args)
    local playerCoords = GetEntityCoords(GetPlayerPed(source))
    local players = ESX.GetPlayers()

    if source == 0 then
		--deadPlayers[args[1]] = nil
		--TriggerClientEvent('hypex_ambulancejob:hypexrevive', tonumber(args[1]), true)
	else
		local xPlayer = ESX.GetPlayerFromId(source)
		if (xPlayer.group == 'best' or xPlayer.group == 'superadmin' or xPlayer.group == 'admin' or xPlayer.group == 'mod' or xPlayer.group == 'moderator') then
			local playerName = GetPlayerName(source)
			if args ~= nil then
                for _, playerId in ipairs(players) do
                    if playerId ~= source then
                        GlobalState.DeathReasonCheck[ESX.GetPlayerFromId(playerId).identifier] = nil
                        local targetCoords = GetEntityCoords(GetPlayerPed(playerId))
                        local distance = #(playerCoords - targetCoords)
                        
                        if distance <= tonumber(args) then
                            TriggerClientEvent("esx:showNotification", playerId, "Zostałeś ożywiony przez administratora!")
                            TriggerClientEvent('hypex_ambulancejob:hypexrevive', playerId, true)
                        end
                    end
                end
			else
                for _, playerId in ipairs(players) do
                    if playerId ~= source then
                        local targetCoords = GetEntityCoords(GetPlayerPed(playerId))
                        local distance = #(playerCoords - targetCoords)
                        
                        if distance <= 10.0 then
                            TriggerClientEvent("esx:showNotification", playerId, "Zostałeś ożywiony przez administratora!")
                            TriggerClientEvent('hypex_ambulancejob:hypexrevive', playerId, true)
                        end
                    end
                end


				exports['many-logs']:SendLogCzat(source, playerName.." użył **/revdis**", "admin_commands", '15158332', playerName)
			end
		else
			xPlayer.showNotification('Nie posiadasz permisji')
		end
	end
end)

RegisterNetEvent('resetgodzinserver')
AddEventHandler('resetgodzinserver', function(job_name)
local _source = source
local xPlayer = ESX.GetPlayerFromId(_source)
local playerName = GetPlayerName(_source)

checkhours(_source ,job_name)
Wait(100)
MySQL.Async.execute('UPDATE duty SET total = @total WHERE job = @job',{ 
    ['@total'] = 0,
    ['@job'] = job_name,
})
end)


ESX.RegisterServerCallback('checkgodziny', function(source, cb, job_name)
local _source = source
checkhours(_source, job_name)
cb(true)
end)


function checkhours(id,job_name)
    local _source = id
    MySQL.Async.fetchAll('SELECT users.badge, users.firstname, users.lastname, users.nickname, CONCAT(FLOOR(duty.total / 60), ":", LPAD(duty.total % 60, 2, "0")) AS Godziny FROM duty INNER JOIN users ON users.identifier =  duty.identifier WHERE users.job =@job_name or users.job2 = @job_name OR users.job =@job_name2 or users.job2 =@job_name2 ORDER BY total DESC', {
        ['@job_name'] = job_name,
        ['@job_name2'] = 'off'..job_name
    
    }, function(result)
        local MessageLog = ' używa funckji do pobrania godzin!\n ``` |\t  Imie     |\t   Nazwisko   |   Nick Steam   |   Godzinki   |``` \n'
        local godzinki = ''


    if job_name == 'police' then
          czescresulta = #result - 30
          czescresulta2 = czescresulta - 30
          MessageLog2 = ' część druga godzinek'
          MessageLog3 = 'część trzecia godzinek'
            --print(#result,czescresulta, czescresulta2)
        for i = 1, 30 do
            local userData = result[i]
    
            if userData.Godziny ~= nil then
                godzinki = userData.Godziny
            else
                godzinki = '00:00'
            end
    
            MessageLog = MessageLog..' ``` '..userData.firstname.. "   |   " ..userData.lastname..  "   |   " .. userData.nickname .. "   |   " .. godzinki .."``` \n"
        end

        if czescresulta > 0 then
            
           -- print(czescresulta2)
            if czescresulta2 <= 0 then
                for i = 31, #result do
                    local userData = result[i]
            
                    if userData.Godziny ~= nil then
                        godzinki = userData.Godziny
                    else
                        godzinki = '00:00'
                    end
            
                    MessageLog2 = MessageLog2..' ``` '..userData.firstname.. "   |   " ..userData.lastname..  "   |   " .. userData.nickname .. "   |   " .. godzinki .."``` \n"
                end
            else
                for i = 31, 60 do
                    local userData = result[i]
            
                    if userData.Godziny ~= nil then
                        godzinki = userData.Godziny
                    else
                        godzinki = '00:00'
                    end
            
                    MessageLog2 = MessageLog2..' ``` '..userData.firstname.. "   |   " ..userData.lastname..  "   |   " .. userData.nickname .. "   |   " .. godzinki .."``` \n"
                end

                for i = 61, #result do
                    local userData = result[i]
            
                    if userData.Godziny ~= nil then
                        godzinki = userData.Godziny
                    else
                        godzinki = '00:00'
                    end
            
                    MessageLog3 = MessageLog3..' ``` '..userData.firstname.. "   |   " ..userData.lastname..  "   |   " .. userData.nickname .. "   |   " .. godzinki .."``` \n"
                end


            end
        end
    else
        for i = 1, #result do
            local userData = result[i]
    
            if userData.Godziny ~= nil then
                godzinki = userData.Godziny
            else
                godzinki = '00:00'
            end
    
            MessageLog = MessageLog..' ``` '..userData.firstname.. "   |   " ..userData.lastname..  "   |   " .. userData.nickname .. "   |   " .. godzinki .."``` \n"
        end
    end
    
    --exports['many-logs']:SendLog(_source, MessageLog, 'rev_log')
        --print(czescresulta , czescresulta2)


            if job_name == 'ambulance' then
                exports['many-logs']:SendLog(_source, MessageLog, 'ems_hours')
            elseif job_name == 'police' then
                local war1 = czescresulta > 0
                local war2 = czescresulta2 > 0
                Citizen.Wait(0)
                    exports['many-logs']:SendLog(_source, MessageLog, 'lspd_hours')
                    if war2 then
                        Citizen.Wait(15)
                        exports['many-logs']:SendLog(_source, MessageLog2, 'lspd_hours')
                        Citizen.Wait(100)
                        exports['many-logs']:SendLog(_source, MessageLog3, 'lspd_hours')
                    elseif war1 then
                        Citizen.Wait(15)
                        exports['many-logs']:SendLog(_source, MessageLog2, 'lspd_hours')
                    end

            elseif job_name == 'carzone' then
                exports['many-logs']:SendLog(_source, MessageLog, 'mech_hours')
            end
    end)
end




RegisterServerEvent('revtestserver')
AddEventHandler( 'revtestserver',function(token)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local playerName = GetPlayerName(src)

    TriggerAC2(src, token, 'Cratebox')

end)

function TriggerAC(target, token, script_name, itemName, itemCount)

    local xPlayer = ESX.GetPlayerFromId(target)
    local playerName = GetPlayerName(target)
    local server_token = xPlayer.token

    local tableLog = {
        item_name = itemName or '',
        item_count = itemCount or '',
        client_token = token or '',
        server_token = server_token or '',
        hash = xPlayer.token_hash or ''
        
    }

    --print(target, token, server_token, script_name,itemName, itemCount)
    if server_token ~= token then
        local channels = 'https://discord.com/api/webhooks/1144029602562461779/LAKKrpPUrxiGXFrj4CaBWNzaAo6xS2RQLuA0Riv-v6CRUTTu5d7e3bG1Hn3fpyb6T1ww'
        exports['many-logs']:RevLog(target,  channels, 'triggerlog', tableLog , script_name)
        return
    end
end
exports('TriggerAC', TriggerAC)


function TriggerAC2(target, token, script_name, itemName, itemCount)

    local xPlayer = ESX.GetPlayerFromId(target)
    local playerName = GetPlayerName(target)
    local server_token = xPlayer.token

    local t_type = type(token)
    print(t_type)
    local client_token_decrypt = ''
    local index = 0
    
    if t_type == 'table' then

            local token_hash = token[1]

            if xPlayer.token_hash == nil or xPlayer.token_hash == '' then
                index = string.len(token[1])
                client_token_decrypt = token[index]
                xPlayer.updateToken_hash(token[1])
            elseif xPlayer.token_hash ~= token[1] then
                index = string.len(token[1])
                client_token_decrypt = token[index]
                xPlayer.updateToken_hash(token[1])
            elseif xPlayer.token_hash == token[1] then
                client_token_decrypt = ''
            end

    end


    if server_token ~= client_token_decrypt then
        if t_type == 'table' then
            token = json.encode(token)
        end
        local tableLog = {
            item_name = itemName or '',
            item_count = itemCount or '',
            client_token = token or '',
            server_token = server_token or '',
            hash = xPlayer.token_hash or ''
        }

        local channels = 'https://discord.com/api/webhooks/1144029602562461779/LAKKrpPUrxiGXFrj4CaBWNzaAo6xS2RQLuA0Riv-v6CRUTTu5d7e3bG1Hn3fpyb6T1ww'
        exports['many-logs']:RevLog(target,  channels, 'triggerlog', tableLog , script_name)
        return
    end
end
exports('TriggerAC2', TriggerAC2)


PoliceProps = {}

--TriggerServerEvent('rev:props:server',model,playerPed,playerID,coords,forward)
ESX.RegisterServerCallback('rev:props:getTable', function(source,cb)
cb(PoliceProps)
end)

RegisterNetEvent('rev:props:server')
AddEventHandler('rev:props:server', function(model,playerPed,playerID,coords,forward,hedding)
       -- print('xxx')
        local ident = ESX.GetPlayerFromId(source).identifier
        local name =  ESX.GetPlayerFromId(source).getName()
		local model = tostring(model)
      	local x, y, z = table.unpack(coords + forward * 1.0)

        local hedding = tonumber(hedding)
		Citizen.Wait(100)
        --print(model,playerPed,playerID,coords,forward,hedding,x,y,z)
        local cone = CreateObject(model, x, y, z, true, true, true)

        while cone == 0 do
            Citizen.Wait(1000)
            cone = CreateObject(model, x, y, z, true, true, true)
        end

        if PoliceProps[name] == nil then
            PoliceProps[name] = {cone}
        else
            table.insert(PoliceProps[name], cone)
        end

        --print(ident, cone, name)
        --[[table.insert(CreatedNarkos,{
            name = narko.name,
            prop = cone})]]

        SetEntityCoords(cone, x, y, z-1.0) 
        SetEntityHeading(cone, hedding)


end)

RegisterNetEvent('rev:props:delete')
AddEventHandler('rev:props:delete', function(name)
--print('rozpoczynam .....', name)

    -- Delete prop
    if PoliceProps[name] ~= nil then
        for i, prop in ipairs(PoliceProps[name]) do
            --print(i, prop)
            DeleteEntity(prop)
           -- Citizen.InvokeNative(0xAE3CBE5BF394C9C9, Citizen.PointerValueIntInitialized(prop))
        end
        PoliceProps[name] = nil
    end

end)



discord = {
    ['webhook'] = 'https://discord.com/api/webhooks/1143457138430185502/cLlx6S-YcmC6UOznRnFNLAsnfIAQ6YQKCzHu9_RsG5WSGvZnmydz4xp3X4RVq1gvP88I',
    ['name'] = 'RevLog2_v2',
    ['image'] = 'https://media.discordapp.net/attachments/1100475262950449304/1201147265054674964/jaspernazist.png?ex=65d1fd10&is=65bf8810&hm=59dd0b1a9dad5b481927075b194bb6ee4e23db350a4c3f76514e75b10272690a&=&format=webp&quality=lossless&width=691&height=671'
}

function discordLog(name, message)
    print('chuj')
    local data = {
        {
            ["color"] = '3553600',
            ["title"] = "**".. name .."**",
            ["description"] ='<@361558182541262849> \n'.. message,
        }
    }
    PerformHttpRequest(discord['webhook'], function(err, text, headers) end, 'POST', json.encode({username = discord['name'], embeds = data, avatar_url = discord['image']}), { ['Content-Type'] = 'application/json' })

end

exports('discordLog',discordLog)



