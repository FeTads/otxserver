-- Criado por Thalles Vitor --
-- Market send received historic from market to client --

function onMarketHistoric(cid, item_name, amount, date)
	doSendPlayerExtendedOpcode(cid, 117, item_name.."@"..amount.."@"..date.."@")
	return true
end