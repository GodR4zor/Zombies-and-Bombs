local Shop = {}

--Services
local MarketPlaceService = game:GetService("MarketplaceService")
local RP = game:GetService("ReplicatedStorage")
local productsFolder = RP.Products
local goldpack = productsFolder.GoldPack1
local productId = goldpack.productId.value
local reward = goldpack.reward.value


Shop.products = {

    ["1514096869"] = {
        productId = productId,
        productName = "gold pack 1000",
        reward = reward
    }

} 

function Shop.BuyGold(player:Player)
    local product = Shop.products["1514096869"].productId
    MarketPlaceService:PromptProductPurchase(player, product)

end



return Shop