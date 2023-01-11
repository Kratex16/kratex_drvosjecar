local display = false


RegisterCommand("+drvosjecar", function(source, args)
    SetDisplay(not display)
end)

RegisterNUICallback("exit", function()
    SetDisplay(false)
end)

RegisterNUICallback("main", function(data)
    print(data.text)
    SetDisplay(false)
    TriggerEvent('alija:zapocnipreradu')
end)

RegisterNUICallback("error", function(data)
    print(data.error)
    SetDisplay(false)
end)

function SetDisplay(bool)
    display = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "ui",
        status = bool,
    })
end

Citizen.CreateThread(function()
    while display do
        Citizen.Wait(0)
        DisableControlAction(0, 1, display)
        DisableControlAction(0, 2, display)
        DisableControlAction(0, 142, display)
        DisableControlAction(0, 18, display)
        DisableControlAction(0, 322, display)
        DisableControlAction(0, 106, display)
    end
end)






if Config.KojiESX == true then
    ESX = nil
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
 else
    ESX = nil
    ESX = exports['es_extended']:getSharedObject()
 end

local daliosobacijepa = false

local Drveca = { -- Wood position to harvest, you can add more locations
    {x= -583.23, y= 5490.79, z= 55.83},
    {x = -565.52, y = 5502.44, z = 58.04},
    {x = -571.08, y = 5508.28, z = 56.2},
    {x = -575.48, y = 5526.84, z = 53.08},
    {x = -588.24, y = 5494.72, z = 54.4},
    {x = -597.2, y = 5473.08, z = 56.48},
    {x = -617.96, y = 5488.36, z = 51.6},

}



local Npc  = { -- npc location with the sell locations, add together.
   {x= 2677.19, y= 3512.92, z= 51.71, h= 67.93}, -- 2677.19, 3512.92, 52.71, 67.93
}


-- Spavn drveca
--


Citizen.CreateThread(function()
    while true do
	   local ped = PlayerPedId()
       local plyCoords = GetEntityCoords(ped)
       local BlizuMarkera = false
       for k in pairs(Drveca) do
           if daliosobacijepa == false then
              local Plycoords = vector3(plyCoords.x, plyCoords.y, plyCoords.z)
	          local Drveca_coords = vector3(Drveca[k].x, Drveca[k].y, Drveca[k].z)
              local dist = #(Plycoords - Drveca_coords)
              if dist <= 1.0 and not BlizuMarkera then
                 DrawMarker(2, Drveca[k].x, Drveca[k].y, Drveca[k].z, 0, 0, 0, 0, 0, 0, 0.4, 0.4, 0.4, 0, 155, 78, 146 ,2 ,0 ,0 ,0)
                 BlizuMarkera = true
                 if GetSelectedPedWeapon(ped) == GetHashKey("weapon_hatchet") then
                    woodcuttext(Drveca[k].x, Drveca[k].y, Drveca[k].z, tostring('Pritisnite ~o~[E]~w~ da pocijepas ovo drvo'))
                 else
                    woodcuttext(Drveca[k].x, Drveca[k].y, Drveca[k].z, tostring('Potrebna ti je sjekira'))
                 end
                 if IsControlJustPressed(0,38) and dist <= 1.1 then
                    if GetSelectedPedWeapon(ped) == GetHashKey("weapon_hatchet") then
                        CijepajDrvo()
                       daliosobacijepa = true
                    end
                 end
              end
           end
       end



       if not BlizuMarkera then
            Citizen.Wait(1000)
       end
       Citizen.Wait(0)
    end
end)




--- Ped za preradu
Citizen.CreateThread(function()
    for _,v in pairs(Config.PreradaPed) do    
     
         RequestModel(v.npcHash)
         while not HasModelLoaded(v.npcHash) do
        
           Wait(1)
         end

 
         ped =  CreatePed(4,v.npcHash, v.coords.x,v.coords.y,v.coords.z-1, 3374176, false, true)
         SetEntityHeading(ped,v.npcHeading)
         FreezeEntityPosition(ped, true)
         SetEntityInvincible(ped, true)

         SetBlockingOfNonTemporaryEvents(ped, true)
   end

end)
--- Ped Za prodaju
Citizen.CreateThread(function()
    for _,v in pairs(Config.ProdajaPed) do    
     
         RequestModel(v.npcHash)
         while not HasModelLoaded(v.npcHash) do
        
           Wait(1)
         end

 
         ped =  CreatePed(4,v.npcHash, v.coords.x,v.coords.y,v.coords.z-1, 3374176, false, true)
         SetEntityHeading(ped,v.npcHeading)
         FreezeEntityPosition(ped, true)
         SetEntityInvincible(ped, true)

         SetBlockingOfNonTemporaryEvents(ped, true)
   end

end)
-- prerada
RegisterNetEvent('alija:zapocnipreradu', function()
    local prerada= 7500
    exports.rprogress:Custom({
        Duration =  prerada,
        Label = "Preradjivanje drveta...",
        Animation = {
            scenario = "", -- https://pastebin.com/6mrYTdQv
            animationDictionary = "", -- https://alexguirre.github.io/animations-list/
        },
        DisableControls = {
            Mouse = false,
            Player = true,
            Vehicle = true
        }
    })
    Citizen.Wait(prerada)
    TriggerServerEvent ('alija:zapocnipreradu:server')
end)

RegisterNetEvent('alija:otvoripanel:prerada', function()
    ExecuteCommand('+drvosjecar')
end)

--
-- qtarget za preradu
Citizen.CreateThread(function()
exports.qtarget:AddBoxZone("PreradaDrveta", vector3(-552.685730, 5348.795410, 73.740723), 1.0, 1.0, {
	name="PreradaDrveta",
	heading=249.448822,
	debugPoly=false,
	minZ=73.74,
	maxZ=75.99
    }, {
        options = {
            {
                event = "alija:otvoripanel:prerada",
                icon = "far fa-clipboard",
                label = "Zapocni preradu",
            },

        },
        distance = 1.5
    })
end)



---
-- prodaja
 RegisterNetEvent('alija:zapocniprodaju', function()
    local prodaja = 4500
    exports.rprogress:Custom({
        Duration =  prodaja,
        Label = "Preradjivanje drveta...",
        Animation = {
            scenario = "", -- https://pastebin.com/6mrYTdQv
            animationDictionary = "", -- https://alexguirre.github.io/animations-list/
        },
        DisableControls = {
            Mouse = false,
            Player = true,
            Vehicle = true
        }
    })
    Citizen.Wait(prodaja)
    TriggerServerEvent('alija:zapocniprodaju:server')
 end)
-- qtarget za prodaju
Citizen.CreateThread(function()
    exports.qtarget:AddBoxZone("ProdajaDrveta", vector3(2676.725342, 3513.125244, 52.701050), 1.0, 1.0, {
        name="PreradaDrveta",
        heading=249.448822,
        debugPoly=false,
        minZ=52.24,
        maxZ=53.59
        }, {
            options = {
                {
                    event = "alija:zapocniprodaju",
                    icon = "far fa-clipboard",
                    label = "Zapocni prodaju",
                },
    
            },
            distance = 1.5
        })
    end)
    


-- harvest location
Citizen.CreateThread(function()
	for k,v in pairs(Drveca) do
		local harvest_blip = AddBlipForCoord(Drveca[k].x, Drveca[k].y, Drveca[k].z)

		SetBlipSprite(harvest_blip, 153)
		SetBlipScale(harvest_blip, 0.80)
        SetBlipColour(harvest_blip, 56)
		SetBlipAsShortRange(harvest_blip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString('Zona Drveca')
		EndTextCommandSetBlipName(harvest_blip)
	end


    -- Processing location
    local Processing_blip = AddBlipForCoord(-552.685730, 5348.795410, 73.740723)

	SetBlipSprite(Processing_blip, 568)
	SetBlipScale(Processing_blip, 0.80)
    SetBlipColour(Processing_blip, 10)
    SetBlipAsShortRange(Processing_blip, true)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('Prerada drveta')
	EndTextCommandSetBlipName(Processing_blip)

    -- Sell location
    local Sell_blip = AddBlipForCoord(2670.82, 3516.14, 52.71)

	SetBlipSprite(Sell_blip, 501)
	SetBlipScale(Sell_blip, 0.80)
    SetBlipColour(Sell_blip, 56)
    SetBlipAsShortRange(Sell_blip, true)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('Prodaja drveta')
	EndTextCommandSetBlipName(Sell_blip)
end)


function CijepajDrvo()
    Citizen.CreateThread(function()
        local impacts = 0
        local ped = PlayerPedId()
        local plyCoords = GetEntityCoords(ped)
        local FrontTree   = GetEntityForwardVector(ped)
        local x, y, z   = table.unpack(plyCoords + FrontTree * 1.0)
        local EffectName = 'bul_wood_splinter'
        while impacts < 4 do
            Citizen.Wait(0)
            if not HasNamedPtfxAssetLoaded("core") then
	           RequestNamedPtfxAsset("core")
	           while not HasNamedPtfxAssetLoaded("core") do
		         Citizen.Wait(0)
	           end
            end
            LoadDict('melee@hatchet@streamed_core')
            TaskPlayAnim((ped), 'melee@hatchet@streamed_core', 'plyr_front_takedown', 4.0, -8, 0.01, 0, 0, 0, 0, 0)
            FreezeEntityPosition(ped, true)
            Citizen.Wait(100)
            UseParticleFxAssetNextCall("core")
            Citizen.Wait(400)
            effect = StartParticleFxLoopedAtCoord(EffectName, x, y, z, 0.0, 0.0, 0.0, 2.0, false, false, false, false)
            Citizen.Wait(1000)
            StopParticleFxLooped(effect, 0)
            Citizen.Wait(1700)
            ClearPedTasks(ped)
            impacts = impacts+1
            print('cijepanjedrveta', impacts)
            if impacts == 4 then
               impacts = 0
               daliosobacijepa = false
               TriggerServerEvent('alija:dajitem:server')
               FreezeEntityPosition(ped, false)
               break
            end
        end
    end)
end

function LoadDict(dict)
    RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
	  	Citizen.Wait(10)
    end
end

function woodcuttext(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z- 0.1)
    local p = GetGameplayCamCoords()
    local distance = GetDistanceBetweenCoords(p.x, p.y, p.z, x, y, z, 1)
    local scale = (1 / distance) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov
    if onScreen then
        SetTextScale(0.0, 0.30)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end