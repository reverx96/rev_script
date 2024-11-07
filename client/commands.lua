ESX = exports['es_extended']:getSharedObject();
local PlayerData = {}
RSE = RegisterServerEvent
RNE = RegisterNetEvent
AEH = AddEventHandler
TSE = TriggerServerEvent
TE = TriggerEvent
RC = RegisterCommand
IsDead = false

Citizen.CreateThread(function()
    while ESX.GetPlayerData == nil do
		Citizen.Wait(10)
        ESX.PlayerData = ESX.GetPlayerData()
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
        ESX.PlayerData = ESX.GetPlayerData()
	end

	Wait(5000)
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded",	function(xPlayer)

    end)
--------------------------------------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------     Zamkniecie UI
RegisterCommand('closeui', function()
	ESX.UI.Menu.CloseAll()
	end)

    local isCursorFixed = false

RegisterCommand('fixcursor', function()
    isCursorFixed = not isCursorFixed
    --ESX.ShowNotification('Cursor Fix', 'Kursor naprawiony. Możesz go teraz przesuwać, ale nie będzie reagować na kliknięcia.')
    if isCursorFixed then
        SetNuiFocus(true, false)
        SetCursorLocation(0.0, 0.0)
        LeaveCursorMode()
        ESX.ShowNotification('Cursor Fix', 'Kursor naprawiony. Możesz go teraz przesuwać, ale nie będzie reagować na kliknięcia.')
        TriggerEvent('chat:addMessage', {
            args = {'Cursor Fix', 'Kursor naprawiony. Możesz go teraz przesuwać, ale nie będzie reagować na kliknięcia.'}
        })
    else
        SetNuiFocus(false, false)
        LeaveCursorMode()
        ESX.ShowNotification('Cursor Fix', 'Kursor naprawiony. Możesz go teraz przesuwać, ale nie będzie reagować na kliknięcia.')
        TriggerEvent('chat:addMessage', {
            args = {'Cursor Fix', 'Kursor przywrócony do normalnego działania.'}
        })
    end
    exports['many-radial']:ForceCloseRadial()
end)

RegisterCommand('nuifix2', function()
    SendNUIMessage({
        action = 'ui'
    })
Citizen.Wait(100)
    SendNUIMessage({
        action = 'forceClose'
    })
end)

    ----------------------------------------------   Malina Pedał

    RegisterCommand('pedal', function()
        TriggerServerEvent('malina:backtist')
    end)
------------------------------------------------------------------------  Kostka UI
RegisterCommand('kostka', function(source, args, rawCommand)
    -- Interpret the number of rolls
     rolls = 1
    if args[1] ~= nil and tonumber(args[1]) then
        rolls = tonumber(args[1])
        if rolls > 5 then
            rolls = 5
        end
     end
      local text = ''
        -- Roll and add up rolls
        local number = 0
        for i = rolls,1,-1
        do
            local numb = math.random(1,6)
            text = text .. ' ' .. numb .. ', '		
        end
      
        RequestAnimSet("anim@mp_player_intcelebrationmale@wank")
        TaskPlayAnim(GetPlayerPed(-1), "anim@mp_player_intcelebrationmale@wank", "wank", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
        Citizen.Wait(1500)
        ClearPedTasks(GetPlayerPed(-1))
      local ide = GetPlayerServerId(NetworkGetEntityOwner(GetPlayerPed(-1)))	
      TriggerServerEvent('kostka:napis', 'Wylosowane liczby to: '..text..'')
end)

------------------------------------------------------------------------------------------   Blip add zone
RegisterCommand('blip', function(source, args, rawCommand)
	ESX.TriggerServerCallback('rev:checkadmin', function(source, cb)
        if source == 'admin' or source == 'superadmin' or source == 'best' or source == 'mod' or source == 'moderator' then
		--print(args[1],args[2],args[3],args[4])
	if #args == 4 then
			local x = tonumber(args[1])
			local y = tonumber(args[2])
			local z = tonumber(args[3])
			local r = tonumber(args[4])
  
		Citizen.CreateThread(function()
			local coords = vector3(x, y, z)
			local AdminBlip = AddBlipForRadius(coords, r)
			SetBlipColour(AdminBlip, 59)
			SetBlipAlpha(AdminBlip, 128)
			ESX.ShowNotification('Dodano blipa')
		end)

	else
	ESX.ShowNotification('Tylko 4 zmienne - x, y, z, radius')
	end
end
	end)
end)



RC('spawnprop',function(source, args, rawCommand)
    
ESX.TriggerServerCallback('rev:checkadmin', function(source, cb)
    if source == 'admin' or source == 'superadmin' or source == 'best' then
        local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
        local heading = GetEntityHeading(GetPlayerPed(-1))

        prop = tostring(args[1])

        RequestModel(prop)
        Citizen.Wait(100)

        while not HasModelLoaded(prop) do
            Citizen.Wait(100)
        end

        local cone = CreateObject(prop, x+1, y, z, true, true, true)
        Citizen.Wait(100)
        PlaceObjectOnGroundProperly(cone)
        SetEntityHeading(cone, heading)
    end
end)
end)

RegisterCommand('cratebox', function(source, args, rawCommand)
	ESX.TriggerServerCallback('rev:checkadmin', function(source, cb)
        if source == 'admin' or source == 'superadmin' or source == 'best' then
    if #args == 2 then
    TriggerServerEvent('rev_script:addItem', 'cratebox' , args[1], args[2] , exports['rev_script']:TokenSys())
    elseif #args < 2 then
        ESX.ShowNotification('Za malo zmiennych')
    elseif #args > 2 then
        ESX.ShowNotification('Za dużo zmiennych')
    end
end
	end)
end)

RegisterCommand('dvped', function()
    ESX.TriggerServerCallback('rev:checkadmin', function(source, cb)
        if source == 'admin' or source == 'superadmin' or source == 'best' or source == 'mod' or source == 'moderator' then
    local playerPed = PlayerPedId() -- ID Twojego peda
    local playerCoords = GetEntityCoords(playerPed) -- Koordynaty Twojej pozycji

    -- Pętla, która iteruje przez wszystkie pedy w grze i usuwa te znajdujące się w określonej odległości od Ciebie
    for _, ped in ipairs(GetGamePool('CPed')) do
        local pedCoords = GetEntityCoords(ped)
        local distance = #(playerCoords - pedCoords) -- Obliczanie odległości między Tobą a pedem

        if distance <= 50.0 then -- Zmodyfikuj tę wartość, jeśli chcesz inny zasięg odległości
            DeletePed(ped) -- Usuwanie peda
        end
    end
end
end)
end)


RegisterCommand('licytacja', function(source, args)
	ESX.TriggerServerCallback('rev:checkadmin', function(source, cb)
        if source == 'admin' or source == 'superadmin' or source == 'best' then
            TriggerServerEvent('rev_script:licytacja', args)
        end
    end)
end)


RegisterNetEvent('esx_rpchatt:pobieraniemodelu')
AddEventHandler('esx_rpchatt:pobieraniemodelu', function(model, tablice, osoba)
    local playerPed = PlayerPedId() -- ID Twojego peda
    local playerCoords = GetEntityCoords(playerPed) -- Koordynaty Twojej pozycji
    ESX.Game.SpawnVehicle(model, vector3(playerCoords.x,playerCoords.y,playerCoords.z), 0, function (vehicle)
        TaskWarpPedIntoVehicle(playerPed, vehicle, -1)

        local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
        local VehType = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
        vehicleProps.plate = tablice
        SetVehicleNumberPlateText(vehicleProps.plate, tablice)
        
        Citizen.Wait(500)
        ESX.Game.SetVehicleProperties(vehicle, model)
        Citizen.Wait(500)
        ESX.Game.DeleteVehicle(vehicle)
        TriggerServerEvent('esx_rpchatt:dodajpojazd', vehicleProps, tablice, osoba, VehType)
    end)
end)


RegisterCommand('rozkuj', function(source,args)
    ESX.TriggerServerCallback('rev:checkadmin', function(source, cb)
        if source == 'admin' or source == 'superadmin' or source == 'best' or source == 'mod' or source == 'moderator' then
	TriggerServerEvent('esx_policejob:rozkujadmin', args[1])
        end
    end)
end)

RegisterCommand('zakuj', function(source, args)
    ESX.TriggerServerCallback('rev:checkadmin', function(source, cb)
        if source == 'admin' or source == 'superadmin' or source == 'best' or source == 'mod' or source == 'moderator' then
	local TargetPlayer = GetPlayerPed(GetPlayerFromServerId(target))
	TriggerServerEvent('esx_policejob:rozkujadmin1', args[1], true, false)
        end
    end)
end)


RegisterCommand('adminfuel', function()
	ESX.TriggerServerCallback('rev:checkadmin', function(source, cb)
		if source == 'admin' or source == 'superadmin' or source == 'best' then
			local JobVehicle  = GetVehiclePedIsIn(PlayerPedId(), false) -- Pobierz pojazd, w którym znajduje się gracz
            TriggerServerEvent('ox_fuel:pay', 1, 100.0, NetworkGetNetworkIdFromEntity(JobVehicle))
		end
	end)
end)

    
RegisterCommand('tpt', function(source, args)
	ESX.TriggerServerCallback('rev:checkadmin', function(source, cb)
	    if source == 'admin' or source == 'superadmin' or source == 'best' or source == 'mod' or source == 'moderator' then
            if args[1] == nil then
            print('Podaj nazwe tepeka')
            elseif args[1] == 'ballas' then
                SetEntityCoords(GetPlayerPed(-1), 0.76294469833374,  -1824.6336669922,  29.54141998291, 48.410060882568)
            elseif args[1] == 'carheist' then
                SetEntityCoords(GetPlayerPed(-1),  263.68460083008,  -1786.5989990234,  27.113151550293)
            elseif args[1] == 'flecca' then
                SetEntityCoords(GetPlayerPed(-1),  151.40953063965,  -1036.2359619141,  29.33917427063)
            elseif args[1] == 'mafia1' then
                SetEntityCoords(GetPlayerPed(-1), 4976.9506835938,  -5730.2475585938,  19.880258560181)
            elseif args[1] == 'mafia2' then
                SetEntityCoords(GetPlayerPed(-1), -121.47818756104, 981.80920410156, 235.79570007324)
            elseif args[1] == 'koka1' then
                SetEntityCoords(GetPlayerPed(-1),   1011.344543457,  4390.2836914063,  44.593441009521)
            elseif args[1] == 'weed1' then
                SetEntityCoords(GetPlayerPed(-1), -2009.2327880859,  2573.6909179688, 3.0020325183868)
            elseif args[1] == 'meta1' then
                SetEntityCoords(GetPlayerPed(-1), 2838.5212402344,  2801.4370117188,  57.742977142334)
            elseif args[1] == 'weed2' then
                SetEntityCoords(GetPlayerPed(-1),  -1601.8721923828,  5205.8115234375,  4.3100876808167)     
            elseif args[1] == 'koka2' then
                SetEntityCoords(GetPlayerPed(-1),  -168.24200439453,  6052.9243164063,  30.813545227051)
            elseif args[1] == 'meta2' then
                SetEntityCoords(GetPlayerPed(-1), 2664.3000488281, 1422.8161621094, 24.500776290894 )
            elseif args[1] == 'jub1' then
                SetEntityCoords(GetPlayerPed(-1), 713.18725585938,  578.58575439453,  129.05076599121)
            elseif args[1] == 'jub2' then
                SetEntityCoords(GetPlayerPed(-1), -622.08135986328, -233.68359375, 59.139175415039)
            elseif args[1] == 'jub3' then
                SetEntityCoords(GetPlayerPed(-1), -635.20263671875, -242.65368652344, 38.189334869385)
            elseif args[1] == 'pal1' then
                SetEntityCoords(GetPlayerPed(-1), 224.46, 6398.13, 31.62)
            elseif args[1] == 'pal2' then
                SetEntityCoords(GetPlayerPed(-1),  -93.624526977539, 6478.0205078125, 31.210760116577)
            end
        end
    end)
end)

RegisterCommand("adminresetflecca", function()
	ESX.TriggerServerCallback('rev:checkadmin', function(source, cb)
        if source == 'superadmin' or source == 'best' or source == 'admin' then
        TriggerServerEvent('rev_heist:resetFlecca')
        end
    end)
end)

RegisterCommand("setsubowner", function(source, args)
	ESX.TriggerServerCallback('rev:checkadmin', function(source, cb)
        if source == 'superadmin' or source == 'best' or source == 'admin' then
            print('Poszlo',args[1])
        TriggerServerEvent('rev_script:SetSubowner', args[1])
        end
    end)
end)

RegisterCommand('liv', function(source, args)
    ESX.TriggerServerCallback('rev:checkadmin', function(source, cb)
        if source == 'superadmin' or source == 'best' or source == 'admin' then
            local TR92 = PlayerPedId()
            local vehicle = GetVehiclePedIsIn(TR92,true)
            local livery = tonumber(args[1])
            SetVehicleLivery(vehicle, livery)
            SetVehicleMod(vehicle, 48, livery, true)
            print('xD', args[1], TR92, vehicle)
        end
    end)
end, false)

RC('revdis',function(source, args, rawCommand)
    local _source = source
        ESX.TriggerServerCallback('rev:checkadmin', function(source, cb)
            if source == 'admin' or source == 'superadmin' or source == 'best' or source == 'mod' or source == 'moderator' then
            TriggerServerEvent('arevive', args[1])
            end
        end)
end, false)


RegisterCommand('adminfix', function()
	ESX.TriggerServerCallback('rev:checkadmin', function(source, cb)
		if source == 'admin' or source == 'superadmin' or source == 'best' then
			playerPed = PlayerPedId()
			local JobVehicle  = GetVehiclePedIsIn(PlayerPedId(), false) -- Pobierz pojazd, w którym znajduje się gracz
			SetVehicleFixed( JobVehicle)
			ESX.ShowNotification('Naprawiono')
		end
	end)
end)


RegisterCommand('admintune', function()
	ESX.TriggerServerCallback('rev:checkadmin', function(source, cb)
		if source == 'admin' or source == 'superadmin' or source == 'best' then
			playerPed = PlayerPedId()
			local JobVehicle  = GetVehiclePedIsIn(PlayerPedId(), false) -- Pobierz pojazd, w którym znajduje się gracz
			SetVehicleModKit(JobVehicle, 0) -- Ustawia mod kit na 0 (maksymalne tuningi)
			ToggleVehicleMod(JobVehicle, 18, true) -- Włącza silnik turbo
			SetVehicleMod(JobVehicle, 11, GetNumVehicleMods(JobVehicle, 11) - 1, true) -- Silnik
			SetVehicleMod(JobVehicle, 12, GetNumVehicleMods(JobVehicle, 12) - 1, true) -- Hamulce
			SetVehicleMod(JobVehicle, 13, GetNumVehicleMods(JobVehicle, 13) - 1, true) -- Skrzynia
			SetVehicleMod(JobVehicle, 16, GetNumVehicleMods(JobVehicle, 16) - 1, true)  -- Armor 
			SetVehicleMod(JobVehicle, 17, GetNumVehicleMods(JobVehicle, 17) - 1, true)  -- Nitro
			SetVehicleMod(JobVehicle, 18, GetNumVehicleMods(JobVehicle, 18) - 1, true) -- Turbo
			ESX.ShowNotification('Ustawiono MaxTUNE')
		end
	end)
end)

RegisterCommand('revsta', function()

	ESX.TriggerServerCallback('rev:checkadmin', function(source, cb)
		if source == 'admin' or source == 'superadmin' or source == 'best' then
            ESX.TriggerServerCallback('esx_policejob:GetIdentifier1', function(SSN)
                exports.ox_inventory:openInventory('stash', { id = 'admin_storage', owner = SSN })
            end, tonumber(GetPlayerServerId(GetPlayerIndex())))
           
		end
	end)
end)

