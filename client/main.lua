ESX = exports['es_extended']:getSharedObject();
local PlayerData = {}
RSE = RegisterServerEvent
RNE = RegisterNetEvent
AEH = AddEventHandler
TSE = TriggerServerEvent
TE = TriggerEvent
RC = RegisterCommand


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

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    local playerPed = GetPlayerPed(-1)
    if not IsControlPressed(0, 25) then
      -- nie uderza, ponieważ nie trzyma PPM lub nie jest uzbrojony
            DisableControlAction(0, 24, true) -- wyłączenie LPM
            DisableControlAction(0, 140, true) -- wyłączenie LPM
            DisableControlAction(0, 141, true) -- wyłączenie LPM
            DisableControlAction(0, 142, true) -- wyłączenie LPM
            DisableControlAction(0, 143, true) -- wyłączenie LPM
            DisableControlAction(0, 257, true) -- wyłączenie LPM
    end
  end
end)

--[[
  ----KOSTKA----
]]

RegisterNetEvent('sendProximityMessageKostka')
AddEventHandler('sendProximityMessageKostka', function(id, name, message)
    local myId = PlayerId()
    local pid = GetPlayerFromServerId(id)
	if pid ~= -1 then	       
    if pid ~= -1 then   
		if pid == myId then
			TriggerEvent('chat:addMessage', {
				template = '<div style="padding: 0.4vw; margin: 0.5vw; font-size: 15px; background-color: rgba(114, 118, 214, 0.4); border-radius: 3px;"><i class="fas fa-user-circle"></i>&nbsp;[{0}]: {1}</div>',
				args = { name, message }
			})
		elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(myId)), GetEntityCoords(GetPlayerPed(pid)), true) <= 19.99 then
			if NetworkIsPlayerActive(pid) then
			TriggerEvent('chat:addMessage', {
				template = '<div style="padding: 0.4vw; margin: 0.5vw; font-size: 15px; background-color: rgba(114, 118, 214, 0.4); border-radius: 3px;"><i class="fas fa-user-circle"></i>&nbsp;[{0}]: {1}</div>',
				args = { name, message }
			})
			end
		end
	end
	end
end)

-----------------------------------------               Wiadomości EMS LSPD ADMIN               ---------------------------------------------------


TriggerEvent('chat:addTemplate', 'admin1', '<div style="padding: 0.4vw; margin: 0.5vw; font-size: 15px; background: rgba(255, 0, 0, 1); border-radius: 3px;"><i class="fas fa-user-circle"></i>&nbsp;[{0}]: {1}</div>')
TriggerEvent('chat:addTemplate', 'lspd1', '<div style="padding: 0.4vw; margin: 0.5vw; font-size: 15px; background-color: rgba(0, 0, 255, 1); border-radius: 3px;"><i class="fas fa-user-circle"></i>&nbsp;[{0}]: {1}</div>')
TriggerEvent('chat:addTemplate', 'ems1', '<div style="padding: 0.4vw; margin: 0.5vw; font-size: 15px; background-color: rgba(255, 100, 0, 1); border-radius: 3px;"><i class="fas fa-user-circle"></i>&nbsp;[{0}]: {1}</div>')


RegisterCommand("admin", function(source, args)

	ESX.TriggerServerCallback('rev:checkadmin', function(source, cb)
	if source == 'admin' or source == 'superadmin' or source == 'best' or source == 'mod' or source == 'moderator' then
		print(source, cb)
	kto = 'ADMIN'
	temp ='admin1'
    message = table.concat(args, " ")
	local playerName = GetPlayerName(PlayerId())
	TriggerServerEvent('chat:specialMessage', temp, kto, message)
	TriggerServerEvent('malina-logs:chat', "**"..playerName.."**: /admin "..message, 'chat', '15158332', playerName)
	--exports['many-logs']:SendLogCzat(source, "**"..playerName.."**: /admin"..message, 'chat', '15158332', playerName)
		end
		end)
end)
RegisterCommand("lspd", function(source, args)
	if ESX.PlayerData.job.name == 'police' then
	kto = 'LSPD'
	temp ='lspd1'
    message = table.concat(args, " ")
	local playerName = GetPlayerName(PlayerId())
	TriggerServerEvent('chat:specialMessage', temp, kto, message)
	TriggerServerEvent('malina-logs:chat', "**"..playerName.."**: /lspd "..message, 'chat', '15158332', playerName)
	end
end)
RegisterCommand("ems", function(source, args)
	if ESX.PlayerData.job.name == 'ambulance' then
	kto = 'EMS'
	temp ='ems1'
    message = table.concat(args, " ")
	local playerName = GetPlayerName(PlayerId())
	TriggerServerEvent('chat:specialMessage', temp, kto, message)
	TriggerServerEvent('malina-logs:chat', "**"..playerName.."**: /ems "..message, 'chat', '15158332', playerName)
	end
end)

RegisterNetEvent("no-perms")
AddEventHandler("no-perms", function()
    TriggerEvent("chatMessage", "[Error]", {255,0,0}, "Sorry, but you don't have permission to do this" )
end)



function areaCheck(player,x,y,z,r)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local distance = GetDistanceBetweenCoords(playerCoords.x, playerCoords.y, playerCoords.z, x, y, z, true)
    local radius = r
    return distance <= radius
end
exports('areaCheck', areaCheck)


	--------------------------------------------------------------------------------- Zakładanie kamzy
	RegisterNetEvent('rev:kamza')
	AddEventHandler('rev:kamza', function ()
		local ped = GetPlayerPed(-1)
	
					ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(itemName)
						if itemName > 0 then
							TriggerEvent('pNotify:SendNotification', {text = "Trwa przebieranie sie"})
								male = {
									['bproof_1'] = 2,  ['bproof_2'] = 1
								}
							TriggerEvent('skinchanger:getSkin', function(skin)
										TriggerEvent('skinchanger:loadClothes', skin,male)
										SetPedMaxTimeUnderwater(GetPlayerPed(-1), 150.00)
							end)
						end
					end, 'armour')
				end)



------------------------------------------------------------------------------------------------------------------------------------------------------------

RegisterNetEvent('malina:pobieraniemodelu')
AddEventHandler('malina:pobieraniemodelu', function(model, tablice, osoba)
    ESX.Game.SpawnVehicle(model, vector3(0,0,0), 0, function (vehicle)
		local playerPed = PlayerPedId()
        TaskWarpPedIntoVehicle(playerPed, vehicle, -1)

        local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
        local VehType = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
        vehicleProps.plate = tablice
        SetVehicleNumberPlateText(vehicleProps.plate, tablice)
        
        Citizen.Wait(500)
        ESX.Game.SetVehicleProperties(vehicle, model)
        Citizen.Wait(500)
        ESX.Game.DeleteVehicle(vehicle)
        TriggerServerEvent('malina:dodajpojazd', vehicleProps, tablice, osoba, VehType)
    end)
end)


local tmp = {}

function Vector3check(coords)
  local playerPed = GetPlayerPed(-1)  -- Pobranie peda gracza
  local playerCoords = GetEntityCoords(playerPed)  -- Pobranie koordynatów gracza
  tmp = {}

  for i=1, #coords, 1 do
    local v = coords[i]
    local distance = GetDistanceBetweenCoords(playerCoords, v.x, v.y, v.z, true)  -- Obliczenie odległości między graczem a podanymi koordynatami

    if distance <= 10.0 then
      table.insert(tmp, true)
    else
      table.insert(tmp, false)
    end
  end

  local containsZero = false

  for _, value in ipairs(tmp) do
    if value == true then
      containsZero = true
      break
    end
  end

  return containsZero  -- Gracz jest zbyt daleko
end

exports('Vector3check', Vector3check)


RegisterNetEvent('esx:teleporthehe')
AddEventHandler('esx:teleporthehe', function(x, y, z)
	x = x + 0.0
	y = y + 0.0
	z = z + 0.0

	RequestCollisionAtCoord(x, y, z)

	while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
		RequestCollisionAtCoord(x, y, z)
		Citizen.Wait(1)
	end

	SetEntityCoords(PlayerPedId(), x, y, z)
end)



RegisterNetEvent('resetgodzinek')
AddEventHandler('resetgodzinek', function()
	local jobName = ESX.PlayerData.job.name
	local jobGrade = ESX.PlayerData.job.grade
	if (jobName == 'police' and jobGrade > 11) or (jobName=='ambulance' and jobGrade > 7) or (jobName == 'carzone' and jobGrade > 7 ) then

		local dialog = lib.alertDialog({
			header = 'System Zarządzania Pracownikami',
			content = 'Czy na pewno chcesz zrestartować godziny?!',
			centered = true,
			cancel = true
		})
		if dialog ~= 'confirm' then
			return
		end
		ESX.ShowNotification('Zresetowałeś godziny!')
		TriggerServerEvent('resetgodzinserver', ESX.PlayerData.job.name)
	else
		ESX.ShowNotification('Nie masz dostępu!')
	end
end)

RegisterNetEvent('sprawdzgodziny')
AddEventHandler('sprawdzgodziny', function()
	local jobName = ESX.PlayerData.job.name
	local jobGrade = ESX.PlayerData.job.grade
	if (jobName == 'police' and jobGrade > 11) or (jobName=='ambulance' and jobGrade > 7) or (jobName == 'carzone' and jobGrade > 7 ) then
		ESX.TriggerServerCallback('checkgodziny', function(source, cb)
			ESX.ShowNotification('Zapisałeś godziny!')
		end, ESX.PlayerData.job.name)
	else
		ESX.ShowNotification('Nie masz dostępu!')
	end
end)


RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded",	function(xPlayer)
		PlayerData = xPlayer
    end)

	function GenerateToken(length)
		local chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' -- Dostępne znaki
		local token = ''
		local charsLength = string.len(chars)
	
		--math.randomseed(os.time()) -- Inicjalizacja generatora liczb losowych
	
		for i = 1, length do
			local randomIndex = math.random(1, charsLength)
			token = token .. string.sub(chars, randomIndex, randomIndex)
		end
	
		return token
	end
	

function TokenSys()

	local index = math.random(5,30)
	local table = {}

	for i = 1, 32 do
		table[i] = GenerateToken(math.random(7,10))
	end
	table[1] = GenerateToken(index)
	table[index] = ESX.GetPlayerData().token --client_token
	--print(json.encode(table))

	return table

end
exports('TokenSys', TokenSys)