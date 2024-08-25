-- Criado por Thalles Vitor --
-- Market send offers to you --

function onMarketViewOffersToMe(cid, item_id, item_name, description, tempo, count_row, transaction_id)
	if tempo - os.time() > 0 then
		if count_row > 1 then
			count_row = count_row-1
			doSendPlayerExtendedOpcode(cid, 220, getItemInfo(item_id).clientId.."@"..item_name.."@"..description.."@"..tempo.."@"..count_row.."@"..transaction_id.."@")
		else
			doSendPlayerExtendedOpcode(cid, 220, getItemInfo(item_id).clientId.."@"..item_name.."@"..description.."@"..tempo.."@"..count_row.."@"..transaction_id.."@")
		end
	end
	return true
end