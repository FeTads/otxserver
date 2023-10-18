if not AI then
	return false
end

local Dispatcher = {
	-- Creates a new Dispatcher object
	--[[@method
		Creates a new Dispatcher object
	]]
	New = function() end,

	--[[@method
		Register an event type in this dispatcher, if you plan to create your own events, use something like this
		to assign them a numeric value:
		[code]
			MyNpc.MyCustomEvent = AI.UniqueId()
		[/code]
		This ensures you never overwrite a previous event
		@params
		eventType number, a numeric id for this event
	]]
	RegisterEvent = function(eventType) end,
	
	--[[@method
		Register a callback function for the given eventType in this dispatcher
		@params
		eventType number, the numeric id of this event
		callback function, a function to be called every time the event is triggered
	]]
	AddCallback = function(eventType, callback) end,
	
	--[[@method
		Dispatch the event to all its registered callbacks, the unique event argument should be a table
		containing custom event information (such as cid, msg, etc) plus one field eventType, containing the id
		of event. All the callback functions are called with to arguments, the dispatcher itself and the event object.
		If a callback function exits returning true, the event is considered handled and no other callbacks will
		be called. You can use code like this to check for custom events:
		[code]
		if not MyNpc:Dispatch(event) then
			-- all the callbacks were called and the event was not handled
		else
			-- the event was handled by one of the registered callbacks
		end
		[/code]
		@params
		event table, the event object containing information appropiate for its eventType
		@returns
		boolean, whether the event was handled or not
	]]
	Dispatch = function(event) end
}

function Dispatcher:New()
	local dispatcher = AI.CreateInstance(self)
	dispatcher.Dispatcher = {
		callbacks = {}		
	}
	
	return dispatcher
end

function Dispatcher:RegisterEvent(eventType)
	self.Dispatcher.callbacks[eventType] = {}
end

function Dispatcher:AddCallback(eventType, callback)
	table.insert(self.Dispatcher.callbacks[eventType], callback)
end

function Dispatcher:Dispatch(event)
	for _, callback in ipairs(self.Dispatcher.callbacks[event.eventType]) do
		if callback(self, event) == true then
			return true
		end
	end
	
	return false
end

AI.Dispatcher = Dispatcher
return Dispatcher