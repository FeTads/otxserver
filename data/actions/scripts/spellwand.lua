local itemList = {
	[2498] = {sell = 70000}, 	-- royal helmet
    [2520] = {sell = 50000}, 	-- demon shield
    [2514] = {sell = 150000}, 	-- mastermind shield
    [2414] = {sell = 6000},  	-- dragon lance
    [2492] = {sell = 20000}, 	-- dragon scale mail	
    [2470] = {sell = 80000}, 	-- golden legs
    [2472] = {sell = 200000}, 	-- magic plate armor
    [2195] = {sell = 20000}, 	-- boots of haste
    [2393] = {sell = 20000}, 	-- giant sword
    [2656] = {sell = 20000}, 	-- blue robe
    [2491] = {sell = 7000},  	-- crown helmet
    [2487] = {sell = 12000}, 	-- crown armor
    [2488] = {sell = 13000}, 	-- crown legs
    [2432] = {sell = 20000}, 	-- fire axe
    [2466] = {sell = 35000}, 	-- golden armor
    [2392] = {sell = 10000}, 	-- fire sword
    [2536] = {sell = 10000}, 	-- medusa shield
    [2391] = {sell = 10000}, 	-- war hammer
    [2476] = {sell = 10000}, 	-- knight armor
    [2477] = {sell = 10000}, 	-- knight legs
    [2528] = {sell = 10000},  	-- tower shield
	[7418] = {sell = 10000}  	-- nightmare blade
}	

function onUse(cid, item, fromPosition, itemEx, toPosition)
	if (isCreature(itemEx.uid) or (itemEx.itemid == 0)) then
		doPlayerSendCancel(cid, "Desculpe, você só pode usar em itens.")
		return true
	end

	local b = itemList[itemEx.itemid]
	if b then
		local itemEx_id = itemEx.itemid
		local amount = getPlayerItemCount(cid, itemEx_id)
		if amount <= 0 then
			doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_ORANGE, "Não foi possível vender esse item, verifique se o item está dentro de sua backpack.")
			return true
		end
		local balance = getPlayerBalance(cid)
		for a=1, amount do
			if (doPlayerRemoveItem(cid, itemEx_id, 1, -1, true)) then
				amount = a
			else
				if (amount == a) then
					doPlayerSendCancel(cid, "Você não pode vender itens que estão equipados.")
					return true
				end
			end
		end

		local total = (amount * b.sell)
		if isPremium(cid) then
			percent = total * 10 / 100
			total = total + percent
			doPlayerSetBalance(cid, balance + total)
		else
			doPlayerSetBalance(cid, balance + total)
		end

		doPlayerSendTextMessage(cid, MESSAGE_EVENT_DEFAULT, "Você vendeu "..amount.."x "..(amount < 2 and getItemNameById(itemEx_id) or getItemPluralNameById(itemEx_id)).." por "..doNumberFormat(total).." golds.\nSeu balance agora é de "..doNumberFormat(getPlayerBalance(cid)).." golds.")
	else
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_RED, "Desculpe, não é possivel vender "..getItemNameById(itemEx.itemid)..".")
		return true
	end
	return true
end