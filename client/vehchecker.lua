local isInVehicle = false
local isEnteringVehicle = false
local currentVehicle = 0
local currentSeat = 0

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		local ped = PlayerPedId()

		if not isInVehicle and not IsPlayerDead(PlayerId()) then
			if DoesEntityExist(GetVehiclePedIsTryingToEnter(ped)) and not isEnteringVehicle then
				-- -- trying to enter a vehicle!
				-- local vehicle = GetVehiclePedIsTryingToEnter(ped)
				-- local seat = GetSeatPedIsTryingToEnter(ped)
				-- local netId = VehToNet(vehicle)
				-- isEnteringVehicle = true
				-- if seat == -1 then 
				-- 	--print('driver enter')
				-- 	TriggerServerEvent('bbv-baseevents:enteringVehicle', vehicle, seat, GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)), netId)
				-- end
			elseif not DoesEntityExist(GetVehiclePedIsTryingToEnter(ped)) and not IsPedInAnyVehicle(ped, true) and isEnteringVehicle then
				-- -- vehicle entering aborted
				-- TriggerServerEvent('bbv-baseevents:enteringAborted')
				-- isEnteringVehicle = false
			elseif IsPedInAnyVehicle(ped, false) then
				-- suddenly appeared in a vehicle, possible teleport
				isEnteringVehicle = false
				isInVehicle = true
				currentVehicle = GetVehiclePedIsUsing(ped)
				currentSeat = GetPedVehicleSeat(ped)
				local model = GetEntityModel(currentVehicle)
				local name = GetDisplayNameFromVehicleModel()
				local netId = VehToNet(currentVehicle)
					-- if Main:HasNos(trim(GetVehicleNumberPlateText(currentVehicle))) then 
					-- print(trim(GetVehicleNumberPlateText(currentVehicle)))
					TriggerEvent('bbv-baseevents:enteredVehicle:2step', currentVehicle,trim(GetVehicleNumberPlateText(currentVehicle)))
				-- end
			end
		elseif isInVehicle then
			if not IsPedInAnyVehicle(ped, false) or IsPlayerDead(PlayerId()) then
				-- bye, vehicle
				local model = GetEntityModel(currentVehicle)
				local name = GetDisplayNameFromVehicleModel()
				local netId = VehToNet(currentVehicle)
				if currentSeat == -1 then 
					-- --print('left driver')
					-- if Main:HasNos(trim(GetVehicleNumberPlateText(currentVehicle))) then 
					TriggerEvent('bbv-baseevents:leftVehicle:2step')
					-- end
				end
				isInVehicle = false
				currentVehicle = 0
				currentSeat = 0
			end
		end
		Citizen.Wait(50)
	end
end)

function GetPedVehicleSeat(ped)
    local vehicle = GetVehiclePedIsIn(ped, false)
    for i=-2,GetVehicleMaxNumberOfPassengers(vehicle) do
        if(GetPedInVehicleSeat(vehicle, i) == ped) then return i end
    end
    return -2
end

function trim(string)
    if string ~= nil then 
     return string:match"^%s*(.*)":match"(.-)%s*$"
    end
end