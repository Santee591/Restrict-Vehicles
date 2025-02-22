-- Vehicle restrictions based on Discord roles
local vehicleRestrictions = {
    ["Doge"] = {
        roleID = "1304157773310988390",  -- Replace with VIP Discord Role ID
        vehicles = { "11imp", "14charg", "14tahoe" }
    },
    ["Fan"] = {
        roleID = "1304157656260284527",  -- Replace with Admin Discord Role ID
        vehicles = { "18tahoe", "18tau" }
    },
    ["test"] = {
        roleID = "333333333333333333",  -- Replace with Police Discord Role ID
        vehicles = { "police1", "police2", "police3" }
    }
}

-- Function to check if a player has a required Discord role
function hasDiscordRole(player, requiredRoleID)
    local userRoles = exports.zDiscord:getUserRoles(player)
    if userRoles then
        for _, role in pairs(userRoles) do
            if tostring(role) == requiredRoleID then
                return true
            end
        end
    end
    return false
end

-- Event listener for vehicle entry check
RegisterNetEvent("restrictVehicles:checkVehicleAccess")
AddEventHandler("restrictVehicles:checkVehicleAccess", function(vehicleName)
    local player = source
    local allowed = false

    for groupName, data in pairs(vehicleRestrictions) do
        for _, restrictedVehicle in pairs(data.vehicles) do
            if vehicleName == restrictedVehicle then
                if hasDiscordRole(player, data.roleID) then
                    allowed = true
                else
                    TriggerClientEvent("restrictVehicles:denyAccess", player, groupName)
                end
                return
            end
        end
    end
end)
