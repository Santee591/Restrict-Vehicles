local ccChat = exports['cc-chat']

-- Detect when a player enters a vehicle
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)  -- Prevents performance issues

        local playerPed = PlayerPedId()
        if IsPedInAnyVehicle(playerPed, false) then
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            local vehicleModel = GetEntityModel(vehicle)
            local vehicleName = GetDisplayNameFromVehicleModel(vehicleModel):lower()

            -- Notify server to check access
            TriggerServerEvent("restrictVehicles:checkVehicleAccess", vehicleName)
        end
    end
end)

-- Client-side event to deny vehicle access
RegisterNetEvent("restrictVehicles:denyAccess")
AddEventHandler("restrictVehicles:denyAccess", function(groupName)
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    timestamp = ccChat:getTimestamp()
    subtitle = "~r~SERVER"
    color = FF0000
    icon = "fa-duotone fa-solid fa-circle-xmark"

    if vehicle and vehicle ~= 0 then
        -- Delete the vehicle
        NetworkRequestControlOfEntity(vehicle) -- Request control (useful for networked vehicles)
        Citizen.Wait(500) -- Small delay to allow control transfer
        SetEntityAsMissionEntity(vehicle, true, true)
        DeleteVehicle(vehicle)

        -- Sends Message to client
        TriggerEvent('chat:addMessage', { templateId = 'ccChat', multiline = false, args = { color, icon, subtitle, timestamp, {"You do not have permission to drive this " .. groupName .. " vehicle! The vehicle has been removed."} } })
    end
end)
