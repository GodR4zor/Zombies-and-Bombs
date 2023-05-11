local ProximityPromptService = game:GetService("ProximityPromptService")
local MarketPlaceService = game:GetService("MarketplaceService")

ProximityPromptService.PromptTriggered:Connect(function(promptObject, player)
	
	MarketPlaceService:PromptProductPurchase(player, 1514096869)
	
end)