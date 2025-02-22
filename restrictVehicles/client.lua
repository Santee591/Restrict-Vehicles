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

    -- Force player out of the vehicle
    TaskLeaveVehicle(playerPed, vehicle, 0)
    
    -- Display denial message
    TriggerEvent("chat:addMessage", {
        args = { "[Server]", "You do not have permission to drive this " .. groupName .. " vehicle!" },
        color = { 255, 0, 0 }
    })
end)
