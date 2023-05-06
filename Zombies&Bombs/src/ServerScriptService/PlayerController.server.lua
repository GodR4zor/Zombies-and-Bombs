--Services
local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local database = DataStoreService:GetDataStore("Points")
local MarketPlaceService = game:GetService("MarketplaceService")
local ProxityPromptService = game:GetService("ProximityPromptService")

--Members
local EnemyDefeatedBindableEvent = game:GetService("ServerStorage").Network.EnemyDefeated
local playersData = {}
local RP = game:GetService("ReplicatedStorage")
local PlayerLoadedRemotedEvent = RP.PlayerLoaded
local RequestPowerUpgradeRemoteEvent = RP.RequestPowerUpgrade
local RequestSpeedUpgradeRemoteEvent = RP.RequestSpeedUpgrade
local RequestBombUpgradeRemoteEvent = RP.RequestBombUpgrade

--Constants:
local UPGRADE_BOMB_COST = 100
local UPGRADE_COST = 10
local GOLD_EARN_BY_ENEMY_DEFEATED = 10
local PLAYER_DEFAULT_DATA = {
	gold = 0;
	speed = 16;
	power = 25;
	bombs = 1
}

local function onRequestBombUpgrade(player:Player)
	
	local data = playersData[player.UserId]
	if data.gold < UPGRADE_BOMB_COST then
		MarketPlaceService:PromptProductPurchase(player, 1514096869)
		print("Not enough gold")
		return
	end
	
	playersData[player.UserId].gold -= UPGRADE_BOMB_COST
	playersData[player.UserId].bombs += 1
	
	print(data)
	
	player:SetAttribute("Bombs", data.bombs)
	
	--Fire player loaded
	PlayerLoadedRemotedEvent:FireClient(player, playersData[player.UserId])
end

local function onRequestPowerUpgrade(player:Player)
	print(player, "Power Upgrade")
	local data = playersData[player.UserId]
	if data.gold < UPGRADE_COST then
		MarketPlaceService:PromptProductPurchase(player, 1514096869)
		print("Not enough gold")
		return
	end
	
	playersData[player.UserId].gold -= UPGRADE_COST
	playersData[player.UserId].power += 1
	
	player:SetAttribute("Power", data.power)
	
	--Fire player Loaded
	PlayerLoadedRemotedEvent:FireClient(player, playersData[player.UserId])
	
end

local function onRequestSpeedUpgrade(player:Player)
	print(player, "Speed Upgrade")
	local data = playersData[player.UserId]
	if data.gold < UPGRADE_COST then
		MarketPlaceService:PromptProductPurchase(player, 1514096869)
		print("Not enough gold")
		return
	end
	
	
	playersData[player.UserId].gold -= UPGRADE_COST
	playersData[player.UserId].speed += 1
	
	--Fire player Loeaded
	PlayerLoadedRemotedEvent:FireClient(player, playersData[player.UserId])
	
	--Atualiza o Speed
	local workspace = game:GetService("Workspace")
	local character = player.Character
	if character.Parent == workspace then
		local humanoid:Humanoid = player.Character:WaitForChild("Humanoid")
		humanoid.WalkSpeed = data.speed
	end
	
end

local function onPlayerAdded(player:Player)

	local data = database:GetAsync(player.UserId)
	if not data then
		data = PLAYER_DEFAULT_DATA
	end
	
	playersData[player.UserId] = data
	
	print(playersData[player.UserId])

	--Attributes
	player:SetAttribute("Power", playersData[player.UserId].power)
	player:SetAttribute("Bombs", playersData[player.UserId].bombs)
	
	local maxBomb = player:GetAttribute("Bombs")
	
	print(player:GetAttribute("Bombs"))
	
	PlayerLoadedRemotedEvent:FireClient(player,playersData[player.UserId])
	
	player.CharacterAdded:Connect(function(character)

		while not player.Character do wait(1) end

		local character = player.Character
		if character then
			delay(1, function()
				local humanoid:Humanoid = player.Character:WaitForChild("Humanoid")
				humanoid.WalkSpeed = playersData[player.UserId].speed
				
			end)
		end
		
		delay(2, function()
			PlayerLoadedRemotedEvent:FireClient(player,playersData[player.UserId])
		end)
		
	end)
	
end

local function onPlayerRemoving(player:Player)
	print("Salvando...")
	print(playersData[player.UserId])
	database:SetAsync(player.UserId, playersData[player.UserId])
	playersData[player.UserId] = nil
end

local function onEnemyDefeated(playerID : number)
	local player = Players:GetPlayerByUserId(playerID)
	playersData[player.UserId].gold += GOLD_EARN_BY_ENEMY_DEFEATED
	print(playersData[player.UserId])

	print("Inimigo derrotado por", player)
	
	
	
	--Fire player Loaded
	PlayerLoadedRemotedEvent:FireClient(player, playersData[player.UserId])
end

--Listeners
EnemyDefeatedBindableEvent.Event:Connect(onEnemyDefeated)
RequestPowerUpgradeRemoteEvent.OnServerEvent:Connect(onRequestPowerUpgrade)
RequestSpeedUpgradeRemoteEvent.OnServerEvent:Connect(onRequestSpeedUpgrade)
RequestBombUpgradeRemoteEvent.OnServerEvent:Connect(onRequestBombUpgrade)


Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)

MarketPlaceService.ProcessReceipt = function(receiptInfo)
	local player = Players:GetPlayerByUserId(receiptInfo.PlayerId)
	
	if receiptInfo.ProductId == 1514096869 then 
		playersData[player.UserId].gold += 1000 
		
		PlayerLoadedRemotedEvent:FireClient(player, playersData[player.UserId])
	end
	
end

ProxityPromptService.PromptTriggered:Connect(function(promptObject, player)
	
	MarketPlaceService:PromptProductPurchase(player, 1514096869)
	
end)