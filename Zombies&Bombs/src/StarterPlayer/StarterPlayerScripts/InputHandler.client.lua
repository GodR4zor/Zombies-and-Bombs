--Escuta os botões do jogador
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")

--Services
local dropBombRemoteEvent = game:GetService("ReplicatedStorage").DropBomb
local SeatButton = game:GetService("ReplicatedStorage").SeatButton

--Constant
local ACTION_KEY = Enum.KeyCode.F
local ACTION_KEY_SEAT = Enum.KeyCode.P
local GAMEPAD_ACTION_KEY = Enum.KeyCode.ButtonR1
local CONTEXT = "BombDrop"
local maxBomb = 0

local function seatEvent()
	SeatButton:FireServer()
end

local function isDropBombAllowed(player: Player)
	local maxBomb = player:GetAttribute("Bombs")
	local DropBombQuanty = #workspace.SpawnedBombs:GetChildren()		
	if DropBombQuanty >= maxBomb then
		return false
	else
		return true
	end
end

local function dropBomb(player: Player)
	local maxBomb = isDropBombAllowed(player)
	if not maxBomb then
		return
	end
	dropBombRemoteEvent:FireServer()
end

local function handleDropBombImput(actioName, InputState, InputObject)
	
	if InputState == Enum.UserInputState.Begin then
		local player = game.Players.LocalPlayer
		dropBomb(player)
	end
	
end

ContextActionService:BindAction(CONTEXT, handleDropBombImput, true, ACTION_KEY, GAMEPAD_ACTION_KEY)
ContextActionService:SetPosition(CONTEXT, UDim2.new(1, -70, 0, 10))
ContextActionService:SetTitle(CONTEXT,"Bomb!")
