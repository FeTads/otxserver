-- Esse script permite que apenas GM+ E pessoas invitadas na house possam mover 
-- e jogar coisas pra dentro da house, pessoas não invitadas não conseguem mover os items da house
-- mesmo que entrem nela

function onMoveItem(moveItem, frompos, position, cid)
	if getPlayerAccess(cid) > 3 then
		return true
	end
    local house = getHouseFromPos(frompos) or getHouseFromPos(position) --correção 100%
    if type(house) == "number" then
        local owner = getHouseOwner(house)  
        if owner == 0 then
            return false, doPlayerSendCancel(cid, "Sorry, not possible.")
        end
        if owner ~= getPlayerGUID(cid) then
            local sub = getHouseAccessList(house, 0x101):explode("\n")
            local guest = getHouseAccessList(house, 0x100):explode("\n")
            local isInvited = false
            if (#sub > 0) and isInArray(sub, getCreatureName(cid)) then
                isInvited = true
            end
            if (#guest > 0) and isInArray(guest, getCreatureName(cid)) then
                isInvited = true
            end    
            if not isInvited then
                return false, doPlayerSendCancel(cid, "Sorry, not possible.")
            end
        end
    end
    return true
end