local isDead = false
local inVehicle = false

ESX = exports["es_extended"]:getSharedObject()

CreateThread(function()
    while true do
        local wait = 1000
        local ped = PlayerPedId()
        local pcoords = GetEntityCoords(ped)
        for k, v in pairs(Config.Tallit) do
            if #(pcoords - v.Spawn) < 10 then
		    wait = 0
                if ESX.PlayerData.job.name == "police" and not isDead then
		        DrawMarker(1, v.Spawn.x, v.Spawn.y, v.Spawn.z - 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.5, 1.5, 0.5, 255, 255, 255, 0.05, 0, 0, 0, 0, 0, 0, 0)
                    if #(pcoords - v.Spawn) < 1.0 then
                        ESX.ShowHelpNotification("~INPUT_PICKUP~ Avaa autotalli")
                        if IsControlJustReleased(0, 38) then
                            local spawncoords = v.SpawnCoordit
                            local heading = v.Heading
                            AvaaTalli(spawncoords, heading)
                        end
                    end
                end
            end
        end
	Wait(wait)
    end
end)

CreateThread(function()
    while true do
        local wait = 1000
        local ped = PlayerPedId()
        local pcoords = GetEntityCoords(ped)
        for k, v in pairs(Config.Tallit) do
            if #(pcoords - v.Poista) < 10 and ESX.PlayerData.job.name == "police" then
                if not isDead and inVehicle then
		        wait = 0
                DrawMarker(1, v.Poista.x, v.Poista.y, v.Poista.z - 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.5, 1.5, 0.5, 255, 255, 255, 0.05, 0, 0, 0, 0, 0, 0, 0)
                    if #(pcoords - v.Poista) < 1.0 then
                        ESX.ShowHelpNotification("~INPUT_PICKUP~ Poista ajoneuvo")
                        if IsControlJustReleased(0, 38) then
                            PoistaAjoneuvo()
                        end
                    end
                end
            end
        end
	Wait(wait)
    end
end)

CreateThread(function()
    while true do
        local ped = PlayerPedId()
        isDead = IsPedDeadOrDying(ped)
        inVehicle = IsPedInAnyVehicle(ped, true)
        Wait(500)
    end
end)

function PoistaAjoneuvo()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped)
    ESX.Game.DeleteVehicle(vehicle)
end

function AvaaTalli(spawncoords, heading)
    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open("default", GetCurrentResourceName(), "autotallimenu",
        {
            title = "Poliisi talli",
            align = "top-right",
            elements = Config.Ajoneuvot
        },
        function(data, menu)
            ESX.UI.Menu.CloseAll()
            local model = data.current.value
            ESX.Game.SpawnVehicle(model, spawncoords, heading, function(vehicle)
            end)
        end,
        function(data, menu)
            menu.close()
        end,
        function(data, menu)
        end)
end
