-- Criado por Thalles Vitor --
-- Market buy item and update category buy and my offers --

function onMarketBuyItemUpdateMarketWindow(cid)
	doSendPlayerExtendedOpcode(cid, 214, "destroy".."@")
	doSendPlayerExtendedOpcode(cid, 214, "destroy2".."@")
	sendMarketMyOffers(cid) -- source function
	sendMarketAllOffers(cid) -- source function
	return true
end