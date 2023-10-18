if not AI then
	return false
end

--[[
@classname 
	AI.BasicNpc
@description 
	This class provides innate npc functionality, like thinking, hearing and viewing. Most of the time
	what you want to use is an AI.SocialNpc.
]]
local BasicNpc = {
	Events = {
		--[[@event 
			The raw onCreatureAppear event, you should not use this often.
			If a callback handles/cancels the event, the npc will act as if this creature
			is _not_ on the screen, if the creature later moves into VisionRadius,
			the npc wont fire the OnVisualizeCreature event, since is _not_ tracking
			it
			@params
			cid creature, the creature 
		]]
		OnCreatureAppear = AI.UniqueId(), 
			
		--[[@event
			The raw onCreatureDisappear event, you should not use this often.
			@params
			cid creature, the creature about to disappear
		]]		
		OnCreatureDisappear = AI.UniqueId(),
			
		--[[@event
			This event fires when a creature suddenly moves into this npc VisionRadius,
			If you handle/cancel this event, the npc wont track this creature (see 
			onCreatureAppear) and the event OnMissCreature will _not_ fire when this creature leaves 
			our vision radius.
			@params
			cid creature, the creature
		    pos position, the position where we first saw this creature		
		]]
		OnVisualizeCreature = AI.UniqueId(),
		
		--[[@event
			This event fires when a previously visualized creature suddenly disspears
			from our VisionRadius
			@params
			cid creature, the creature
			reason AI.BasicNpc.CreatureMissReason, the missing reason
		]]
		OnMissCreature = AI.UniqueId(),
		
		--[[@event
			The raw onCreatureSay, you should not be using this often.
			If you handle/cancel this event, the npc won't be able to hear the creature
			speech(i.e no OnHear firing)
			@params
			cid creature, the creature
			type MessageType, the message type
			msg string, the message
		]]
		OnCreatureSay = AI.UniqueId(),
		
		--[[@event
			This event fires when a creature on this npc hear radius says
			something, note that this event will still fire even if the creature
			is outside this npc vision radius, use the creatureVisible event param to 
			check for this
			@params
			cid creature, the creature
			type MessageType, the message type
			msg string, the message
			creatureVisible boolean, whether the creature is in our vision radius or not
		]]
		OnHear = AI.UniqueId(),
		
		--[[@event
			The raw onThink event. 
		]]
		OnThink = AI.UniqueId(),
		
		--[[@event
			This event is triggered once, when AI.BasicNpc:Register is called
			@params
			scriptEnv Table, the npc script enviroment (you can define/get functions/variables inside it)
		]]
		OnRegister = AI.UniqueId()
	},
	
	--[[@enum
		Values used when triggering OnMissCreature, to distinguish between different causes of missing.
		@values
		Removed, When the creature is removed from the game
		WalkAway, When the creature walks away from our vision radius
	]]
	CreatureMissReason = {
		Removed = AI.UniqueId(),
		WalkAway = AI.UniqueId()
	},
		
	--[[@property number, The radius (from the npc position) where this npc can see other creatures]]
	VisionRadius = 7,
		
	--[[@property boolean, If enabled this npc will check its enviroment for close players
		and fire OnVisualize events, its a bit costly, so use it wisely.
		If not enabled, the only kind OnVisualize event this npc will fire
		is when a creature logs in near him
	]]
	RealTimeVisualization = true,
	
	--[[@property number, The radius (from the npc position) where this npc can hear other creatures]]
	HearRadius = 5,
	
	--[[@property function, This function will be called before performing any action on a creature, 
		if it returns false, this npc will ignore this creature 
	]]
	CreatureFilter = function(npc, cid) 
		return isPlayer(cid) and not isPlayerGhost(cid)
	end,
	
	--[[@method
		Creates a new AI.BasicNpc object
	]]
	New = function() end,
	
	--[[@method
		Adds a delayed function call to this npc, the action will be executed in
		(current time + delay) miliseconds, passing this npc as the first parameter
		and all the extra paramteres passed to AddDelayedAction in the same order.
		The call looks like this:
			[code]fn(self, param1, ... paramN)[/code]
		@params
		fn function, the function to be executed
		delay number, the number of miliseconds to wait before executing this function
		... mixed, a variable list of parameters to pass as extra arguments to the function
	]]
	AddDelayedAction = function(fn, delay, ...) end,
	
	--[[@method
		Adds a variable piece of data to this npc global storage, using id as the identifier.
		The data you set using this function will be always available until the npc is 
		deleted/reloaded
		@params
		id string/number, the identifier of this piece of data
		data mixed, the data to store
	]]
	SetGlobalData = function(id, data) end,
	
	--[[@method
		Returns the piece of data associated to this npc with the given identifier.
		@params
		id string/number, the identifier used in the registration of the wanted piece of data
		@returns 
		mixed, the requested piece of data or nil if there's no data associated with the given id
	]]
	GetGlobalData = function(id) end,
	
	--[[@method
		Manual visualization for when RealTimeVisualization is off,
		if the given creature is out of this npc vision radius the
		creature will not be visualized.
		This is NOT a focus function, visualization only means that a npc
		is aware of a creature existance. You don't need to call this function
		explicitly
		@params
		cid creature, the creature to visualize
	]]
	VisualizeCreature = function(cid) end,
	
	--[[@method
		Manual function for unvisualazing creatures, complement of AI.BasicNpc.VisualizeCreature
		@params
		cid creature, the creature to unvisualize
	]]
	MissCreature = function(cid) end,
	 
	--[[@method
		Returns true if the given thing is in this npc VisionRadius
		@params
		thing thing, the thing 
		@returns
		boolean, whether the given thing is in this npc VisionRadius or not
	]]
	IsInVisionRange = function(thing) end,
	
	--[[@method
		Returns true if the given creature is in this npc HearRadius
		@params
		cid creature, the creature 
		@returns
		boolean, whether the given creature is in this npc HearRadius or not
	]]
	IsInHearRange = function(cid) end,
	
	--[[@method
		Returns true if the given position is in the boundaries of the given range
	    respect to this npc position
		@params
		position position, the position 
		range number, the radius comming from this npc position
		@returns
		boolean, whether the given position is the boundaries of the given range
	]]
	IsInRange = function(position, range) end,
		
	--[[@method
		Returns the npc name
		@returns
		string, the npc name
	]]
	GetName = function() end,
	
	--[[@method
		Return the npc current position
		@returns
		position, the npc current position
	]]
	GetPosition = function() end,
	
	--[[@method
		Register this npc to the otserv default npc system, you must call this function at the end of the
		npc file, if not, the npc wont work properly. Calling this function will fire the
		AI.BasicNpc.Events.OnRegister event
	]]
	Register = function() end,
}

local function actionCompare(a,b) 
	return a.deliverTime < b.deliverTime
end

function BasicNpc:New()
	local npc = AI.CreateInstance(BasicNpc)
	npc.BasicNpc = {
		inRangeCreatures = {},
		varPool = {},
		delayedActions = AI.PriorityQueue:New(actionCompare)
	}
	
	-- Register events
	for key, event in pairs(BasicNpc.Events) do
		npc:RegisterEvent(event)
	end

	return npc
end

function BasicNpc:AddDelayedAction(callback, delay, ...)	
	self.BasicNpc.delayedActions:Push({
		deliverTime = os.clock() + (delay / 1000),
		fn = callback,
		params = arg
	})
end

function BasicNpc:SetGlobalData(id, data)
	self.BasicNpc.varPool[id] = data
end
	
function BasicNpc:GetGlobalData(id) 
	return self.BasicNpc.varPool[id]
end

function BasicNpc:Register()
	local scriptEnv = getfenv(2)
	function scriptEnv.onThink()
		local newInRange = {}
		-- Purge removed/out-of-range creatures from us
		for _, cid in ipairs(self.BasicNpc.inRangeCreatures) do
			local isValid = self:CreatureFilter(cid)
			if isValid and self:IsInVisionRange(cid) then
				table.insert(newInRange, cid)
			else
				self:FireOnMissCreature(cid)
			end			
		end
		
		self.BasicNpc.inRangeCreatures = newInRange		
		-- Visualize more creatures, a bit costly though
		if self.RealTimeVisualization then
			local spectators = getSpectators(self:GetPosition(), self.VisionRadius, self.VisionRadius)
			for _, cid in ipairs(spectators) do
				if self:CreatureFilter(cid) then
					self:VisualizeCreature(cid)
				end
			end
		end		
		
		-- Dispatch the event
		self:Dispatch({
			eventType = BasicNpc.Events.OnThink
		})
		-- Execute delayed actions		
		while(not self.BasicNpc.delayedActions:IsEmpty() and self.BasicNpc.delayedActions:Top().deliverTime <= os.clock()) do
			local action = self.BasicNpc.delayedActions:Pop()
			action.fn(self, unpack(action.params))
		end
	end
		
	function scriptEnv.onCreatureAppear(cid)
		if not self:CreatureFilter(cid) then
			return
		end

		if self:Dispatch({
			eventType = BasicNpc.Events.OnCreatureAppear,
			cid = cid
		}) then
			return		
		end

		self:VisualizeCreature(cid)
	end
	
	function scriptEnv.onCreatureDisappear(cid) 
		self:Dispatch({
			eventType = BasicNpc.Events.OnCreatureDisappear,
			cid = cid
		})
		self:MissCreature(cid)
	end
	
	function scriptEnv.onCreatureSay(cid, type, msg) 	
		if not self:CreatureFilter(cid) then
			return
		end
		
		if self:Dispatch({
			eventType = BasicNpc.Events.OnCreatureSay,
			cid = cid,
			type = type,
			msg = msg
		}) then
			return		
		end
		
		if self:IsInHearRange(cid) then
			self:Dispatch({
				eventType = BasicNpc.Events.OnHear,
				cid = cid,
				type = type,
				msg = msg,
				creatureVisible = self:IsInVisionRange(cid)
			})
		end		
	end

	self:Dispatch({
		eventType = BasicNpc.Events.OnRegister,
		scriptEnv = scriptEnv
	})
end

function BasicNpc:VisualizeCreature(cid)
	if not self:IsInVisionRange(cid) or self:IsCreatureVisualized(cid) or self:FireOnVisualizeCreature(cid) then
		return false
	end

	table.insert(self.BasicNpc.inRangeCreatures, cid)
	return true
end

function BasicNpc:IsCreatureVisualized(cid)
	return AI.TableFind(self.BasicNpc.inRangeCreatures, cid) and true or false
end

function BasicNpc:MissCreature(cid)
	local index = AI.TableFind(self.BasicNpc.inRangeCreatures, cid)
	if index then
		self:FireOnMissCreature(cid)
		table.remove(self.BasicNpc.inRangeCreatures, index)
	end
end

function BasicNpc:IsInVisionRange(thing)
	return self:IsInRange(getThingPosition(thing), self.VisionRadius)
end

function BasicNpc:IsInHearRange(cid)
	return self:IsInRange(getThingPosition(cid), self.HearRadius)
end

function BasicNpc:IsInRange(pos, range)
	local position = self:GetPosition()
	return position.z == pos.z and math.max(math.abs(position.x - pos.x), math.abs(position.y - pos.y)) <= range
end

function BasicNpc:GetPosition()
	return getCreaturePosition(getNpcId())
end

function BasicNpc:GetName()
	return getCreatureName(getNpcId())
end

function BasicNpc:FireOnMissCreature(cid)
	self:Dispatch({
		eventType = BasicNpc.Events.OnMissCreature,
		cid = cid,
		reason = isCreature(cid) and 
			BasicNpc.CreatureMissReason.WalkAway or
			BasicNpc.CreatureMissReason.Removed
	})
end

function BasicNpc:FireOnVisualizeCreature(cid)
	return self:Dispatch({
		eventType = BasicNpc.Events.OnVisualizeCreature,
		cid = cid,
		pos = getCreaturePosition(cid)
	})
end

-- Register
AI.Inherit(AI.Dispatcher, BasicNpc)
AI.BasicNpc = BasicNpc
return BasicNpc