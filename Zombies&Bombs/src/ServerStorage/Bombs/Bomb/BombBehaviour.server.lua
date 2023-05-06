--Constants
local BOMB_TIME = 1.5

--Members
local bomb = script.Parent
local Owner = bomb:GetAttribute("Owner")
local power = bomb:GetAttribute("Power")

--Bomb behaviour
delay(BOMB_TIME, function()
	local explosion = Instance.new("Explosion")
	explosion.BlastRadius = 10
	explosion.BlastPressure = 0
	explosion.DestroyJointRadiusPercent = 0
	explosion.Position = bomb.Position
	
	local BombSound = Instance.new("Sound", game:GetService("Workspace"))
	local SoundsIds = {"rbxassetid://5801257793", "rbxassetid://157878578",}
	BombSound.SoundId = SoundsIds[math.random(1, #SoundsIds)]
	BombSound.Volume = 0.07
	
	
	BombSound:Play()
	
	--Acessa a Part "BombCollider"
	local collider = bomb.BombCollider
	collider.Touched:Connect(function(hit)
	end) 
	--Retorna todos os objetos que estão encostando na Part
	local parts = collider:GetTouchingParts()
	
	--Dicionário
	local humanoids = {}
	
	--Percorre os objetos de "parts"
	for _, part in parts do
		local success, message = pcall(function()
			local character = part.Parent
			if character then
				local humanoid = character:FindFirstChild("Humanoid")
				if humanoid then
					--Caso humanoid não esteja no dicionário "humanoids" ele irá incluir e aplicará um dano
					if not humanoids[humanoid] then
						humanoids[humanoid] = true
						humanoid.Health -= power
						
						humanoid:SetAttribute("LastDamageBy", Owner)
					end
				end
			end
		end)
		if not success then
			warn(message)
		end
	end
	
	explosion.Parent = workspace

	bomb:Destroy()
	delay(3, function()
		BombSound:Destroy()
	end)
end)