--Services
local ServerStorage = game:GetService("ServerStorage")
local SoundService = game:GetService("SoundService")

--Members
local enemies:Folder = ServerStorage.Enemies
local zombies:Model = enemies:FindFirstChild("Zombie")
local spawnedEnemies = workspace.SpawnedEnemies

--Constants
local ENEMY_POPULATION = 6

--Spawna os Zombies
local function spawnZombies()
	--Duplica o Zombie
	local zombiesClone = zombies:Clone()
	
	local primaryParty = zombiesClone.PrimaryPart

	local baseposition = workspace.ZombieZone.Size
	
	--Local aleatório
	local spawnPos = Vector3.new(
		math.random(-baseposition.X/2, baseposition.X/2),
		6.50,
		math.random(-baseposition.Z/2, baseposition.Z/2)
	)
	
	--
	zombiesClone:SetPrimaryPartCFrame(CFrame.new(workspace.ZombieZone.Position) + spawnPos)
	
	--Sound
	local Sound = Instance.new("Sound")
	Sound.Name = "SoundZombie"
	Sound.SoundId = "rbxassetid://131060145"
	Sound.PlaybackSpeed = 0.8
	Sound.Volume = 0.3
	Sound.MinDistance = 20
	Sound.MaxDistance = 40
	Sound.Looped = true
	Sound.Parent = primaryParty
	
	--Move o Zombie para o Workspace
	zombiesClone.Parent = workspace.SpawnedEnemies
	
	Sound:Play()
	
	
end

--Roda de 1 até ENEMY_POPULATION que é equivalente a 3
for count=1, ENEMY_POPULATION  do
	spawnZombies()
	wait(3)
end

while true  do
	local teste = #spawnedEnemies:GetChildren()
	if teste < ENEMY_POPULATION  then
		spawnZombies()
		wait(2)
	end
	wait(2)
end