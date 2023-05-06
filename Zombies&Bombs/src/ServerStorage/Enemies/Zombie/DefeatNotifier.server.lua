 -- Members
local Zombie = script.Parent
local humanoid:Humanoid = Zombie.Humanoid

local EnemyDefeatedBindableEvent = game:GetService("ServerStorage").Network.EnemyDefeated

--Faz a limpeza das conexões
local connection:RBXScriptConnection


connection = humanoid.Died:Connect(function()
	-- TODO: Notificar o servidor que um inimigo foi derrotado
	local playerID = humanoid:GetAttribute("LastDamageBy")
	
	--Destroi o som
	local HumanoidRotenPart = Zombie:WaitForChild("HumanoidRootPart")
	
	HumanoidRotenPart:WaitForChild("SoundZombie"):Destroy()
	
	EnemyDefeatedBindableEvent:Fire(playerID)
	--Disconecta o Connect
	connection:Disconnect()
end)


