local dropBombRemoteEvent = game:GetService("ReplicatedStorage").DropBomb

local bombs = game:GetService("ServerStorage").Bombs
local bombTemplate = bombs.Bomb


local function isAlowwedDropBomb(player:Player)
	
	local maxBomb = player:GetAttribute("Bombs")
	local DropBombQuanty = #workspace.SpawnedBombs:GetChildren()
	
	print(maxBomb)
	
	if DropBombQuanty > maxBomb then
		return false
	else
		wait(0.05)
		return true
	end
end

dropBombRemoteEvent.OnServerEvent:Connect(function(player:Player)
	
	local maxBomb = isAlowwedDropBomb(player)

	if maxBomb then
			local bomb = bombTemplate:Clone()
			bomb.CFrame = player.Character.PrimaryPart.CFrame * CFrame.new(0, -1, 0)

			-- TODO: Verificar uma forma melhor de fazer a colisão acompanhar a bomba
			bomb.BombCollider.CFrame = bomb.CFrame * CFrame.new(0, -2, 0)
			bomb:SetAttribute("Owner", player.UserId)
			bomb:SetAttribute("Power", player:GetAttribute("Power"))

		bomb.Parent = workspace.SpawnedBombs
		
	else
		print("Não pode spawnr bomba!")
		end
end)	