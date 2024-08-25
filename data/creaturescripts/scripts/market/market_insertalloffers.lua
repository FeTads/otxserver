-- Criado por Thalles Vitor --
-- Market send items to category seller (principal) --

function onMarketInsertAllOffers(cid, item_id, item_name, item_seller, amount, price, gender, level, ispokemon, attributes, description, row_count, row_count_id, item_time, transaction_id, onlyoffers, page_numeration)
	if item_time - os.time() > 0 then
		doSendPlayerExtendedOpcode(cid, 215, getItemInfo(item_id).clientId.."@"..item_name.."@"..item_seller.."@"..amount.."@"..string.format("%1.0f", price).."@"..gender.."@"..level.."@"..ispokemon.."@"..description.."@"..row_count.."@"..row_count_id.."@"..transaction_id.."@"..onlyoffers.."@"..page_numeration.."@")
	else
		row_count = row_count-1
		doSendPlayerExtendedOpcode(cid, 215, getItemInfo(item_id).clientId.."@"..item_name.."@"..item_seller.."@"..amount.."@"..string.format("%1.0f", price).."@"..gender.."@"..level.."@"..ispokemon.."@"..description.."@"..row_count.."@"..row_count_id.."@"..transaction_id.."@"..onlyoffers.."@"..page_numeration.."@")
	end	
	return true
end