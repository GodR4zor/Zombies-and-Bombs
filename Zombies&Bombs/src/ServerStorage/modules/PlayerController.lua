local PlayerController = {}

--region Services
local Players:Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local RP = game:GetService("ReplicatedStorage")
--endregion

--region MEMBERS
local database = DataStoreService:GetDataStore("Points")
local PlayerLoadedRemotedEvent:RemoteEvent = RP.PlayerLoaded
--endregion

--region CONSTANTS

local PLAYER_DEFAULT_DATA = {
	gold = 0;
	speed = 16;
	power = 25;
	bombs = 1
}

--endregion


local playersData = {}

local function onPlayerAdded(player:Player)

	local data = database:GetAsync(player.UserId)
	if not data then
		data = PLAYER_DEFAULT_DATA
	end
	
	playersData[player.UserId] = data
	

	--Attributes
	player:SetAttribute("Power", playersData[player.UserId].power)
	player:SetAttribute("Bombs", playersData[player.UserId].bombs)
	
	local maxBomb = player:GetAttribute("Bombs")
	
	
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
	playersData[player.UserId].gold = 0
	database:SetAsync(player.UserId, playersData[player.UserId])
	playersData[player.UserId] = nil
end

function PlayerController.GetPlayer()
	return playersData
end


--region LISTENERS

Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)

--endregion

return PlayerController