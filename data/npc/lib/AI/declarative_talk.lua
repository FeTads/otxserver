if not AI then
	return false
end
--[[
@classname 
	AI.DeclarativeTalk
@description 
	This class is responsible for processing the AI.SocialNpc.Conversation property. 
	Think about this class as a shorthand yet more powerful version of the common msgcontains structure:
	[code]
	if msgcontains(...) then
	
	elseif msgcontains(...) then
	
	elseif topics[cid] == 1 then
	
	...
	[/code]
	
	To work with this class, all you need to do is create an AI.SocialNpc object and set its
	Conversation property with the interactions desired, and you are ready to go.
	
	And now about the syntax, there two main concepts in this pseudo syntax: conditions and actions.
	A condition is set of individual tests, that, if passed, further conditions and actions can be executed.
	An action is a set of individual operations, that if reached (i.e. a condition leads us to the action) all its operations are executed in the order they were defined. Consider the following example:
	
	[code]
	{[playerSays("quest")] = say("I have no quests for you today!")}
	[/code]
	
	This code shows one condition set, with only one test, and an action set, with one operation.
	When the AI.DeclarativeTalk executes this statement, first checks if the player said "quests", if so, then enters the action and executes the only available operation, saying "I have no quests for you today!”
	
	This may look weird to you if you have no previous experience with Lua tables, please refer to this link
	http://lua-users.org/wiki/TablesTutorial if you are having problems understanding this.
	
	We take advantage of the fact that Lua tables can have nearly every possible value types as a key (functions and tables), to describe the conditions.
	And we use the table values to describe the actions. In short: 
	
	[code]
	{[{tests}] = {operations}}
	[/code]
	
	We enclose the condition in [] because in lua you must do so if you are using types for the keys other than strings.
	
	Here's another (working) example:
	[code]
	MyNpc.Conversation = {
		{["quest|mission"] = "I have no missions for you today!"}
	}
	[/code]
	
	This time we look that there no functions involved, just plain strings. Since most of the time what you want	is to map keywords to messages, we provide this shorthand form, if there’s a string in the condition side of the expression, then its matched against what the player says, if there’s a string in the action side of the expression, then it’s simply outputted to the player. (The | in ‘quest|missions’ is an or-wildcard, look far below to know more)
	
	Knowing this we can create more complex structures:
	[code]
	MyNpc.Conversation = {
		{["quest|mission"] = "I have no missions for you today!"},
		{["job"] = "My job is amazing"},
		{["pizza"] = "Uhm."}
	}
	[/code]
	
	When processing a condition, if all test are passed, the action is executed, and every other condition that is on the same level of the former condition, is ignored. Think about this as a nested If/Else structure:
	[code]
		if msg == "quest" or msg == "mission" then
			...
		elseif msg == "job" then
		
		elseif msg == "pizza" then
		
		end
	[/code]
	
	So let’s say we are already talking to a player, the player just said "job". AI.DeclarativeTalk will do the following:
		1. Test "job" against "quest|mission", since a match can’t be found, this condition is marked as failed and the execution continues
		2. Test "job" against "job", an exact match, the condition is passed and now we start executing the actions
		3. The only action is "My job is amazing", which in turn means "say My job is amazing", we do so.
		4. There no more actions or conditions nested in the current execution path. We ended
	
	The fourth point is important since the way AI.DeclarativeTalk works allows us to nest infinitely large actions/conditions:
	
	[code]
		MyNpc.Conversation = {
			{["heal"] = { -- Nested action
				-- Nested condition
				{[greatherThan(playerHealth, 50)] = "Sorry, your not wounded enought!"}, 
				
				-- Nested 'default' condition
				{[true] = function(talk) 
					addCreatureHealth(talk.player, 100)
					return "You have been healed!"
				end}
			}}
		}
	[/code]
	
	As you can see, the code starts getting uglier the more conditions/actions we nest, but we can nest
	3-4 levels without worrying too much about it, if the thing is getting bigger, consider using AI.Talk interface	instead. The example is a bit more complex but it shows more of the features of AI.DeclarativeTalk.
	First, the use {} (tables) is what allows us to nest and stack actions/conditions. If you look closely, you will notice	that all the condition tables we have shown so far have numeric indexes. That allows you to create a flow of execution, and to make sure things won’t get screwed by randomness. Also, the use of 'greatherThan(playerHealth, 50)' and 'true' as tests show us that this class supports various kinds of Lua types for specifying conditions.
	
	Here's a complete list of types for conditions:
	Boolean - If true, the test passes, otherwise it fails.
	String - The class will try to match what the player says to this string, if success, the test passes.
	Function - The function it’s called with an AI.Talk object, a msg match if there's one, and what the players says as arguments, the returned value is checked against the condition rules.
	Table - Each VALUE of it is traversed and checked against the condition rules
	Nil - Test fails
	Other - Not supported
	
	And for actions:
	String - We output this string to the player and returns true,
	Boolean - Returns it,
	Function - The function it’s called with an AI.Talk object, a msg match if there's one, and what the players says as arguments, the returned value is checked against the action rules.
	Table - Each VALUE of it is traversed and checked against the action rules, if no operation returned false, it returns true. Otherwise as soon as a field returns false, it exits leaving the remaining operations un-executed and returning false.
	Other - Returns true
	
	If at the end of the execution, the resulting value was true (because we executed a valid set of operations successfully) the player talk timeout is reset. You can use this in your custom operations, returning false if you don’t want to refresh the timeout.

	One thing that might still look weird is the use of functions like 'greatherThan(playerHealth, 50)'. These are special functions (you can create your own) located in
	ai_stddeclarative.lua, these functions do nothing but returning another function. Yes that’s true, that’s the price we have to pay for using this kind of syntax. This is a brief implementation of greatherThan:
	[code]
	function greatherThan(a, b)
		return function()
			return AI.RawValue(a) > AI.RawValue(b) 
		end
	end
	[/code]
	
	AI.RawValue just returns the same value we pass to it if it’s of any type but a function. If it’s a function, executes it and returns what it returned.
	Since 'playerHealth' is another function, when the returned function from greatherThan is executed (i.e. when we are executing the whole conversation structure) playerHealth will be called and checked against '50'.
	So basically, the use of these condition/action functions ends up expanding at runtime, our last example looks like this actually:
	[code]
		MyNpc.Conversation = {
			{["heal"] = { 
				{[function()
					return playerHealth() > 50
				end] = "Sorry, your not wounded enought!"}, 
				
				...
			}}
		}
	[/code]
	
	One thing to remember is, condition/actions functions that have arguments are called with them right off the bat. 
	Functions with no arguments (like playerHealth) are just put there with no parenthesis.
	
	An example showing the use of multiple test and actions:
	[code]
		MyNpc.Conversation = {
			{[{"heal", isPzLocked, lessThan(playerHealth, 50)}] = {
				"HEAL POWER!",
				function(talk)
					addCreatureHealth(talk.player, 100)
				end,
				setTopic('afterHeal')
			}},
			
			{[true] = "This will execute if any of the above 3 tests fails"}
		}
	[/code]
	
	In this last example, you can see the power of the declarative syntax. Short-circuit is implemented in the	test processing, so if 'isPzLocked' fails, lessThan(..) will not execute, i.e. as soon as a test fails, the condition set is exited.
	
	There’re a few more things you can do and I haven't explained. Like breaking the if/else into 2 or more parts	for a bit more complex flow execution, but that's pretty situational or maybe even useless at this point. 
	I will explain that in a further revision.	
]]
local DeclarativeTalk = {}
local data = {}

-- Proccess an if/else block, returns true if a condition was fulfilled and an action executed successfully,
-- returns false if a condition was fulfilled but no action happened, and returns nil if no condition was acceptable
function DeclarativeTalk.ProccessIfElse(node, cid)
	for _,reply in ipairs(node) do 
		for left, right in pairs(reply) do
			if DeclarativeTalk.ProccessCondition(left, cid) then
				return DeclarativeTalk.ProcessAction(right, cid)
			end
		end		
	end
	
	return nil -- no condition match
end

-- Returns true if the condition was satisfied, false otherwise
function DeclarativeTalk.ProccessCondition(node, cid)
	local t = type(node)
	if t == "string" then
		--[[
			String parser
			"A|B|C" returns true if speech matches either A, B, or C
			"Inner {param}" returns true if speech matches the first ocurrence of a {} enclosed string
			"%" as a placeholder: "he%" will match hello, hell, hey, etc. MAX 2 PER || ENCLOSED STRING
		]]		
		for str in string.gmatch(node, "[^|]+") do			
			local original = string.match(str, "{([^}]+)") or str
			str = AI.EscapePattern(original)
			
			if data[cid].npc.TalkCaseSensitive then
				str = str:lower()
			end
			
			local match = AI.FastMatch(data[cid].msg, str:gsub("%%%%", "%%w*", 2), true)
			if match then
				data[cid].match = match
				return true
			end
		end

		return false
	elseif t == "function" then
		return DeclarativeTalk.ProccessCondition(node(data[cid].talk, data[cid].match, data[cid].msg))
	elseif t == "table" then
		for _, innerNode in ipairs(node) do
			local r = DeclarativeTalk.ProccessCondition(innerNode, cid)
			if r == false then -- short circuit
				return false
			end
		end

		return table.size(node) > 0
	elseif t == "boolean" then
		return node
	elseif t == "nil" then
		return false -- In left params, we don't tolerate nil results
	else
		error("AI.DeclarativeTalk() Can't handle conversation param of type " .. t)
	end
end

-- Returns true if we exucuted any realistic action
function DeclarativeTalk.ProcessAction(node, cid)
	local t = type(node)
	if t == "string" then
		data[cid].talk:Say(node)
		return true
	elseif t == "function" then
		return DeclarativeTalk.ProcessAction(node(data[cid].talk, data[cid].match, data[cid].msg), cid)
	elseif t == "table" then
		--[[ Handle structures such:
			ACTION
			(IF/ELSE)CONDITION
			(IF/ELSE)CONDITION
			(ELSE) CONDITION
			ACTION
			(IF/ELSE) CONDITION
			(IF/ELSE) CONDITION
			ACTION
		]]
		local ret, i, size = false, 1, table.size(node)
		-- We need to modify the control variable, hence we use a while loop instead of a for
		while(i <= size) do
			actionOrCondition = node[i]
			if type(actionOrCondition) == "table" then -- condition
				-- Here we take all the adjacent conditions(tables) and proccess them
				-- as if they were one unique node, creating an If/Else structure
				local ifElseNode, k = {}, i
				while(type(node[k]) == "table") do
					table.insert(ifElseNode, node[k])
					k = k + 1
				end
				-- If we end in a false state, we return ingnoring the remaining actions/conditions
				-- if it ends true or nil, that means the ifElse block executed and finished, we
				-- continue with the next blocks/actions
				local r = DeclarativeTalk.ProccessIfElse(ifElseNode, cid)
				if r == false then
					return false
				end

				if r == true then
					ret = true
				end

				i = k -- skip all the conditions we already proccessed
			else --action
				-- A simple action, we execute it, if the actions ends in a false state
				-- we exit ignoring the remaining actions/blocks
				local r = DeclarativeTalk.ProcessAction(actionOrCondition, cid)
				if r == false then
					return false
				end

				ret = r
			end
			
			i = i + 1
		end		
		
		return ret
	elseif t == "boolean" then
		return node
	else -- nil/numbers/whatever, we return true cuz theres no implicit "hey i want to exit!"
		return true
	end
end

function DeclarativeTalk.Process(npc, event, talk)
	if not npc.Conversation then
		return false
	end
	
	data[event.cid] = {
		npc = npc,
		msg = npc.TalkCaseSensitive and event.msg or event.msg:lower(),
		talk = talk
	}
	local processed = DeclarativeTalk.ProcessAction(npc.Conversation, event.cid)

	data[event.cid] = nil 
	return processed
end	

AI.DeclarativeTalk = DeclarativeTalk