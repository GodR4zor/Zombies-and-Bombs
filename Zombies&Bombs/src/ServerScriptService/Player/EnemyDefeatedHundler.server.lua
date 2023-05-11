--Services
local SS = game:GetService("ServerStorage")
local Players = game:GetService("Players")
local playerControler = require(SS.modules.PlayerController)

--Events
local EnemyDefeated:BindableEvent = SS.Network.EnemyDefeated
local PlayerGoldUpdate:BindableEvent = SS.Network.PlayerGoldUpdate
local playersData = playerControler.GetPlayer()

--Constants:
local GOLD_EARN_BY_ENEMY_DEFEATED = 10


local function onEnemyDefeated(playerId : number)
	local player = Players:GetPlayerByUserId(playerId)

	playersData[player.UserId].gold += GOLD_EARN_BY_ENEMY_DEFEATED
	
	--Atualiza UI
	PlayerGoldUpdate:Fire(player)
	
end

--Listeners
EnemyDefeated.Event:Connect(onEnemyDefeated)