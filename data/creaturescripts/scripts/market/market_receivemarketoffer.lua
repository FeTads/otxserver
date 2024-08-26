-- Criado por Thalles Vitor --
-- Market receive buyed items from the market --

function onMarketOfferRemoveItem(cid, item_id, description, amount)
	doSendPlayerExtendedOpcode(cid, 118, getItemInfo(item_id).clientId.."@"..description.."@"..amount.."@")
	return true
end