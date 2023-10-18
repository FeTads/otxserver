if not AI then
	return false
end

--[[
@classname 
	AI.DeclarativeTalk
@description 
	This class provides a topic stack based conversation handling and wrappers some common Npc-to-player conversation functions. 
There are two ways to use this class, first, every condition/action function in a AI.DeclarativeTalk gets a talk object(the same if talking to the same player) when its called. The propose of this is to ease the writing of declarative code, the talk object can be used to access common functions, like Say(), or Listen(). Other functions from this class (like Ask, AskAgreement, Response, BadResponse) are intended to be used away from AI.DeclarativeTalk, because they make use of a topic stack, unexpected behavior might occur if you mix declarative code with stack based code.
The second way to use this class, the imperative mode as I like to call it is to make use of callback functions for hear events, building the stack of topics inside them. It’s pretty easy actually:
[code]
	MyNpc.GreetReply = function(talk)
		talk:Say(“Yo son, this is your first Npc”)
		talk:AskAgreemnt(“Do you like me?”,
			function()
				talk:Say(“I know you’d to love me!”)
			end,
			function()
				talk:Say(“):”)
			end)
	end
[/code]
While this code might look harsh or difficult, you can cleanup things by creating separated functions:
[code]
	local function heLikesMe(talk)
		talk:Say(“I know you’d to love me!”)
	end
	local function heDontLikesMe(talk)
		talk:Say(“):”)
	end
	MyNpc.GreetReply = function(talk)
		talk:Say(“Yo son, this is your first Npc”)
		talk:AskAgreemnt(“Do you like me?”, heLikesMe, heDontLikesMe)
	end
[/code]
It might look tedious to create two separate functions for just replying text! You have 2 choices try with AI.DeclarativeTalk or make use of the convenient reply classes:
[code]
	MyNpc.GreetReply = function(talk)
		talk:Say(“Yo son, this is your first Npc”)
		talk:AskAgreemnt(“Do you like me?”, talk:ReplySay(“I know you’d to love me!”),  talk:ReplySay(“):”))
	end
[/code]
The way AI.Talk handles the topics has to be examined carefully. First, a topic is a question or a statement awaiting a response, the topics doesn’t have an ID or some sort of name, they just exists, like in normal conversations. When you ask something using the functions Ask and AskAgreement, a new topic is pushed into the stack, when a player says something, the topic on the top of the stack (that is, the last we pushed into the stack) is retrieved and matched. If the player said something valid (in the above case “Yes” or “Affirmative”) the topic ‘good response’ its executed (in the above case, the ‘heLikesMe’ function), otherwise (‘No’, ‘Negative’) the topic ‘bad response’ its executed.
Lets say we want to ask a player what vocation he would like to become, we might code something like this:
[code]
	talk:Ask(“Do you want to become a {Sorcerer}, {Druid}, {Paladin} or {Knight}?”)	
[/code]
The enclosed {} strings are used by Ask as ‘good responses’, so if the player answer any of those, a ‘good response’ function will be called(if any), if a player says anything else, the bad response will be called (if any).
[code]
talk:Ask(“Do you want to become a {Sorcerer}, {Druid}, {Paladin} or {Knight}?”)	
talk:Response(function(talk, vocation) 
	talk:AskAgreement(“So you want to become a “ .. vocation .. “eh? Are you sure about this?”, 
	function() -- Yes
	
	end,
	
	function -- No

	end)
end)
[/code]
Immediately after calling AI.Talk.Ask, you can call AI.Talk.Response, this will effectively add the function you pass to Response as a ‘good response’ callback. You can have any amounts of good and bad responses you want. There’s an equivalent AI.Talk.BadResponse, for filling the ‘bad responses’ callbacks.
Now we can examine better the ‘topic’ meaning, we currently have two topics on the stack, the vocation question is our first topic, the agreement question, our second one. When a player says something again, the top topic (the last topic) is pulled from the stack (is not delated thought, just used) and appropriate function responses are called. So, why do we keep the topics on the stack anyway? At any point, the player might want to change his vocation choice, and our oracle will look stupid if we start all over again (assuming we started with “ARE YOU READY!?”), in this case, we simply “go up” into our topic stack (technically the correct thing to say Is “go down in the stack” but it’s the same thing). AI.Talk.GoUp is the function that allow us to do such thing.
Now we can appropriately handle the “No , I want to change my voc” response:
[code]
talk:Ask(“Do you want to become a {Sorcerer}, {Druid}, {Paladin} or {Knight}?”)	
talk:Response(function(talk, vocation) 
	talk:AskAgreement(“So you want to become a “ .. vocation .. “eh? Are you sure about this?”, 
	function() -- Yes
	
	end,
	
	function -- No
		talk:Say(“Then, what vocation do you want to become?”)
		talk:GoUp(1) – Go to the first question WITHOUT REPEATING THE QUESTION
	end)
end)
 [/code]
Awesome, now our oracle looks smart. A similar thing happens when a player says something that doesn’t match anything in the current topic(i.e. there’s no good response match and we don’t have a bad response callback), AI.Talk will go up a max of AI.SocialNpc.GoUpTimes, trying to find an appropriate handler for what the player says. If no one is found, the player is ignored and the topic stack remains the same (unlike GoUp, this normal ‘topic finding’ procedure will not erase the topics on the stack). If the player is ignored for enough time, he might get kicked as the npc is getting bored (see AI.SocialNpc.TalkTimeout). Then player timeout isn’t refreshed when the npc says something to the player, Talk classes (like AI.Talk and AI.DeclarativeTalk) take care of refreshing the timeout. In the case of AI.Talk the talk is refreshed whenever you add new topics in any of the callback functions (i.e asking another thing like in our example), when you call AI.Talk.GoUp inside any of the callback functions and finally if you return true from any  the callback functions.
By making use of closures (http://www.lua.org/pil/6.1.html) we can keep answers from previous question in the local scope:
[code]
talk:Ask(“Do you want to become a {Sorcerer}, {Druid}, {Paladin} or {Knight}?”)	
talk:Response(function(talk, vocation) 
	talk:AskAgreement(“So you want to become a “ .. vocation .. “eh? Are you sure about this?”, 
	function() -- Yes
	end,
	
	function -- No
		talk:Say(“You don’t want to be a “ .. vocation .. “, what vocation do you want to become then?”)
		talk:GoUp(1) 
	end)
end)
 [/code]
But this is not possible if you use functions declared elsewhere like in our second example:
[code]
talk:AskAgreemnt(“Do you like me?”, heLikesMe, heDontLikesMe)
[/code]
This will have a very intuitive solution in a upcoming version, but for now you can make use of the AI.Talk.Var function to store/retrieve data inside the talk object.
If you want to end a conversation at any point, you can use talk:End(msg), if you want to stop the code in a specific point until a player says something again, use talk:Listen(), it’s a very good function but ill cover it on a upcoming review.
]]
AI.Talk = {
	--[[@method
		Creates a new Talk object, you should almost never want to use this function directly
		@params
	]]
	New = function(npc, cid) end,
	
	--[[@method
		Stores or retrieve data from this talk internal storage
		@params
		key string/number, the key of the stored data you want to retrieve or the key you want to assign to the data
		value mixed, if not nil, this function will store the data with the given key into this talk object, otherwise the operation is a retrieval
		@returns
		mixed, the stored/retrieved value
	]]
	Var = function(key, value) end,
	
	--[[@method
		Proccesses a AI.BasicNpc.Hear event, this is called automatically.
		@params
	]]
	Process = function(event) end,
	
	--[[@method
		Removes all the topics from this npc memory (stack) successfully restoring the npc to his greet state (but not greeting again)
	]]
	Reset = function() end,
	
	--[[@method
		Stops the execution of caller of this function, until the talk player says something again. This function is cleanly implemented
		and you dont need to worry about 'gotchas' or sync errors.
		@returns
		string, the text that the player just said to this talk npc
	]]
	Listen = function() end,
	
	--[[@method
		Ends the talk beetwen the npc and the player, calling the appropiate npc functions.
		@params
		[msg] string, an optional message to say 
	]]
	End = function(msg) end,
	
	--[[@method
		Says something to the talk player
		@params
		msg string, the message
	]]
	Say = function(msg) end,
	
	--[[@method
		
		@params
	]]
	Ask = function(msg) end,
	
	--[[@method
		
		@params
	]]
	AskAgreement = function(msg, fnYes, fnNo) end,
	
	--[[@method
		
		@params
	]]
	Response = function(fn) end,
	
	--[[@method
		
		@params
	]]
	BadResponse = function(fn) end,
	
	--[[@method
		
		@params
	]]
	ReplySay = function(msg) end,
	
	--[[@method
		
		@params
	]]
	ReplyEndTalk = function(msg) end,
	
	--[[@method
		
		@params
	]]
	GoUp = function(times, restream) end
}
AI.TalkTopic = {}

function AI.Talk:New(npc, cid)
	local talk = {}
	setmetatable(talk, {__index = AI.Talk})

	talk.npc = npc
	talk.player = cid
	talk.topicStack = AI.Stack:New()
	talk.varPool = {}

	return talk
end

function AI.Talk:Var(key, value)
	if type(value) == "nil" then
		return self.varPool[key]
	end

	self.varPool[key] = value
	return value
end

function AI.Talk:Process(event)
	if self.topicStack:IsEmpty() then
		return false
	end

	local msg, topic = event.msg, self.topicStack:Top()
	local match = AI.GetMatch(msg, topic.keywords, self.npc.TalkCaseSensitive)
		
	-- If we can't handle the current player speech, we try to find
	-- a handler in a previous topic, going from current topic
	-- to a maximun of npc.GoUpTimes previous topics. WE DONT
	-- WANT TO DELETE TOPICS WHILE WE FIND AN APPROPIATE HANDLER, 
	-- as if no handler is found, we simply ignore the player and
	-- wait for an appropiate response ON THE CURRENT TOPIC, or 
	-- just auto ungreet him on timeout
	if not match and table.size(topic.badResponses) == 0 and self.npc.GoUpTimes then
		local size = self.topicStack:Size()
		local minimum = size - (type(self.npcGoUpTimes) == "boolean" and size or self.npc.GoUpTimes)

		-- All loop expresions are evaluated once
		for i = size - 1, minimum < 1 and 1 or minimum, -1 do
			match = AI.GetMatch(msg, self.topicStack[i].keywords, self.npc.TalkCaseSensitive)
			if match then -- Awesome! Player is tricking us...
				for k = size - i, 1, -1 do
					self.topicStack:Pop() -- Delete topics
				end

				topic = self.topicStack:Top()
				break
			end
		end
	end
		
	local prevTopicSize = self.topicStack:Size()		
	local responses = match and topic.responses.positive or topic.responses.negative

	local continueTalk
	for _, callback in  ipairs(responses) do
		if continueTalk then
			callback(self, match)
		else
			continueTalk = callback(self, match)
		end

		-- user ended the talk
		if not self.topicStack then
			return true -- is this correct? Response: user did handle it, because he called Talk:End(). Yep, it is correct.
		end
			
		if type(continueTalk) == "boolean" and not continueTalk then
			break
		end
	end		

	-- ~= is the way to go, user might add new topics or self:GoUp() in the topick stack
	if continueTalk == nil and prevTopicSize ~= self.topicStack:Size() then
		return true
	end

	return continueTalk and true or false
end

function AI.Talk:Reset()
	self.topicStack = AI.Stack:New()
	self.varPool = {}
end

function AI.Talk:Listen()
	local self, event = coroutine.yield(true)
	return event.msg
end

function AI.Talk:End(msg)
	self.topicStack = nil
	if msg then
		self.npc:CustomUngreet(self.player, msg)
	else
		self.npc:Ungreet(self.player, AI.SocialNpc.TalkEndReason.PlayerRequested)
	end
end

function AI.Talk:Say(msg)
	self.npc:SayTo(msg, self.player)
end

function AI.Talk:Ask(msg)
	local topic = self:NewTopic()
	topic.message = msg
	topic.keywords = AI.ExtractKeywords(msg)
	self:Say(msg)
end

function AI.Talk:AskAgreement(msg, yesCallback, noCallback)
	local topic = self:NewTopic()
	topic.message = msg
	topic.keywords = self.npc.AgreementKeywords

	self:ResponseInternal(yesCallback, true)
	self:ResponseInternal(noCallback, false)
	self:Say(msg)
end

function AI.Talk:Response(callback)
	self:ResponseInternal(callback, true)
end

function AI.Talk:BadResponse(callback)
	self:ResponseInternal(callback, false)
end

function AI.Talk:ResponseInternal(callback, boolean)
	local fn = callback
	if type(callback) == "string" then
		fn = self:ReplySay(fn)
	elseif type(callback) == "boolean" and callback == false then
		fn = self:ReplyEndTalk()
	elseif type(callback) ~= "function" then
		error("AI.Talk:ResponseInternal() Parameter 1 must be a string, a false boolean, or a function")
	end

	self:GetTopic():PushResponse(fn, boolean)
end

function AI.Talk:ReplySay(msg)
	return function(talk) 
		return talk:Say(msg) 
	end
end

function AI.Talk:ReplyEndTalk(msg)
	return function(talk)
		talk:End(msg)		
	end
end

function AI.Talk:GoUp(times, announce)
	while(times > 0 and not self.topicStack:IsEmpty()) do
		times = times - 1
		self.topicStack:Pop()
	end

	assert(times == 0, "AI.Talk:GoUp() Stack underflow")
	if announce then
		self:Say(self.topicStack:Top().message)
	end
end

function AI.Talk:GetTopic()
	if self.topicStack:IsEmpty() then
		return self:NewTopic()
	end

	return self.topicStack:Top()
end

function AI.Talk:NewTopic()
	self.topicStack:Push(AI.TalkTopic:New(self))
	return self.topicStack:Top()
end

function AI.TalkTopic:New(talk)
	local topic = {}
	setmetatable(topic, {__index = AI.TalkTopic})

	topic.talk = talk
	topic.responses = {
		positive = {},
		negative = {}
	}

	return topic
end

function AI.TalkTopic:PushResponse(fn, good)
	if good then
		table.insert(self.responses.positive, fn)
	else 
		table.insert(self.responses.negative, fn)
	end
end