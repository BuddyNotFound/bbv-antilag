Main = {
    Enabled = true,
    player = PlayerPedId,
    antilag = false
}

RegisterCommand("antilag", function()
    if Main.Enabled then 
        Main.Enabled = false
        PlaySoundFrontend(-1, 'CONFIRM_BEEP', 'HUD_MINI_GAME_SOUNDSET', true)
        Wrapper:Notify(Lang.Off,'error',2500)
    else
        PlaySoundFrontend(-1, 'CONFIRM_BEEP', 'HUD_MINI_GAME_SOUNDSET', true)
        Wrapper:Notify(Lang.On,'success',2500)
        Main.Enabled = true
    end
end, false)

local kp = 0

CreateThread(function()
    while true do
        Wait(Main.sleep)
        if Main.antilag then 
            Main.sleep = 1000
            Main.ped = Main.player()
            veh = GetVehiclePedIsIn(Main.ped, false)
            Main.Delay = math.random(25, 350)
            if GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId()), -1) == Main.ped and Main.Enabled then
                Main.sleep = 0
                local RPM = GetVehicleCurrentRpm(veh, Main.ped)
                local gear = GetVehicleCurrentGear(veh)
                local vehicleModel = GetEntityModel(veh, Main.ped)
                    if gear ~= kp  then
                        if not IsEntityInAir(veh) then
                            if not IsControlPressed(1, 71) and not IsControlPressed(1, 72) then
                                if RPM > Config.Settings.RPM then
                                TriggerServerEvent("bbv-antilag:syncflames:s", VehToNet(veh),true)
                                TriggerServerEvent("sound_server:PlayWithinDistance", 25.0,tostring(math.random(1, 6)),0.9)
                                SetVehicleTurboPressure(veh, 25)
                                Wait(Main.Delay)
                                TriggerServerEvent("bbv-antilag:syncflames:s", VehToNet(veh),false)
                            end
                        end
                    end
                end
            end
        end
    end
end)

particle = Config.Settings.ParticleUsed

RegisterNetEvent('sound_client:PlayWithinDistance') -- credits https://github.com/Yorick20022
AddEventHandler('sound_client:PlayWithinDistance', function(coords, disMax, audoFile, audioVol)
    local entityCoords   = GetEntityCoords(PlayerPedId())
    local distance       = #(entityCoords - coords)
    local distanceRatio  = distance / disMax        -- calculate the distance ratio
    local adjustedVolume = audioVol / distanceRatio -- adjust volume based on distance ratio

    if (distance <= disMax) then
        SendNUIMessage({
            transactionType   = 'playSound',
            transactionFile   = audoFile,
            transactionVolume = adjustedVolume -- use the adjusted volume
        })
    end
end)


RegisterNetEvent("bbv-antilag:syncflames:c", function(vehicle,enabled)
    RemoveNamedPtfxAsset(particle)
    local veh = NetToVeh(vehicle)
    if veh ~= 0 then
        if enabled then
            SetVehicleBoostActive(veh, true)
         end
        RequestNamedPtfxAsset(particle)
        RequestPtfxAsset(particle)
        SetVehicleNitroEnabled(veh, enabled)
		
    end
end)

function Main:HasStep(_plate)
    local plate = _plate
    Wrapper.TriggerCallback('bbv-antilag:check', function(data)
        returnval = data
    end,plate)
    Wait(1000)
    return returnval
end

function Main:trim(string)
    if string ~= nil then 
     return string:match"^%s*(.*)":match"(.-)%s*$"
    end
end

RegisterNetEvent('bbv-baseevents:enteredVehicle:2step',function(veh,_plate)
    local plate = _plate
    Wrapper.TriggerCallback('bbv-antilag:check', function(data)
        Main.antilag = data
    end,plate)
end)

RegisterNetEvent('bbv-baseevents:leftVehicle:2step',function()
    Main.antilag = false
end)

RegisterNetEvent('bbv-antilag:noscam:install',function(_item)
    local closestVehicle,closestDistance = _GetClosestVehicle(GetEntityCoords(PlayerPedId()))
    if closestDistance < Config.Settings.InstallDist then
            installveh = closestVehicle
            mainCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
            RenderScriptCams(true, 1, 1500,  true,  true)
            processCamera(mainCam)
            Wrapper:RemoveItem(_item,1)
            Wait(1500)
            exports['bbv-interactbutton']:button('Install Anti-Lag','Anti-Lag installed','bbv-antilag:install:c',6000)
        else
            Wrapper:Notify(Lang.NoVeh,'error',2500)
        end
end)

RegisterNetEvent('bbv-antilag:install:c',function()
    local plate = Main:trim(GetVehicleNumberPlateText(installveh))
    TriggerServerEvent('bbv-antilag:install:s',plate)
    RenderScriptCams(false, 1, 1500,  false,  false)
end)

_GetClosestVehicle = function(_coords)
    local ped = PlayerPedId()
    local vehicles = GetGamePool('CVehicle')
    local closestDistance = -1
    local closestVehicle = -1
    local coords = _coords

    for i = 1, #vehicles, 1 do
        local vehicleCoords = GetEntityCoords(vehicles[i])
        local distance = #(vehicleCoords - coords)

        if closestDistance == -1 or closestDistance > distance then
            closestVehicle = vehicles[i]
            closestDistance = distance
        end
    end

    return closestVehicle,closestDistance
end

function processCamera(cam)
	local closestVehicle,closestDistance = _GetClosestVehicle(GetEntityCoords(PlayerPedId()))
	local veh = closestVehicle
	if veh ~= nil and veh ~= 0 and veh ~= 1 then
		SetVehicleDoorOpen(veh, 4, false, false)
    end


	local vehpos = GetEntityCoords(closestVehicle)
	local vehfront = GetEntityForwardVector(closestVehicle)
	local vehfrontpos = vector3(vehpos.x + (vehfront.x * 3),vehpos.y + (vehfront.y * 3) ,vehpos.z + (vehfront.z * 2) )

	local rotx, roty, rotz = table.unpack(GetEntityRotation(PlayerPedId()))
	local camX, camY, camZ = table.unpack(GetGameplayCamCoord())
	local camRX, camRY, camRZ = GetGameplayCamRelativePitch(), 0.0, GetGameplayCamRelativeHeading()
	local camF = GetGameplayCamFov()
	local camRZ = (rotz+camRZ)

	SetCamCoord(cam, vehfrontpos.x, vehfrontpos.y, vehfrontpos.z + 1.5)
	PointCamAtCoord(cam, vehpos.x,vehpos.y,vehpos.z - 1)
	-- SetCamRot(cam, camRX, camRY, camRZ)
	SetCamFov(cam, camF)
end

RegisterNetEvent('bbv-antilag:noscam:remove',function(_item)
    local closestVehicle,closestDistance = _GetClosestVehicle(GetEntityCoords(PlayerPedId()))
    if closestDistance < Config.Settings.InstallDist then 
        if Main:HasStep(Main:trim(GetVehicleNumberPlateText(closestVehicle))) then 
            Wrapper:RemoveItem(_item,1)
            TriggerServerEvent('bbv-nos:removenos',Main:trim(GetVehicleNumberPlateText(closestVehicle)))
            Wrapper:Notify(Lang.AntiLagRemoved .. Main:trim(GetVehicleNumberPlateText(closestVehicle)))
        else
            Wrapper:Notify(Lang.NoSystem,'error',2500)
        end
    else
        Wrapper:Notify(Lang.NoVeh,'error',2500)
    end
end)
