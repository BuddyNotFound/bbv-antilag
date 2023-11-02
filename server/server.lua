
RegisterNetEvent("bbv-antilag:syncflames:s", function(entity,enb)
    if type(entity) ~= "number" then return end
    TriggerClientEvent("bbv-antilag:syncflames:c", -1, entity,enb)
end)

RegisterNetEvent('sound_server:PlayWithinDistance', function(disMax, audioFile, audioVol) -- credit https://github.com/Yorick20022
    TriggerClientEvent('sound_client:PlayWithinDistance', -1, GetEntityCoords(GetPlayerPed(source)), disMax, audioFile,
        audioVol)
end)

Wrapper.CreateCallback('bbv-antilag:check', function(source, cb,_plate)
    local src = source

    local plate = _plate
    local antilag = MySQL.scalar.await('SELECT `antilag` FROM `bbv_antilag` WHERE `plate` = ? LIMIT 1', {
        plate
    })
    if antilag == 1 then 
        cb(true)
    else
        cb(false)
    end
end)

RegisterNetEvent('bbv-antilag:install:s',function(_plate)
    local src = source
    local plate = _plate
    local license = Wrapper:Identifiers(src)
    local antilag = MySQL.insert.await('INSERT INTO `bbv_antilag` (plate, antilag, installer) VALUES (?, ?, ?)', {
        plate, 1, license.license
    })
end)

RegisterNetEvent('bbv-nos:removenos',function(_plate)
    local src = souce
    local plate = _plate

    local response = MySQL.query.await('DELETE FROM `bbv_antilag` WHERE `plate` = ?', {
        plate
    })
end)
