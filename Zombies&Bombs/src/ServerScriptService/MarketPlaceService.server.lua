local Players = game:GetService("Players")
local MarketPlaceService = game:GetService("MarketplaceService")
local SS = game:GetService("ServerStorage")

--Require
local playerControler = require(SS.modules.PlayerController)
local playersData = playerControler:GetPlayer()

local productPurchase:BindableEvent = SS.Network.ProductPurchase

local Shop = require(SS.modules.Shop)

MarketPlaceService.ProcessReceipt = function(receiptInfo)
	local player = Players:GetPlayerByUserId(receiptInfo.PlayerId)
	
	local product = Shop.products[tostring(receiptInfo.ProductId)]
	if product then
		playersData[player.UserId].gold += product.reward 
		
        productPurchase:Fire(player)
	end
end