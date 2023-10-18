if not AI then
	return false
end

--[[
@classname 
	AI.FocusNpc
@inherits
	AI.BasicNpc
@description 
	A BasicNpc with focusable behaviour, it still dont know how to talk,
    for a "normal" npc use AI.SocialNpc
]]
local FocusNpc = {
	Events = {
		--[[@event
			This event is triggered just before focusing a new creature, if handled/canceled
			the creature wont get focused.
			@params
			cid creature, the about to focus creature
		]]
		OnAboutToFocus = AI.UniqueId(),
		
		--[[@event
			This event is triggered when a creature is focused.
			@params
			cid creature, the focused creature
		]]
		OnFocus = AI.UniqueId(),
		
		--[[@event
			This event is called when a creature is unfocused, for details, check the
			reason field in the event object
			@params
			cid creature, the unfocused creature
			reason  AI.FocusNpc.UnfocusReason, the unfocus reason
		]]
		OnUnfocus = AI.UniqueId()
	},
	
	--[[@enum
		Values used when triggering OnUnfocus, to distinguish between different causes of unfocusing.
		@values
		SelfRequested, When the class user calls AI.FocusNpc.Unfocus programmatically
		FocusRemoved, When the creature is removed from the game
		FocusWalkedAway, When the creature walks away from our vision radius
	]]
	UnfocusReason = {
		SelfRequested = AI.UniqueId(),
		FocusRemoved = AI.BasicNpc.CreatureMissReason.Removed,
		FocusWalkedAway = AI.BasicNpc.CreatureMissReason.WalkAway
	},
		
	--[[@property boolean, Look at our first/only focused creature at every moment ]]
	LookAtFocus = true,
	
	--[[@method
		Creates a new focusable npc
	]]
	New = function() end,
	
	--[[@method
		Adds a creature to this npc focus list, effectively triggering the OnAboutToFocus and
		OnFocus events. If the creature was already focused or if the creature could not be focused, 
		this function returns false		
		@params
		cid creature, the creature
		@returns
		boolean, whether the creature was successfully focused or not
	]]
	AddFocus = function(cid) end,
	
	--[[@method
		Removes a previosly focused creature from this npc focus list, effectively triggering the OnUnfocus
		event. A optional parameter (defaults to SelfRequested) can be specified to set the event unfocus reason.
		@params
		cid creature, the creature
		[reason] AI.FocusNpc.UnfocusReason, the unfocus reason		
	]]
	RemoveFocus = function(cid, reason) end,
	
	--[[@method
		Returns true if the given creature is already focused
		@params
		cid creature, the creature
		@returns
		boolean, whether the given creature is focused or not
	]]
	IsFocused = function(cid) end,
	
	--[[@method
		Adds a variable piece of data to the given creature focus storage, all the data stored using 
		this function will remain until the creature is unfocused
		@params
		cid creature, the creature
		id string/number, the identifier of this piece of data
		data mixed, the data to store
	]]
	SetFocusData = function(cid, id, data) end,
	
	--[[@method
		Returns the piece of data associated to this npc creature focus storage with the given identifier.
		@params
		cid creature, the creature
		id string/number, the identifier used in the registration of the wanted piece of data
		@returns
		mixed, the stored data or nil if there's no data associated with the given id
	]]
	GetFocusData = function(cid, id) end,
	
	--[[@method
		Returns a table containing all the data stored in this npc creature focus storage
		@params
		cid creature, the creature
		@returns
		table, a table(keys=ids, values=data) containing all the data stored for this creature
	]]	
	GetAllFocusData = function(cid) end
}

function FocusNpc:New()
	local npc = AI.CreateInstance(FocusNpc)
	npc.FocusNpc = {
		focuses = {},
		focusData = {}
	}

	-- Register events
	for key, event in pairs(FocusNpc.Events) do
		npc:RegisterEvent(event)
	end

	-- Register callbacks
	npc:AddCallback(AI.BasicNpc.Events.OnMissCreature, self.FocusMissCreatureCallback)
	npc:AddCallback(AI.BasicNpc.Events.OnThink, self.FocusOnThinkCallback)

	return npc
end

function FocusNpc:SetFocusData(cid, id, data) 
	assert(self:IsFocused(cid), "FocusNpc:SetFocusData() Attempt to associate data to an unfocused creature cid")
	self.FocusNpc.focusData[cid][id] = data
end

function FocusNpc:GetFocusData(cid, id)
	assert(self:IsFocused(cid), "FocusNpc:GetFocusData() Attempt to retrieve data from an unfocused creature cid")
	return self.FocusNpc.focusData[cid][id]
end

function FocusNpc:GetAllFocusData(cid)
	assert(self:IsFocused(cid), "FocusNpc:GetAllFocusData() Attempt to retrieve data from an unfocused creature cid")
	return self.FocusNpc.focusData[cid]
end

function FocusNpc:IsFocused(cid)
	return AI.TableFind(self.FocusNpc.focuses, cid) and true or false
end

function FocusNpc:AddFocus(cid)
	if self:IsFocused(cid) or (not self:IsCreatureVisualized(cid) and not self:VisualizeCreature(cid)) or self:TriggerAboutToFocus(cid) then
		return false
	end

	table.insert(self.FocusNpc.focuses, cid)
	self.FocusNpc.focusData[cid] = {}
	self:TriggerFocus(cid)
	return true
end

function FocusNpc:RemoveFocus(cid, reason)
	local index = AI.TableFind(self.FocusNpc.focuses, cid)
	if index then
		self:TriggerUnfocus(cid, reason or FocusNpc.UnfocusReason.SelfRequested)
		table.remove(self.FocusNpc.focuses, index)
		self.FocusNpc.focusData[cid] = nil
	end
end

function FocusNpc:GetFocuses()
	return AI.Clone(self.FocusNpc.focuses)
end

function FocusNpc:TriggerAboutToFocus(cid)
	return self:Dispatch({
		eventType = AI.FocusNpc.Events.OnAboutToFocus,
		cid = cid
	})
end

function FocusNpc:TriggerFocus(cid)
	return self:Dispatch({
		eventType = AI.FocusNpc.Events.OnFocus,
		cid = cid
	})
end

function FocusNpc:TriggerUnfocus(cid, reason)
	return self:Dispatch({
		eventType = AI.FocusNpc.Events.OnUnfocus,
		cid = cid,
		reason = reason
	})
end

function FocusNpc:FocusMissCreatureCallback(event)
	self:RemoveFocus(event.cid, event.reason)
end

function FocusNpc:FocusOnThinkCallback(event)
	if self.LookAtFocus then
		if table.size(self.FocusNpc.focuses) > 0 then
			doNpcSetCreatureFocus(self.FocusNpc.focuses[1])
		else
			doNpcSetCreatureFocus(nil)
		end
	end	
end

-- Register
AI.Inherit(AI.BasicNpc, FocusNpc)
AI.FocusNpc = FocusNpc
return FocusNpc