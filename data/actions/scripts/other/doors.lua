 local function checkStackpos(item, position)
position.stackpos = STACKPOS_TOP_MOVEABLE_ITEM_OR_CREATURE
local thing = getThingfromPos(position)
position.stackpos = STACKPOS_TOP_FIELD
local field = getThingfromPos(position)
if(item.uid ~= thing.uid and thing.itemid >= 100 or field.itemid ~= 0) then
														 
			 
	

								  
				
																   
			 
	

									  
							
						  
							  
																					
			   
	  

								   
			   
	 

							   
																 
									   
																					
return FALSE
end

								   
return TRUE
end

function onUse(cid, item, fromPosition, itemEx, toPosition)
local nuevas = {
{closed=10269, open=10270},
{closed=10272, open=10273},
{closed=10274, open=10275},
{closed=10276, open=10277},
{closed=10278, open=10279},
{closed=10280, open=10281},
{closed=10282, open=10283},
{closed=10284, open=10285},
{closed=10469, open=10470},
{closed=10471, open=10472},
{closed=10473, open=10474},
{closed=10475, open=10476},
{closed=10478, open=10479},
{closed=10480, open=10481},
{closed=10482, open=10483},
{closed=10484, open=10485},
{closed=10488, open=10490},
{closed=10489, open=10491},
{closed=12973, open=12977},
{closed=12974, open=12977},
{closed=12975, open=12978},
{closed=12976, open=12978},

{closed=1634, open=1635},
{closed=1636, open=1637},
{closed=1638, open=1639},
{closed=1640, open=1641},
}
for ia = 1,#nuevas do
if (item.itemid == nuevas[ia].closed) then
doTransformItem(item.uid, nuevas[ia].open)
elseif (item.itemid == nuevas[ia].open) then
doTransformItem(item.uid, nuevas[ia].closed)
end
end

if(getItemLevelDoor(item.itemid) > 0) then
if(item.actionid > 0 and getPlayerLevel(cid) >= (item.actionid - getItemLevelDoor(item.itemid))) then
doTransformItem(item.uid, item.itemid + 1)
doTeleportThing(cid, toPosition, TRUE)
else
doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Only the worthy may pass.")
			   
end

								   
return TRUE
end

if(isInArray(specialDoors, item.itemid) == TRUE) then
if(item.actionid ~= 0 and getPlayerStorageValue(cid, item.actionid) ~= -1) then
doTransformItem(item.uid, item.itemid + 1)
doTeleportThing(cid, toPosition, TRUE)
else
doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "The door seems to be sealed against unwanted intruders.")
			   
end

								   
return TRUE
end

if(isInArray(keys, item.itemid) == TRUE) then
if(itemEx.actionid > 0) then
if(item.actionid == itemEx.actionid) then
if doors[itemEx.itemid] ~= nil then
doTransformItem(itemEx.uid, doors[itemEx.itemid])
return TRUE
end
end

doPlayerSendCancel(cid, "The key does not match.")
return TRUE
end

						  
																									
								   
return FALSE
end

if(isInArray(horizontalOpenDoors, item.itemid) == TRUE and checkStackpos(item, fromPosition) == TRUE) then
local newPosition = toPosition
newPosition.y = newPosition.y + 1
local doorPosition = fromPosition
doorPosition.stackpos = STACKPOS_TOP_MOVEABLE_ITEM_OR_CREATURE
local doorCreature = getThingfromPos(doorPosition)
if(doorCreature.itemid ~= 0) then
if(getTilePzInfo(doorPosition) == TRUE and getTilePzInfo(newPosition) == FALSE and doorCreature.uid ~= cid) then
doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
else
doTeleportThing(doorCreature.uid, newPosition, TRUE)
if(isInArray(closingDoors, item.itemid) ~= TRUE) then
doTransformItem(item.uid, item.itemid - 1)
end
end

return TRUE
end
							 

doTransformItem(item.uid, item.itemid - 1)
return TRUE
							  
							  
											
end

if(isInArray(verticalOpenDoors, item.itemid) == TRUE and checkStackpos(item, fromPosition) == TRUE) then
local newPosition = toPosition
newPosition.x = newPosition.x + 1
local doorPosition = fromPosition
doorPosition.stackpos = STACKPOS_TOP_MOVEABLE_ITEM_OR_CREATURE
local doorCreature = getThingfromPos(doorPosition)
if(doorCreature.itemid ~= 0) then
if(getTilePzInfo(doorPosition) == TRUE and getTilePzInfo(newPosition) == FALSE and doorCreature.uid ~= cid) then
doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
else
doTeleportThing(doorCreature.uid, newPosition, TRUE)
if(isInArray(closingDoors, item.itemid) ~= TRUE) then
doTransformItem(item.uid, item.itemid - 1)
end
end

return TRUE
				
												 
						  
		 
end

doTransformItem(item.uid, item.itemid - 1)
return TRUE
	 
end

if(doors[item.itemid] ~= nil and checkStackpos(item, fromPosition) == TRUE) then
if(item.actionid == 0) then
doTransformItem(item.uid, doors[item.itemid])
else
doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "It is locked.")
end

return TRUE
end

return FALSE
end