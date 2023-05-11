--Services
local SS = game:GetService("ServerStorage")
local MarketPlaceService = game:GetService("MarketplaceService")

--Events
local UpgradeRequested = SS.Network.UpgradeRequested
local RP = game:GetService("ReplicatedStorage")
local RequestPowerUpgradeRemoteEvent = RP.RequestPowerUpgrade
local RequestSpeedUpgradeRemoteEvent = RP.RequestSpeedUpgrade
local RequestBombUpgradeRemoteEvent = RP.RequestBombUpgrade

--require
local playerControler = require(SS.modules.PlayerController)
local playersData = playerControler.GetPlayer()
local Shop = require(SS.modules.Shop)

local UPGRADE_BOMB_COST = 100
local UPGRADE_COST = 10

local function cantPurchase(player)
	local data = playersData[player.UserId]
	if data.gold < UPGRADE_COST then
		Shop.BuyGold(player)
	

		return false
	end

	return true
end

local function onRequestBombUpgrade(player:Player)
	local data = playersData[player.UserId]
	if data.gold < UPGRADE_BOMB_COST then
		Shop.BuyGold(player)


		return 
	end
	
	playersData[player.UserId].gold -= UPGRADE_BOMB_COST
	playersData[player.UserId].bombs += 1
	
	
	player:SetAttribute("Bombs", playersData[player.UserId].bombs)
	
	UpgradeRequested:Fire(player)
end

local function onRequestPowerUpgrade(player:Player)
	if not cantPurchase(player) then
		return
	end
	


	playersData[player.UserId].gold -= UPGRADE_COST
	playersData[player.UserId].power += 1
	
	player:SetAttribute("Power", playersData[player.UserId].power)
	
	UpgradeRequested:Fire(player)
	
end

local function onRequestSpeedUpgrade(player:Player)
	if not cantPurchase(player) then
		return
	end
	
	
	playersData[player.UserId].gold -= UPGRADE_COST
	playersData[player.UserId].speed += 1
	
	UpgradeRequested:Fire(player)
	
	--Atualiza o Speed
	local workspace = game:GetService("Workspace")
	local character = player.Character
	if character.Parent == workspace then
		local humanoid:Humanoid = player.Character:WaitForChild("Humanoid")
		humanoid.WalkSpeed = playersData[player.UserId].speed
	end
	
end

RequestPowerUpgradeRemoteEvent.OnServerEvent:Connect(onRequestPowerUpgrade)
RequestSpeedUpgradeRemoteEvent.OnServerEvent:Connect(onRequestSpeedUpgrade)
RequestBombUpgradeRemoteEvent.OnServerEvent:Connect(onRequestBombUpgrade)
