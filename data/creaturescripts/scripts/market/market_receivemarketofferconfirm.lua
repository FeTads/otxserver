-- Criado por Thalles Vitor --
-- Market receive market offer confirm to the player --

function onMarketMakeOffers(cid, item_id, item_name, item_seller, count_row, description, transaction_id)
	doSendPlayerExtendedOpcode(cid, 219, getItemInfo(item_id).clientId.."@"..item_name.."@"..item_seller.."@"..count_row.."@"..description.."@"..transaction_id.."@")
	return true
end