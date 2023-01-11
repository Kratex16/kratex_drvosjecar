if Config.KojiESX == true then
   ESX = nil
   TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
else
   ESX = nil
   ESX = exports['es_extended']:getSharedObject()
end


RegisterNetEvent('alija:dajitem:server', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(source)
   xPlayer.addInventoryItem('wood',1)
end)


RegisterServerEvent('alija:zapocnipreradu:server')
AddEventHandler('alija:zapocnipreradu:server', function()
   local xPlayer = ESX.GetPlayerFromId(source)
	local KolicinaDrveta = xPlayer.getInventoryItem('wood').count
   local DobijanjeDrveta = KolicinaDrveta / 5
   if KolicinaDrveta >= 5 then
      xPlayer.removeInventoryItem('wood', KolicinaDrveta)
      xPlayer.addInventoryItem('processed_wood', DobijanjeDrveta)
   else
      print('Nemate dovoljno drveta')
   end
end)



RegisterServerEvent('alija:zapocniprodaju:server')
AddEventHandler('alija:zapocniprodaju:server', function()
   local xPlayer = ESX.GetPlayerFromId(source)
	local KolicinaPreradjenog = xPlayer.getInventoryItem('processed_wood').count
   local DobijanjeNovca =  KolicinaPreradjenog*2000
   if  KolicinaPreradjenog >= 5 then
      xPlayer.removeInventoryItem('processed_wood', KolicinaPreradjenog)
      xPlayer.addMoney(DobijanjeNovca)
   else
      print('nemate dovoljno preradjenog drveta')
   end
end)