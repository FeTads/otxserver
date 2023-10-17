dofile('data/lib/lib.lua')

function getRespawnDivider()
    local multiplier = 1
    local size = #getPlayersOnline()
    if size >= 100 and size < 199 then
        multiplier = 2
    elseif size >= 200 and size < 299 then
        multiplier = 3
    elseif size >= 300 then
        multiplier = 4
    end
    return multiplier
end


function setItemOwner(cid, item)
    doItemSetAttribute(item, 'owner', getPlayerGUID(cid))
    doItemSetAttribute(item, 'ownername', getPlayerName(cid))
end