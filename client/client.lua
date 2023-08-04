Main = {
    Enabled = true,
    player = PlayerPedId
}

RegisterCommand("antilag", function()
    if Main.Enabled then 
        Main.Enabled = false
        PlaySoundFrontend(-1, 'CONFIRM_BEEP', 'HUD_MINI_GAME_SOUNDSET', true)
    else
        PlaySoundFrontend(-1, 'CONFIRM_BEEP', 'HUD_MINI_GAME_SOUNDSET', true)
        Main.Enabled = true
    end
end, false)

local kp = 0

CreateThread(function()
    while true do
        Main.sleep = 1000
        Main.ped = Main.player()
        veh = GetVehiclePedIsIn(Main.ped, false)
        Main.Delay = math.random(25, 350)
        if GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId()), -1) == Main.ped and Main.Enabled then
            Main.sleep = 0
            local RPM = GetVehicleCurrentRpm(veh, Main.ped)
            local gear = GetVehicleCurrentGear(veh)

            for _, cars in pairs(Config.Cars) do
                local vehicleModel = GetEntityModel(veh, Main.ped)
                if GetHashKey(cars) == vehicleModel or Config.Settings.EnableAll then
                    if gear ~= kp  then
                        if not IsEntityInAir(veh) then
                            if not IsControlPressed(1, 71) and not IsControlPressed(1, 72) then
                                if RPM > Config.Settings.RPM then
                                    TriggerServerEvent("bbv-antilag:syncflames:s", VehToNet(veh),true)
                                    TriggerServerEvent("sound_server:PlayWithinDistance", 25.0,
                                        tostring(math.random(1, 6)),
                                        0.9)
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
        Wait(Main.sleep)
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
    print(veh,enabled)
    if veh ~= 0 then
        if enabled then
            SetVehicleBoostActive(veh, true)
         end
        RequestNamedPtfxAsset(particle)
        RequestPtfxAsset(particle)
        SetVehicleNitroEnabled(veh, enabled)
		
    end
end)
