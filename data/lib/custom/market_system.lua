-- Sistema de Market --
OPEN_MARKETWINDOW_OPCODE = 110 -- opcode para abrir a janela de market
OPEN_MARKETWINDOW_SENDOPTIONS_OPCODE = 116 -- opcode para enviar opcoes do market
MARKET_AVAIABLE_OPTIONS = {"All", "Armas", "Items"} -- para adicionar mais categorias voce adiciona aqui (e na source)

-- Funcao de abrir a janela de market
function onOpenMarketWindow(playerId)
	if not isPlayer(playerId) then
		--print("Player nao encontrado!")
		return false
	end

	for i = 1, #MARKET_AVAIABLE_OPTIONS do
		doSendPlayerExtendedOpcode(playerId, OPEN_MARKETWINDOW_SENDOPTIONS_OPCODE, MARKET_AVAIABLE_OPTIONS[i].."@")
	end

	doSendPlayerExtendedOpcode(playerId, OPEN_MARKETWINDOW_OPCODE, "market".."@")
	sendMarketAllOffers(playerId) -- source function
	return true
end

-- Funcao de inserir no banco de dados o produto anunciado
function sendMarketToDatabase(playerId, itemid, name, gender, level, ispokemon, count, price, integgerAttribute, onlyoffers)
	if not isPlayer(playerId) then
		--print("Player nao encontrado!")
		return false
	end

	sendMarketRemovePlayerItem(playerId, integgerAttribute, count, price, gender, level, ispokemon, name, onlyoffers) -- source function
	sendMarketMyOffers(playerId) -- source function

	doSendPlayerExtendedOpcode(playerId, 114, "destroy2".."@")
	sendMarketAllOffers(playerId) -- source function
	return true
end