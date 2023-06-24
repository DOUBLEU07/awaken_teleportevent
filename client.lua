ESX = nil 
local statusairdropnormal = false
local canback = false

Citizen.CreateThread(function() 
	while ESX == nil do 
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) 
		Citizen.Wait(1) 
	end 
		PlayerData = ESX.GetPlayerData() 
end) 
 
RegisterNetEvent('esx:playerLoaded') 
AddEventHandler('esx:playerLoaded', function(xPlayer) 
	PlayerData = xPlayer 
end) 
 
RegisterNetEvent('esx:setJob') 
AddEventHandler('esx:setJob', function(job) 
	PlayerData.job = job 
end) 

RegisterNetEvent('ar_teleportevent:cl:getstatusairdropnormal') 
AddEventHandler('ar_teleportevent:cl:getstatusairdropnormal', function(status) 
	statusairdropnormal = status
end) 

RegisterCommand(Config.Command1, function()
    local Ped = PlayerPedId()
    local coords = GetEntityCoords(Ped)
    if statusairdropnormal then
        Effect(coords)
        TriggerEvent("mythic_progbar:client:progress", {

            name = "unique_action_name",
            duration = 5000,
            label = "Warp",
            useWhileDead = false,
            canCancel = true,
            controlDisables = {
                disableMovement = true,
                disableCarMovement = false,
                disableMouse = false,
                disableCombat = true
            }

        }, function(status)
            if not status then
                if statusflag then
                    canback = true
                    statusflag = false
                    TriggerEvent('ar_teleportevent:cl:getbackposition',coords)
                    SetEntityCoords(PlayerPedId(), Config.Coords1)
                end  
            end
        end)
    end
end, false)

RegisterCommand(Config.Command2, function()
    local Ped = PlayerPedId()
    local coords = GetEntityCoords(Ped)
    if statusairdropnormal then
        Effect(coords)
        TriggerEvent("mythic_progbar:client:progress", {

            name = "unique_action_name",
            duration = 5000,
            label = "Warp",
            useWhileDead = false,
            canCancel = true,
            controlDisables = {
                disableMovement = true,
                disableCarMovement = false,
                disableMouse = false,
                disableCombat = true
            }

        }, function(status)
            if not status then
                if statusflag then
                    canback = true
                    statusflag = false
                    TriggerEvent('ar_teleportevent:cl:getbackposition',coords)
                    SetEntityCoords(PlayerPedId(), Config.Coords2)
                end  
            end
        end)
    end
end, false)

RegisterCommand(Config.Command3, function()
    local Ped = PlayerPedId()
    local coords = GetEntityCoords(Ped)
    if statusairdropnormal then
        Effect(coords)
        TriggerEvent("mythic_progbar:client:progress", {

            name = "unique_action_name",
            duration = 5000,
            label = "Warp",
            useWhileDead = false,
            canCancel = true,
            controlDisables = {
                disableMovement = true,
                disableCarMovement = false,
                disableMouse = false,
                disableCombat = true
            }

        }, function(status)
            if not status then
                if statusflag then
                    canback = true
                    statusflag = false
                    TriggerEvent('ar_teleportevent:cl:getbackposition',coords)
                    SetEntityCoords(PlayerPedId(), Config.Coords3)
                end  
            end
        end)
    end
end, false)


Effect = function(coords)
    Citizen.CreateThread(function()
        local TypePT 	= "proj_indep_firework_v2"
        local particle 	= "scr_firework_indep_repeat_burst_rwb"
        PlayEffect(TypePT, particle, coords.x, coords.y, coords.z+1.0, 0.5)
    end)
end

function PlayEffect(pdict, pname, posx, posy, posz, size)	
    UseParticleFxAssetNextCall(pdict)
    local PlayerPed = GetPlayerPed(-1)
    local pfx = StartParticleFxLoopedAtCoord(pname, posx, posy, posz, 20.0, 20.0, GetEntityHeading(PlayerPedId()), size, true, true, true, false)
    Citizen.Wait(100)
    StopParticleFxLooped(pfx, 0)
end

RegisterNetEvent('ar_teleportevent:cl:getbackposition') 
AddEventHandler('ar_teleportevent:cl:getbackposition', function(coords) 
    TriggerServerEvent('ar_teleportevent:sv:getbackposition',coords)
end) 

RegisterCommand("goback", function()
    TriggerEvent('ar_teleportevent:cl:tpback')
    canback = false
end, false)

RegisterNetEvent('ar_teleportevent:cl:tpback') 
AddEventHandler('ar_teleportevent:cl:tpback', function() 
    Wait(2000)
    if canback then
        ESX.TriggerServerCallback('ar_teleportevent:callbackgetbackposition',function(position)
            if position == 'garage' then
                local garagecoords = vector3(-271.3999938964844, -911.969970703125, 31.25)
                SetEntityCoords(PlayerPedId(), garagecoords)
                canback = false
            else
                local backpostion = vector3(position.x, position.y, position.z)
                SetEntityCoords(PlayerPedId(), backpostion)
                canback = false
            end
        end)
    end
end) 

function Checkitem(item_name)
    local inventory = ESX.GetPlayerData().inventory
    for i=1, #inventory do
      local item = inventory[i]
      if item_name == item.name and item.count > 0 then
        return true
      end
    end
  
    return false
end

