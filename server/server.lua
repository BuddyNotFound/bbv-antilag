
RegisterNetEvent("bbv-antilag:syncflames:s", function(entity,enb)
    if type(entity) ~= "number" then return end
    TriggerClientEvent("bbv-antilag:syncflames:c", -1, entity,enb)
end)

RegisterNetEvent('sound_server:PlayWithinDistance', function(disMax, audioFile, audioVol)
    TriggerClientEvent('sound_client:PlayWithinDistance', -1, GetEntityCoords(GetPlayerPed(source)), disMax, audioFile,
        audioVol)
end)
