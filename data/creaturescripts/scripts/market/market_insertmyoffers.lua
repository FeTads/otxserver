-- Criado por Thalles Vitor --
-- Market send items to category seller (principal) --

function onMarketInsertMyOffers(cid, item_id, item_name, item_time, amount, price, gender, level, ispokemon, attributes, description, row_count, row_count_id, type, transaction_id, onlyoffers)
	if type == "open" then
		doSendPlayerExtendedOpcode(cid, 112, getItemInfo(item_id).clientId.."@"..item_name.."@"..item_time.."@"..amount.."@"..string.format("%1.0f", price).."@"..gender.."@"..level.."@"..ispokemon.."@"..description.."@"..row_count.."@"..row_count_id.."@"..transaction_id.."@")
	end

	if type == "update" then
		doSendPlayerExtendedOpcode(cid, 113, getItemInfo(item_id).clientId.."@"..item_name.."@"..item_time.."@"..amount.."@"..string.format("%1.0f", price).."@"..gender.."@"..level.."@"..ispokemon.."@"..description.."@"..row_count.."@"..row_count_id.."@"..transaction_id.."@")
	end
	return true
end