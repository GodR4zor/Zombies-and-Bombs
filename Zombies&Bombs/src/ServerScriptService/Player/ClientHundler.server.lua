--region Services
local RP = game:GetService("ReplicatedStorage")
local PlayerLoadedRemotedEvent = RP.PlayerLoaded
local SS = game:GetService("ServerStorage")
local UpgradeRequested = SS.Network.UpgradeRequested
local PlayerGoldUpdate:BindableEvent = SS.Network.PlayerGoldUpdate
--endregion

--Events
local ProductPurchased = SS.Network.ProductPurchase

--Require
local playerControler = require(SS.modules.PlayerController)
local playersData = playerControler.GetPlayer()


local function onUpdatePlayerUI(player)
    PlayerLoadedRemotedEvent:FireClient(player, playersData[player.UserId])
end

--ALL EVENTS UPDATE UI
ProductPurchased.Event:Connect(onUpdatePlayerUI)
UpgradeRequested.Event:Connect(onUpdatePlayerUI)
PlayerGoldUpdate.Event:Connect(onUpdatePlayerUI)

