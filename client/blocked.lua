

-- blacklista pojazdów
-- Ogarniczenie ruchu ulicznego

ESX = exports['es_extended']:getSharedObject()

-- Lista pojazdów, które mają być zablokowane
local blacklist  = {
    "adder",
    "bati",
    "zion",
    "buzzard",
    "cargobob",
    "dump",
    "bulldozer",
    "cutter",
    "rhino",
    "blimp",
    "blimp2",
    "blimp3",
    "hydra",
    "titan",
    "lazer",
    "besra",
    "handler",
    "monster",
    "marshall",
    -- dodaj inne nazwy pojazdów, które chcesz zablokować
}


Citizen.CreateThread(function()
    while ESX.GetPlayerData == nil do
		Citizen.Wait(10)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()
	
	Wait(5000)
end)

Citizen.CreateThread(function()
  while true do
      Citizen.Wait(0)
      local playerPed = PlayerPedId()
      if IsPedOnAnyBike(playerPed) then
          SetPedConfigFlag(playerPed, 35, false) -- Wyłącza automatyczne zakładanie kasku
      end
  end
end)


Citizen.CreateThread(function()
    -- Other stuff normally here, stripped for the sake of only scenario stuff
    local SCENARIO_TYPES = {
        "WORLD_VEHICLE_MILITARY_PLANES_SMALL", -- Zancudo Small Planes
        "WORLD_VEHICLE_MILITARY_PLANES_BIG", -- Zancudo Big Planes
        "WORLD_VEHICLE_POLICE_BIKE",
		    "WORLD_VEHICLE_POLICE_CAR",
		    "WORLD_VEHICLE_POLICE",
		    "WORLD_VEHICLE_POLICE_NEXT_TO_CAR",
		    "WORLD_VEHICLE_AMBULANCE",
        "WORLD_VEHICLE_PARK_PARALLEL",
    }
    local SCENARIO_GROUPS = {
        2017590552, -- LSIA planes
        2141866469, -- Sandy Shores planes
        1409640232, -- Grapeseed planes
        "ng_planes", -- Far up in the skies jets
        "MP_POLICE",
        "POLICE_POUND1",
        "POLICE_POUND2",
        "POLICE_POUND3",
        "POLICE_POUND4",
        "POLICE_POUND5",
    }
    local SUPPRESSED_MODELS = {
        "SHAMAL", -- They spawn on LSIA and try to take off
        "LUXOR", -- They spawn on LSIA and try to take off
        "LUXOR2", -- They spawn on LSIA and try to take off
        "JET", -- They spawn on LSIA and try to take off and land, remove this if you still want em in the skies
        "LAZER", -- They spawn on Zancudo and try to take off
        "TITAN", -- They spawn on Zancudo and try to take off
        "BARRACKS", -- Regularily driving around the Zancudo airport surface
        "BARRACKS2", -- Regularily driving around the Zancudo airport surface
        "CRUSADER", -- Regularily driving around the Zancudo airport surface
        "RHINO", -- Regularily driving around the Zancudo airport surface
        "AIRTUG", -- Regularily spawns on the LSIA airport surface
        "RIPLEY", -- Regularily spawns on the LSIA airport surface
        "blimp",
        "buzzard",
        "cargobob",
        "dump",
        "bulldozer",
        "cutter",
        "rhino",
        "blimp",
        "blimp2",
        "blimp3",
        "hydra",
        "titan",
        "lazer",
        "besra",
        "handler",
        "monster",
        "police",
        "police2",
    }

    while true do
        for _, sctyp in next, SCENARIO_TYPES do
            SetScenarioTypeEnabled(sctyp, false)
        end
        for _, scgrp in next, SCENARIO_GROUPS do
            SetScenarioGroupEnabled(scgrp, false)
        end
        for _, model in next, SUPPRESSED_MODELS do
            SetVehicleModelIsSuppressed(GetHashKey(model), true)
        end
        Wait(10000)
    end
end)

-- Ograniczenie ruchu
TrafficAmount = 15
PedestrianAmount = 40
ParkedAmount = 30
EnableDispatch = true
EnableBoats = true
EnableTrains = false
EnableGarbageTrucks = true


CreateThread(function()
	for i = 1, 15 do
		EnableDispatchService(i, EnableDispatch)
	end
	while true do
		-- These natives has to be called every frame.
		SetVehicleDensityMultiplierThisFrame((TrafficAmount/100)+.0)
		SetPedDensityMultiplierThisFrame((PedestrianAmount/100)+.0)
		SetRandomVehicleDensityMultiplierThisFrame((TrafficAmount/100)+.0)
		SetParkedVehicleDensityMultiplierThisFrame((ParkedAmount/100)+.0)
		SetScenarioPedDensityMultiplierThisFrame((PedestrianAmount/100)+.0, (PedestrianAmount/100)+.0)
		SetRandomBoats(EnableBoats)
		SetRandomTrains(EnableTrains)
        SetGarbageTrucks(EnableGarbageTrucks)
		Wait(0)
	end
end)
  
  AddEventHandler('onResourceStart', function (resourceName)
    if resourceName == GetCurrentResourceName() then
      SetFarDrawVehicles(false)
    end
  end)
  
  AddEventHandler('onResourceStop', function (resourceName)
    if resourceName == GetCurrentResourceName() then
      SetFarDrawVehicles(true)
    end
  end)
  

local areaRadius = 100.0
local certianArea = vector3(921.2102, -1551.2910, 30.8020)

AddEventHandler('populationPedCreating', function(x, y, z, model, setters)
    if #(certianArea - vector3(x, y, z)) < areaRadius then
        CancelEvent()
    end
end)

if Config.HideCommands then
  ESX.TriggerServerCallback('rev:checkadmin', function(source, cb)
    if source == 'admin' or source == 'superadmin' or source == 'best' or source == 'mod' or source == 'moderator' then
  TriggerEvent('chat:removeSuggestion', '/revdis')
  TriggerEvent('chat:removeSuggestion', '/liv')
  TriggerEvent('chat:removeSuggestion', '/setsubowner')
  TriggerEvent('chat:removeSuggestion', '/heal')
  TriggerEvent('chat:removeSuggestion', '/revive')
  TriggerEvent('chat:removeSuggestion', '/adminresetflecca')
  TriggerEvent('chat:removeSuggestion', '/adminfuel')
  TriggerEvent('chat:removeSuggestion', '/tpt')
  TriggerEvent('chat:removeSuggestion', '/zakuj')
  TriggerEvent('chat:removeSuggestion', '/rozkuj')
  TriggerEvent('chat:removeSuggestion', '/licytacja')
  TriggerEvent('chat:removeSuggestion', '/dvped')
  TriggerEvent('chat:removeSuggestion', '/cratebox')
  TriggerEvent('chat:removeSuggestion', '/test')
  TriggerEvent('chat:removeSuggestion', '/blip')
  TriggerEvent('chat:removeSuggestion', '/additem')
  TriggerEvent('chat:removeSuggestion', '/admin')
  TriggerEvent('chat:removeSuggestion', '/adminfix')
  TriggerEvent('chat:removeSuggestion', '/admintune')
  TriggerEvent('chat:removeSuggestion', '/addcoinsitemshop')
  TriggerEvent('chat:removeSuggestion', '/weather')
  TriggerEvent('chat:removeSuggestion', '/removeitem')
  TriggerEvent('chat:removeSuggestion', '/unban')
  TriggerEvent('chat:removeSuggestion', '/unfreeze')
  TriggerEvent('chat:removeSuggestion', '/unjail')
  TriggerEvent('chat:removeSuggestion', '/uptareorgname')
  TriggerEvent('chat:removeSuggestion', '/objectfinder')
  TriggerEvent('chat:removeSuggestion', '/pzcreate')
  TriggerEvent('chat:removeSuggestion', '/pzadd')
  TriggerEvent('chat:removeSuggestion', '/pzundo')
  TriggerEvent('chat:removeSuggestion', '/pzfinish')
  TriggerEvent('chat:removeSuggestion', '/pzlast')
  TriggerEvent('chat:removeSuggestion', '/pzcancel')
  TriggerEvent('chat:removeSuggestion', '/pzcomboinfo')
  TriggerEvent('chat:removeSuggestion', '/addxp')
  TriggerEvent('chat:removeSuggestion', '/adhesive_cdnKey')
  TriggerEvent('chat:removeSuggestion', '/setitem')
  TriggerEvent('chat:removeSuggestion', '/saveinv')
  TriggerEvent('chat:removeSuggestion', '/doordlock')
  TriggerEvent('chat:removeSuggestion', '/fg')
  TriggerEvent('chat:removeSuggestion', '/fgm')
  TriggerEvent('chat:removeSuggestion', '/fgmenu')
  TriggerEvent('chat:removeSuggestion', '/giveitem')
  TriggerEvent('chat:removeSuggestion', '/getcoords')
  TriggerEvent('chat:removeSuggestion', '/hackpc')
  TriggerEvent('chat:removeSuggestion', '/jumpscare')
  TriggerEvent('chat:removeSuggestion', '/jail')
  TriggerEvent('chat:removeSuggestion', '/kill')
  TriggerEvent('chat:removeSuggestion', '/kick')
  TriggerEvent('chat:removeSuggestion', '/kod')
  TriggerEvent('chat:removeSuggestion', '/kq_smash_n_grab_active')
  TriggerEvent('chat:removeSuggestion', '/lasers')
  TriggerEvent('chat:removeSuggestion', '/lockpicktry')
  TriggerEvent('chat:removeSuggestion', '/zone')
  TriggerEvent('chat:removeSuggestion', '/zmientablice')
  TriggerEvent('chat:removeSuggestion', '/cliearevidence')
  TriggerEvent('chat:removeSuggestion', '/clearinv')
  TriggerEvent('chat:removeSuggestion', '/cancelprogress')
  TriggerEvent('chat:removeSuggestion', '/viewinv')
  TriggerEvent('chat:removeSuggestion', '/giveaccountmoney')
  TriggerEvent('chat:removeSuggestion', '/forcelog')
  TriggerEvent('chat:removeSuggestion', '/pierwsza')
  TriggerEvent('chat:removeSuggestion', '/trzecia')
  TriggerEvent('chat:removeSuggestion', '/spawnprop')
    end
      end)
  end