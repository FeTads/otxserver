if not AI then
	return false
end

--[[
@classname 
	AI.SocialNpc
@inherits
	AI.FocusNpc
@description 
	This is the main class to look at to start creating new rich-featured npcs.
	The class provides the all the functionality you would expect from an advanced NPC class.
	It supports complex conversations aswell as standar greet/farewell replies, 80% of the job of this
	class is to make possible all kind of weird/complex conversations you will ever code, easy.
	The rest of this class provides you a pluginable architecture, where you can attach Shop, Travel and every
	other kind of custom modularized functionality to your npc.
	
	To create a new instance of this class use:
	[code]
	local MyNpc = AI.SocialNpc:New()
	[/code]
	
	After that, you can do some basic customization to the npc changing its properties:
	[code]
	MyNpc.GreetReply = "Oh hi |PLAYERNAME|!"
	MyNpc.MaxIdleTime = 20000
	MyNpc.CreatureFilter = function(cid)
		return isPlayer(cid) and isPremium(cid)
	end	
	[/code]
	
	Some properties accept different kind of values/types, for example, GreetReply can be either a string or a function.
	You may skip this step since adecuate default values are provided when creating a new npc.
	
	As with most the AI.Npc classes, you will rarely need to call a npc member function outside a conversation or
	other kind of operation (like waypoint walking). Most of the conversation code is handled by two main classes, [classref]AI.Talk[/classref] and
	[classref]AI.DeclarativeTalk[/classref]. Both talk classes have built-in support for maitaning a conversation with multiple players at a time and remebering data from all of the conversations, you can use these two classes
	within one npc, but such approach is not recommended and might cause unexpected behaviour, as a general rule, you should stick to one of these classes per npc. Both of them are capable
	of creating really complex conversations, but AI.DeclarativeTalk tends to be more useful and easy to code for small or keywords-answer types of npc. AI.Talk offers a more lenghtly syntax, but also more
	redable and as the npc becomes bigger, conversations created with it start looking smaller and nicer than the declarative code equivalent.
	
	IMPORTANT! You must call the AI.BasicNpc.Register() function at the end of the npc file, this will take care of making the server aware of your npc.
	
	Consider this small exmaple:
	[code]
	local Npc = AI.SocialNpc:New()
	Npc.GreetReply = "Hey there |PLAYERNAME|, how's going?"
	Npc.FarewellReply = "See you later!"
	
	Npc.Conversation = {
		{['job|occupation'] = "My job is to generate gold every second"}
		{['quest|mission'] = "Sorry, no missions for you today!"}
	}
	
	Npc:Register()
	[/code]
	
	Take a look at the AI.Plugin classes, for shop, addons, and promotion examples. (Soon)
@seealso
	AI.Talk, AI.DeclarativeTalk, AI.Plugin
]]
local SocialNpc = {
	Events = {
		--[[@event 
			This event is triggered every time this npc is about to say something. 
			If you handle/cancel this event, the message is ignored and not outputed.
			@params
			cid creature/nil, the creature we are talking to, nil if we are talking in the default channel
			msg, the text we are about to output
		]]
		OnSay = AI.UniqueId(),
		
		--[[@event
			Triggered when a player says something that matches a keyword from the AI.SocialNpc.GreetKeywords table, inside this npc HEAR radius.
			If the hear radius is greater than the vision radius and the player is standing outside this npc VISION radius, then AI.SocialNpc.ComeCloserReply is outputed and this event is not triggered, otherwise
			the event is triggered.
			If you handle/cancel this event the npc won't start a talk a with the player.
			@params
			cid creature, the creature
			type MessageType, the message type
			msg string, the message			
			keyword string, the keyword that this player used to greet us
		]]
		OnPlayerGreetUs = AI.UniqueId(),
		
		--[[@event
			Triggered when a player says something that matches a keyword from the AI.SocialNpc.UngreetKeywords, just before we ungreet the player.
			If you handle/cancel this event, the ungreet request will be ignored and the conversation will be intact.
			@params
			cid creature, the creature
			type MessageType, the message type
			msg string, the messagekeyword string, 
			keyword string, the keyword that the player used to ungreet us
		]]
		OnPlayerUngreetUs = AI.UniqueId(),
		
		--[[@event
			Triggered after a not handled triggering of AI.SocialNpc.OnPlayerGreetUs, or when a call to AI.SocialNpc.Greet 
			is programmatically called. 
			If you handle/cancel this event, no message is going to be outputed, otherwise, AI.SocialNpc.GreetReply is outputed.
			Even if you handle this event, the conversation WILL start.
			@params
			cid creature, the creature,
			reason AI.SocialNpc.TalkEndReason, the reason for ungreeting
		]]
		OnGreet = AI.UniqueId(),
		
		--[[@event
			Triggered after a not handled triggering of AI.SocialNpc.OnPlayerUngreetUs,	when the npc becomes 'bored'(AI.SocialNpc.MaxIdleTime timedout), when a player just walked away from our vision radius or disconnects, or when its 
			selfrequested by the class user (via AI.SocialNpc.Ungreet or AI.SocialNpc.CustomUngreet). The trigger reason is specified in the event param reason, by one of the values in
			AI.SocialNpc.TalkEndReason. If you handle/cancel this event, no 'farewell' message will be outputed, there're different replies for each of the different values from TalkEndReason, none of them will
			be outputed, not even the custom message passed to AI.SocialNpc.CustomUngreet. 
			Is the event is not handled, an approtiate reply is outputed and the conversations ends (along with the focus). Even if you handle this event, the conversation WILL end.
			@params
			cid creature, the creature,
			reason AI.SocialNpc.TalkEndReason, the reason for ungreeting
		]]
		OnUngreet = AI.UniqueId(),
	},
	
	--[[@enum
		Values used when triggering OnUngreet, to distinguish between different causes of ungreeting.
		@values
		PlayerRequested, When the player requested it by saying an appropiate keyword, or when the class user calls AI.SocialNpc.Ungreet or AI.SocialNpc.CustomUngreet programmatically
		FocusRemoved, When the player is removed from the game
		FocusWalkedAway, When the player walks away from our vision radius
		Timedout, When the npc gets bored (i.e AI.SocialNpc.MaxIdleTime timesout)
	]]
	TalkEndReason = {
		PlayerRequested = AI.FocusNpc.UnfocusReason.SelfRequested,
		FocusRemoved = AI.FocusNpc.UnfocusReason.FocusRemoved,
		FocusWalkedAway = AI.FocusNpc.UnfocusReason.FocusWalkedAway,
		Timedout = AI.UniqueId()
	},
	
	--[[@property table, they keywords this npc will listen to start a conversation]]
	GreetKeywords = {"hi", "hello", "hey"},
	
	--[[@property table, they keywords this npc will listen to end a conversation]]
	FarewellKeywords = {"bye", "farewell", "cya"},
	
	--[[@property table, they keywords this npc will listen when hes asking a binary question and expecting a positive answer]]
	AgreementKeywords = {"yes", "ok", "yeah", "affirmative"},

	--[[@property table, they keywords this npc will listen when hes asking a binary question and expecting a negative answer]]
	DisagreementKeywords = {"no", "not", "negative"},
	
	--[[@property boolean, if setted to true, GreetKeywords are ignored and a conversation will start from everything a player says]]
	StartTalkWithAnyInput = false,
	
	--[[@property number, The maximum time(in miliseconds) this npc is gonna wait for a player response before ending the talk]]
	MaxIdleTime = 300000,
	
	--[[@property number, The time(in miliseconds) this npc is gonna wait before outputting a requested message]]
	ResponseDelay = 350,
	
	--[[@property mixed, Declarative talk configuration]]
	Conversation = nil,
	
	--[[@property boolean, Case sensitivity (differ upper from lower case strings)]]
	TalkCaseSensitive = false,
	
	--[[@property number/boolean, This is the equivalent to Jiddo's Npc system KEYWORD_BEHAVIOR, except that you can set this
	to any integer value, this will recheck up to N previous topics if the current ones doesn't
	match, set it to true to recheck all the topics or 0 to disable topic checking. This only works with AI.Talk, you must code
	manual remembering for AI.DeclarativeTalk]]
	GoUpTimes = 1, 
	
	--[[@property string/function, reply to greet the player, if its a function, its called with an AI.Talk object as unique argument]]
	GreetReply 	    = 'Welcome, |PLAYERNAME|! I have been expecting you.',
	
	--[[@property string/function, reply used when a player tries to greet us, we can hear him (i.e he's inside our hear radius) and we cannot see him (i.e outside our vision radius), if its a function, its called without ANY arguments, since theres no talk created at this time]]
	ComeCloserReply  = 'Come a little closer so we can talk..',
	
	--[[@property string/function, reply to ungreet the player in normal conditions, if its a function, its called with an AI.Talk object as unique argument]]
	FarewellReply  = 'Good bye, |PLAYERNAME|!',
	
	--[[@property string/function, reply to ungreet the player when MaxIdleTime times out, if its a function, its called with an AI.Talk object as unique argument]]
	IdleTimeoutReply= 'Next, please!',
	
	--[[@property string/function, reply to ungreet the polayer when he walked away from our vision radius, if its a function, its called with an AI.Talk object as unique argument]]
	WalkAwayReply	= 'How rude!',
	
	--[[@property string, the string token that is replaced with the player name every time this npc says something]]
	PlayerNameToken = 'PLAYERNAME',
	
	TalkData = 'SocialNpc.talk',
	InterestData = 'SocialNpc.interest',
	TalkThreadData = 'SocialNpc.talkThread',
	PendingUnfocusData = 'SocialNpc.pendingUnfocus',
	
	--[[@method
		Creates a new social NPC
	]]
	New = function() end,
	
	--[[@method
		Says something to the default channel, if the second optional argument
		is true, the message is sent immediately, otherwise it will be delayed as
		specified by AI.SocialNpc.TalkDelay
		@params		
		message string, the message
		[noDelay] boolean, defaults to false, if true, the message will not be delayed
	]]
	Say = function(message, noDelay) end,
	
	--[[@method
		Says something to a player using the npc channel, you will usually not call this function
		directly since AI.Talk.Say is shorter and less error prone.
		@params		
		message string, the message
		cid creature, the player
		[noDelay] boolean, defaults to false, if true, the message will not be delayed
	]]
	SayTo = function(message, cid, noDelay) end,
	
	--[[@method
		Returns the AI.Talk object associated with the given player
		@params		
		cid creature, the player
		@returns
		AI.Talk, the talk object or nil if there's none
	]]
	GetTalk = function(cid) end,
	
	--[[@method
		Returns true if there's an active talk for the given player
		@params		
		cid creature, the player
		@returns
		boolean, whether we are talking with the given player or not
	]]
	IsTalkActive = function(cid) end,
		
	--[[@method
		Greets the given player. This function can only great players that
		can be visualized and focused. To check if the greet was successful use
		AI.SocialNpc.IsTalkActive. This function is called automatically when a player
		starts the talk (via AI.SocialNpc.GreetKeywords or AI.SocialNpc.StartWithAnyInput)
		@params		
		cid creature, the player
	]]
	Greet = function(cid) end,
	
	--[[@method
		Ungreets the given player triggering the OnUngreet event with the given reason.
		This function is called automatically when a player ends the talk (via AI.SocialNpc.FarewellKeywords)
		@params		
		@returns
	]]
	Ungreet = function(cid, reason) end,
	
	--[[@method
		Ungreets the given player using a custom message, triggering the OnUngreet event with 
		AI.SocialNpc.PlayerRequested as the ungreet reason. You will usually use this function
		by calling AI.Talk.End(msg) instead of using it directly.
		@params		
		cid creature, the player
		msg string, the custom ungreet message
	]]
	CustomUngreet = function(cid, msg) end,
	
	--[[@method
		This function removes the given player from this npc focuses after the delay specified
		in AI.SocialNpc.TalkDelay. You shouldn't be using this function directly although it might	
		come in hand on some situations.
		@params	
		cid creature, the player
	]]
	DelayedRemoveFocus = function(cid) end,
	
	--[[@method
		Refreshes the interaction timer for the given player, effectively preventing the ungreet of the player
		by timeout reasons. This function is called automatically every time a npc reacts to a player (usually after 
		saying something)
		@params		
		cid creature, the player
	]]
	KeepInterest = function(cid) end,
	
	--[[@method
		Returns a new string in wich all the ocurrences of |AI.SocialNpc.PlayerNameToken| were replaced
		by the given player name. This function is called automatically for every message this npc says.
		@params		
		msg string, the base string
		cid creature, the player
		@returns
		string, the newly parsed string
	]]
	ParsePlayerName = function(msg, cid) end
}

local function SayDefault(npc, msg, cid)
	if type(msg) == "string" then
		npc:SayTo(msg, cid)
	elseif type(msg) == "function" then
		msg(npc:IsTalkActive(cid) and npc:GetTalk(cid) or nil)
	end
end

local function CreateCoroutine(npc, cid)
	npc:SetFocusData(cid, npc.TalkThreadData, coroutine.create(npc.ProcessTalkThread))
end

function SocialNpc:New()
	local npc = AI.CreateInstance(SocialNpc)
	npc.SocialNpc = {}

	-- Register events
	for key, event in pairs(SocialNpc.Events) do
		npc:RegisterEvent(event)
	end
	
	-- Regiser callbacks
	npc:AddCallback(AI.BasicNpc.Events.OnHear, self.SocialOnHearCallback)
	npc:AddCallback(AI.BasicNpc.Events.OnThink, self.SocialOnThinkCallback)
	npc:AddCallback(AI.FocusNpc.Events.OnFocus, self.SocialOnFocusCallback)
	npc:AddCallback(AI.FocusNpc.Events.OnUnfocus, self.SocialOnUnfocusCallback)

	return npc
end

function SocialNpc:Say(message, noDelay)
	if noDelay then
		self:TriggerOnSay(message)
	else
		self:AddDelayedAction(self.Say, self.ResponseDelay, message, true)
	end
end

function SocialNpc:SayTo(message, cid, noDelay)
	if noDelay then
		self:TriggerOnSay(message, cid)
	else
		self:AddDelayedAction(self.SayTo, self.ResponseDelay, message, cid, true)
	end
end

function SocialNpc:TriggerOnSay(msg, cid)
	if not self:Dispatch({
		eventType = SocialNpc.Events.OnSay,
		msg = msg,
		cid = cid
	}) then 
		if cid then
			selfSay(self:ParsePlayerName(msg, cid), cid)
		else
			selfSay(msg)
		end
	end
end

function SocialNpc:GetTalk(cid)
	return self:GetFocusData(cid, self.TalkData) 
end

function SocialNpc:IsTalkActive(cid)
	return self:IsFocused(cid) and not self:GetFocusData(cid, self.PendingUnfocusData)
end

function SocialNpc:CreateTalk(cid)
	self:SetFocusData(cid, self.TalkData, AI.Talk:New(self, cid))
	self:SetFocusData(cid, self.PendingUnfocusData, false)
	self:KeepInterest(cid)
	CreateCoroutine(self, cid)
end

function SocialNpc:CheckForGreet(_msg)
	local greetWord = AI.GetMatch(_msg, self.GreetKeywords, self.TalkCaseSensitive)
	local msg = self.TalkCaseSensitive and _msg or _msg:lower()

	if greetWord then
		-- Hi NPCNAME
		if msg:find((self.TalkCaseSensitive and self:GetName() or self:GetName():lower()), 1, true) then
			return greetWord
		end

		local otherNpcs = getSpectators(self:GetPosition(), 7, 7)
		-- Check for Hi OTHERNPCNAME
		for _, npc in ipairs(otherNpcs) do
			if msg:find((self.TalkCaseSensitive and getCreatureName(npc) or getCreatureName(npc):lower()), 1, true) then
				return false
			end
		end
		
		-- No name specified, assume player is talking to us
		return greetWord
	end

	return false
end

function SocialNpc:Greet(cid)	
	if self:AddFocus(cid) and not self:Dispatch({
		eventType = SocialNpc.Events.OnGreet,
		cid = cid
	}) then		
		SayDefault(self, self.GreetReply, cid)
	end
end

function SocialNpc:Ungreet(cid, reason, suppressUnfocus)	
	if not self:Dispatch({
		eventType = SocialNpc.Events.OnUngreet,
		cid = cid,
		reason = reason
	}) then
		local msg 
		
		if reason == SocialNpc.TalkEndReason.PlayerRequested then
			msg = self.FarewellReply
		elseif reason == SocialNpc.TalkEndReason.FocusWalkedAway then
			msg = self.WalkAwayReply
		elseif reason == SocialNpc.TalkEndReason.Timedout then
			msg = self.IdleTimeoutReply
		end

		if msg then
			SayDefault(self, msg, cid)
		end			
	end
	
	if not suppressUnfocus then
		self:DelayedRemoveFocus(cid)
	end
end

function SocialNpc:CustomUngreet(cid, msg)
	if not self:Dispatch({
		eventType = SocialNpc.Events.OnUngreet,
		cid = cid,
		reason = SocialNpc.TalkEndReason.PlayerRequested 
	}) then
		self:SayTo(msg, cid)
	end

	self:DelayedRemoveFocus(cid)
end

function SocialNpc:DelayedRemoveFocus(cid)
	if self:IsTalkActive(cid) then
		self:AddDelayedAction(self.RemoveFocus, self.ResponseDelay, cid)
		self:SetFocusData(cid, self.PendingUnfocusData, true)
	end
end

function SocialNpc:KeepInterest(cid)
	self:SetFocusData(cid, self.InterestData, os.clock())
end

function SocialNpc:SocialOnHearCallback(event)
	if self:IsTalkActive(event.cid) then
		local talk = self:GetFocusData(event.cid, self.TalkThreadData)
		
		if coroutine.status(talk) == "dead" then
			CreateCoroutine(self, event.cid)
			talk = self:GetFocusData(event.cid, self.TalkThreadData)
		end
		
		local success, speechProccessed = coroutine.resume(talk, self, event)
		
		if not success then
			print(debug.traceback(talk), speechProccessed)
			return false
		end		
		
		if speechProccessed then
			self:KeepInterest(event.cid)
		end
		
		return speechProccessed
	elseif (self.GreetKeywords or self.StartTalkWithAnyInput) then 
		local match = self:CheckForGreet(event.msg) 
		if match or self.StartTalkWithAnyInput then
		
			if not event.creatureVisible then				
				SayDefault(self, self.ComeCloserReply, event.cid)	
				return 
			end
			
			if not self:Dispatch(AI.Mix(event, {
				eventType = SocialNpc.Events.OnPlayerGreetUs,
				keyword = match
			})) then				
				self:Greet(event.cid)
			end
			
			return true
		end
	end	
end

function SocialNpc:ProcessTalkThread(event)
	local talk =  self:GetTalk(event.cid)
	local processed = talk:Process(event) or AI.DeclarativeTalk.Process(self, event, talk)

	-- Look for standar replys
	if not processed and self.FarewellKeywords then
		local match = AI.GetMatch(event.msg, self.FarewellKeywords, self.TalkCaseSensitive)
		if match and not self:Dispatch(AI.Mix(event, {
			eventType = SocialNpc.Events.OnPlayerUngreetUs,
			keyword = match
		})) then
			self:Ungreet(event.cid, SocialNpc.TalkEndReason.PlayerRequested)
			processed = true
		end
	end
	
	return processed
end

function SocialNpc:SocialOnThinkCallback(event)
	-- Proccess "afk" people
	for _, cid in ipairs(self:GetFocuses()) do
		if self:IsTalkActive(cid) and (os.clock() - self:GetFocusData(cid, self.InterestData)) > (self.MaxIdleTime / 1000) then
			self:Ungreet(cid, SocialNpc.TalkEndReason.Timedout)
		end
	end
end

function SocialNpc:ParsePlayerName(msg, cid)
	return AI.ReplaceToken(msg, self.PlayerNameToken, getCreatureName(cid))
end

function SocialNpc:SocialOnFocusCallback(event)
	self:CreateTalk(event.cid)
end

function SocialNpc:SocialOnUnfocusCallback(event)
	if event.reason == AI.FocusNpc.UnfocusReason.FocusWalkedAway then
		self:Ungreet(event.cid, event.reason, true)
	end
end

-- Register
AI.Inherit(AI.FocusNpc, SocialNpc)
AI.SocialNpc = SocialNpc
return SocialNpc