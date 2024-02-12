local QBCore = exports['qb-core']:GetCoreObject()
local motels = {}
RegisterServerEvent('rz-motel:server:teleport')
AddEventHandler('rz-motel:server:teleport', function(id)
     local bucket = getFirstBucket()
     if bucket < Config.MaxPlayer then
         motels[source] = bucket
         SetPlayerRoutingBucket(source, motels[id])
         TriggerClientEvent('rz-motel:client:enteroom', source)
     else
         TriggerClientEvent("QBCore:Notify", source, Lang:t("notify.room_full"), "error")
     end
end)

RegisterServerEvent('rz-motel:server:exitroom')
AddEventHandler('rz-motel:server:exitroom', function(id)
    motels[SetPlayerRoutingBucket] = nil
    SetPlayerRoutingBucket(source, 0)
    TriggerClientEvent('rz-motel:client:exitroom', source)
end)

function getFirstBucket()
    local i = 1
    repeat
        local founded = false
        for k, v in pairs(motels) do
            if motels[k] == i then
                founded = true
                i=i+1
                break
            end
        end
    until not founded
    return i
end

AddEventHandler('playerDropped', function(_)
    motels[source] = nil
end)