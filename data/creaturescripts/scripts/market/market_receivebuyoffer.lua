-- Criado por Thalles Vitor --
-- Market buy item and update category buy and my offers --

function onMarketBuyItemUpdateMarketWindow(cid)
	doSendPlayerExtendedOpcode(cid, 114, "destroy".."@")
	doSendPlayerExtendedOpcode(cid, 114, "destroy2".."@")
	sendMarketMyOffers(cid) -- source function
	sendMarketAllOffers(cid) -- source function
	return true
end