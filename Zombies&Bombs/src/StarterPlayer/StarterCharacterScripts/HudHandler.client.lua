local RP = game:GetService("ReplicatedStorage")
local PlayerLoadedRemotedEvent = RP.PlayerLoaded
local RequestPowerUpgradeRemoteEvent = RP.RequestPowerUpgrade
local RequestSpeedUpgradeRemoteEvent = RP.RequestSpeedUpgrade
local RequestBombUpgradeRemoteEvent = RP.RequestBombUpgrade

local Players = game:GetService("Players")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local Hud = PlayerGui:WaitForChild("HUD")

local addPowerButton:ImageButton = Hud:WaitForChild("addPowerButton")
local addSpeedButton:ImageButton = Hud:WaitForChild("addSpeedButton")
local addBombButton:ImageButton = Hud:WaitForChild("addBombButton")

local goldTag:TextLabel = Hud:WaitForChild("Gold")
local PowerTag:TextLabel = Hud:WaitForChild("Power")
local SpeedTag:TextLabel = Hud:WaitForChild("Speed")
local BombTag:TextLabel = Hud:WaitForChild("Bombs")

PlayerLoadedRemotedEvent.OnClientEvent:Connect(function(data)
	goldTag.Text = data.gold
	PowerTag.Text = data.power
	SpeedTag.Text = data.speed
	BombTag.Text = data.bombs
end)

addPowerButton.MouseButton1Click:Connect(function()
	RequestPowerUpgradeRemoteEvent:FireServer()
end)

addSpeedButton.MouseButton1Click:Connect(function()
	RequestSpeedUpgradeRemoteEvent:FireServer()
end)

addBombButton.MouseButton1Click:Connect(function()
	RequestBombUpgradeRemoteEvent:FireServer()
	print("Solicitação de Bomba...")
end)
