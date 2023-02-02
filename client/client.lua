local QBCore = exports['qb-core']:GetCoreObject()
local currentmotel = nil
local inroom = false
local cd = false
local showercd = 0, 0, 0
local sleepcd = 0, 0, 0

function firstLogin()
    PlayerData = QBCore.Functions.GetPlayerData()
    currentmotel = math.random(1, #Config.EnterMotelRoom)
end

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    firstLogin()
end)

RegisterCommand("newroom", function()
    if not cd then
        currentmotel = math.random(1, #Config.EnterMotelRoom)
        cd = true
        QBCore.Functions.Notify(Lang:t("notify.giveroom"), "primary")
        Citizen.Wait(30000)
        cd= false
    else
        QBCore.Functions.Notify(Lang:t("notify.cd"), "error")
    end
end)


Citizen.CreateThread(function()
    while true do
        local sleep = 1000
        local PlayerPed = PlayerPedId()
        local player = PlayerPedId()
        local playercoords = GetEntityCoords(player)
        local doordistance = GetDistanceBetweenCoords(playercoords, Config.EnterMotelRoom[currentmotel], true)
        if currentmotel ~= nil then
            if inroom then
                for _, PlayerPed in ipairs(GetActivePlayers()) do
                    if PlayerPed ~= PlayerId() and NetworkIsPlayerActive(PlayerPed) then
                        NetworkFadeInEntity(PlayerPedId(PlayerPed), true)
                    end
                end       
            end
            if not inroom then
                if doordistance <= 8.0 then
                    sleep = 5
                    --QBCore.Functions.DrawText3D(Config.EnterMotelRoom[currentmotel].x, Config.EnterMotelRoom[currentmotel].y, Config.EnterMotelRoom[currentmotel].z, "selam")
                    DrawMarker(2, Config.EnterMotelRoom[currentmotel].x, Config.EnterMotelRoom[currentmotel].y, Config.EnterMotelRoom[currentmotel].z -0.65, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.4, 0.4, 0.3, 255, 00, 0, 200, false, true, false, false, false, false, false)
                end
                exports['qb-target']:AddCircleZone('enter', vector3(Config.EnterMotelRoom[currentmotel].x, Config.EnterMotelRoom[currentmotel].y, Config.EnterMotelRoom[currentmotel].z), 1.0,{
                    name = 'enter', debugPoly = false, useZ=true}, {
                    options = {{label = Lang:t("motel.enterroom") ,icon = 'fa-solid fa-hand-holding', action = function() EnterMotelRoom() end}},
                    distance = 2.0
                })
            end  
        end
        Citizen.Wait(sleep)
    end
end)

function EnterMotelRoom()
    local PlayerPed = PlayerPedId()
    DoScreenFadeOut(500)
    Wait(600)
    FreezeEntityPosition(PlayerPed, true)
    SetEntityCoords(PlayerPed, Config.motelDoor.x, Config.motelDoor.y, Config.motelDoor.z-1.0)
    SetEntityHeading(PlayerPed, Config.motelHeading)
    Wait(1400)
    inroom = true
    DoScreenFadeIn(1000)
    repeat
        Citizen.Wait(10)
	until (IsControlJustPressed(0, 32) or IsControlJustPressed(0, 33) or IsControlJustPressed(0, 34) or IsControlJustPressed(0, 35))
    FreezeEntityPosition(PlayerPed, false)
end

function ExitMotelRoom()
    local PlayerPed = PlayerPedId()
    DoScreenFadeOut(500)
    Wait(1500)
    SetEntityCoords(PlayerPed, Config.EnterMotelRoom[currentmotel].x, Config.EnterMotelRoom[currentmotel].y, Config.EnterMotelRoom[currentmotel].z-1)
    Wait(500)
    inroom = false
    DoScreenFadeIn(1000)
end

function OpenMotelInventory()
    TriggerEvent("inventory:client:SetCurrentStash", "motel_"..PlayerData.citizenid, QBCore.Key)
    TriggerServerEvent("inventory:server:OpenInventory", "stash", "motel_"..PlayerData.citizenid)
end

function OpenMotelWardrobe()
    TriggerEvent("qb-clothing:client:openOutfitMenu")
end

Citizen.CreateThread(function()
    local MotelBlip = AddBlipForCoord(Config.motelCoord)
    SetBlipSprite(MotelBlip, 475)
    SetBlipDisplay(MotelBlip, 4)
    SetBlipScale(MotelBlip, 0.5)
    SetBlipColour(MotelBlip, 23)
    SetBlipAsShortRange(MotelBlip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Motel")
    EndTextCommandSetBlipName(MotelBlip)
end)

function Shower()
    local PlayerPed = PlayerPedId()
    if showercd == 0 or GetGameTimer() > showercd then
        QBCore.Functions.Progressbar("shower", Lang:t("motel.shower"), 18000, false, false, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {
            animDict = "misschinese2_crystalmazemcs1_cs",
            anim = "dance_loop_tao",
            flags = 49,
        }, {}, {}, function()
            if Config.Gsr then
                TriggerServerEvent('GSR:Remove')
            end
            ClearPedTasksImmediately(PlayerPed) 
            QBCore.Functions.Notify(Lang:t("notify.shower"), 'primary')
            showercd = GetGameTimer() + Config.ShowerCoolDown		
        end, function()
            shower = true
        end)
        TriggerEvent("InteractSound_CL:PlayOnOne", "shower", "0.2")
        UseParticleFxAssetNextCall("core") 
        particles = StartParticleFxLoopedAtCoord("ent_sht_water", Config.ShowerCoords.x, Config.ShowerCoords.y, Config.ShowerCoords.z +1.2, 0.0, 0.0, 0.0, 1.0, false, false, false, false) UseParticleFxAssetNextCall("core") Citizen.Wait(3000) 
        particles2 = StartParticleFxLoopedAtCoord("ent_sht_water", Config.ShowerCoords.x, Config.ShowerCoords.y, Config.ShowerCoords.z +1.2, 0.0, 0.0, 0.0, 1.0, false, false, false, false) UseParticleFxAssetNextCall("core") Citizen.Wait(3000) 
        particles3 = StartParticleFxLoopedAtCoord("ent_sht_water", Config.ShowerCoords.x, Config.ShowerCoords.y, Config.ShowerCoords.z +1.2, 0.0, 0.0, 0.0, 1.0, false, false, false, false) UseParticleFxAssetNextCall("core") Citizen.Wait(3000) 
        particles4 = StartParticleFxLoopedAtCoord("ent_sht_water", Config.ShowerCoords.x, Config.ShowerCoords.y, Config.ShowerCoords.z +1.2, 0.0, 0.0, 0.0, 1.0, false, false, false, false) UseParticleFxAssetNextCall("core") Citizen.Wait(3000) 
        particles5  = StartParticleFxLoopedAtCoord("ent_sht_water", Config.ShowerCoords.x, Config.ShowerCoords.y, Config.ShowerCoords.z +1.2, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
    else
        QBCore.Functions.Notify(Lang:t("notify.shower"), 'primary')
    end
end

function Sleep()
    local PlayerPed = PlayerPedId()
    if sleepcd == 0 or GetGameTimer() > sleepcd then
        SetEntityCoords(PlayerPed, Config.motelSleep.x, Config.motelSleep.y, Config.motelSleep.z)
        RequestAnimDict("timetable@tracy@sleep@")
        while not HasAnimDictLoaded("timetable@tracy@sleep@") do
            Citizen.Wait(0)
        end
        TaskPlayAnim(PlayerPed, "timetable@tracy@sleep@", "idle_c", 8.0, -8.0, -1, 0, 0.0, false, false, false)
        DoScreenFadeOut(5000)
        Citizen.Wait(Config.SleepTime)
        TaskPlayAnim(PlayerPed, "timetable@tracy@sleep@", "idle_c", 8.0, -8.0, -1, 0, 0.0, false, false, false)
        DoScreenFadeIn(5000)
        Citizen.Wait(5000)
        FreezeEntityPosition(PlayerPed, false)
        RequestAnimDict("switch@franklin@bed")
        while not HasAnimDictLoaded("switch@franklin@bed") do
            Citizen.Wait(0)
        end
        TaskPlayAnim(PlayerPed, "switch@franklin@bed", "sleep_getup_rubeyes", 8.0, -8.0, -1, 0, 0.0, false, false, false)
        Citizen.Wait(9000)
        if Config.SleepHealth then
            SetEntityHealth(PlayerPed, Config.Health)
        end
        TriggerServerEvent('hud:server:RelieveStress', math.random(5, 10))
        sleepcd = GetGameTimer() + Config.SleepCoolDown		
        ClearPedTasks(PlayerPed)
    else
        QBCore.Functions.Notify(Lang:t("notify.shower"), 'primary')
    end
end

exports['qb-target']:AddCircleZone('motelstash', vector3(Config.motelStash.x, Config.motelStash.y, Config.motelStash.z), 1.0,{
    name = 'motelstash', debugPoly = false, useZ=true}, {
    options = {{label = Lang:t("motel.chest") ,icon = 'fa-solid fa-hand-holding', action = function() OpenMotelInventory() end}},
    distance = 2.0
})

exports['qb-target']:AddCircleZone('exit', vector3(Config.motelDoor.x, Config.motelDoor.y, Config.motelDoor.z), 1.0,{
    name = 'exit', debugPoly = false, useZ=true}, {
    options = {{label = Lang:t("motel.exitroom") ,icon = 'fa-solid fa-hand-holding', action = function() ExitMotelRoom() end}},
    distance = 2.0
})

exports['qb-target']:AddCircleZone('clothes', vector3(Config.motelOutfits.x, Config.motelOutfits.y, Config.motelOutfits.z), 1.0,{
    name = 'clothes', debugPoly = false, useZ=true}, {
    options = {{label = Lang:t("motel.outfits") ,icon = 'fa-solid fa-hand-holding', action = function() OpenMotelWardrobe() end}},
    distance = 2.0
})

exports['qb-target']:AddCircleZone('shower', vector3(Config.motelShower.x, Config.motelShower.y, Config.motelShower.z), 1.0,{
    name = 'shower', debugPoly = false, useZ=true}, {
    options = {{label = Lang:t("motel.shower") ,icon = 'fa-solid fa-shower', action = function() Shower() end}},
    distance = 2.0
})

exports['qb-target']:AddCircleZone('sleep', vector3(Config.motelSleep.x, Config.motelSleep.y, Config.motelSleep.z), 2.0,{
    name = 'sleep', debugPoly = false, useZ=true}, {
    options = {{label = Lang:t("motel.sleep") ,icon = 'fa-solid fa-bed', action = function() Sleep() end}},
    distance = 2.0
})
