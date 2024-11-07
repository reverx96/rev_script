ESX = exports['es_extended']:getSharedObject();
local PlayerData = {}
RSE = RegisterServerEvent
RNE = RegisterNetEvent
AEH = AddEventHandler
TSE = TriggerServerEvent
TE = TriggerEvent
RC = RegisterCommand

-- Notatka Rev zapisywanie metadaty i informacji w itemie znajdziesz cieciu w many-clothes tam w Torsie zapisywana jest metadata do itemu

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




tmp = {}

function PropsDeletePolice()
    zonesName = {}
    ESX.TriggerServerCallback('rev:props:getTable', function(table)
        tmp = table
    end)
    Citizen.Wait(500)
    print(tmp)
        for k, zones in pairs(tmp) do
            table.insert(zonesName, {label = k, value = k})
        end

        --	ESX.UI.Menu.CloseAll()

            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'Stref_menu', {
                title    = "Menu Stref",
                align    = 'right',
                elements = zonesName
            }, function(data, menu)
                TriggerServerEvent('rev:props:delete', data.current.value)
            end, function(data, menu)
                menu.close()
            end)

end
exports('PropsDeletePolice',PropsDeletePolice)



RegisterNetEvent('rev:props:init')
AddEventHandler('rev:props:init', function(prop, playerID)
    print('client',prop,playerID)
    local model     =  prop
    local playerPed = PlayerPedId()
    local coords    = GetEntityCoords(playerPed)
    local forward   = GetEntityForwardVector(playerPed)
    
    groundZ = GetGroundZFor_3dCoord(coords.x, coords.y, coords.z, 0.0, 0.0, 1)

    print('Ground: ', groundZ, coords.z)
    print(model,playerPed,playerID,coords,forward,GetEntityHeading(playerPed))
    TriggerServerEvent('rev:props:server',prop,playerPed,playerID,coords,forward,GetEntityHeading(playerPed))

--[[		local x, y, z   = table.unpack(coords + forward * 1.0)
    obj = CreateObject(model, x, y, z, true, true, true)

    SetEntityHeading(obj, GetEntityHeading(playerPed))
    PlaceObjectOnGroundProperly(obj)]]
end)
--[[
CreateThread(function()
	while true do
		Wait(500)
			while DoesEntityExist(rev_crate) and rev_crateClosestDistance <= 4.0 and IsPedOnFoot(PlayerPedId()) do
				Wait(0)
				TriggerEvent('HelpNotification:Show', "Naciśnij ~INPUT_CONTEXT~ aby usunąć skrzynie")
				if IsControlJustReleased(0, 51) then
					RemoveSkrzynia()
				end
			end
	end
end)

CreateThread(function()
	while true do
		local driving = DoesEntityExist(GetVehiclePedIsUsing(PlayerPedId()))
		Wait((driving and 50) or 1000)
		local coords = GetEntityCoords((driving and GetVehiclePedIsUsing(PlayerPedId())) or PlayerPedId())

		local rev_crate = GetClosestObjectOfType(coords, 10.0, GetHashKey("prop_box_wood02a_pu"), false, false, false)
		if DoesEntityExist(rev_crate) then
			rev_crateClosest = rev_crate
			closestBarrierDistance = #(coords - GetEntityCoords(rev_crate))
		end

		if not DoesEntityExist(rev_crateClosest) or #(coords - GetEntityCoords(rev_crateClosest)) > 10.0 then
			rev_crateClosest = 0
		end
	end
end)

function RemoveSkrzynia()
    if DoesEntityExist(rev_crateClosest) then
        NetworkRequestControlOfEntity(rev_crateClosest)
        SetEntityAsMissionEntity(rev_crateClosest, true, true)
        DeleteEntity(rev_crateClosest)
        TriggerClientEvent('rev_getItem', 'case')
        Wait(250)
        if not DoesEntityExist(rev_crateClosest) then
            Citizen.Wait(100)
        end
    end
end]]



--[[
    exports.qtarget:AddTargetModel({'prop_box_wood02a_pu'}, {
    options = {
        {
            event = 'rev_script:open-crate',
            label = 'Otwórz skrzynie',
        },
        {
            event = 'rev_script:take-crate',
            label = 'Podnieś skrzynie ',
        },
},
distance = 3.0,
})

RegisterNetEvent('rev_script:open-crate',function(crid)

        print(crid.label)
        --print(crid.id)
    --exports['ox_inventory']:openInventory('container', 1 )
    --exports.ox_inventory:openInventory('stash', 3)
end)

RegisterNetEvent('rev_script:take-crate',function()

        local playerPed = GetPlayerPed(-1)
        local playerCoords = GetEntityCoords(playerPed)
        local maxDistance = 25.0 -- Maksymalna odległość, w której będą usuwane obiekty
        local propModelHash = GetHashKey('prop_box_wood02a_pu') -- Model obiektu, który chcemy usunąć
    
        -- Pętla iterująca przez wszystkie entity w grze
        for _, object in ipairs(GetGamePool('CObject')) do
            -- Sprawdzenie, czy entity to obiekt i czy jest w pobliżu gracza
            if DoesEntityExist(object) and IsEntityAnObject(object) then
                local objectCoords = GetEntityCoords(object)
                local distance = #(playerCoords - objectCoords) -- Obliczenie odległości między graczem a obiektem
    
                -- Jeżeli obiekt jest wystarczająco blisko gracza i jest żądanym modelem, usuń go
                if distance <= maxDistance and GetEntityModel(object) == propModelHash then
                    DeleteEntity(object)
                    TSE('rev-drugs:addItem', 'crate', 1 )
                end
            end
        end  
end)

]]