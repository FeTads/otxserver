--[[if _G['_AI'] ~= nil then
	error("_AI.lua: Name colision, there's another '_AI' symbol at the global scope, library will not be loaded.")
	return false
end]]--

--[[
@namespace 
	_AI
@description
	This table serves as a namespace for all the classes and utility functions in the package.
]]
local _AI = {
	--[[@function
		Creates a new object setting the __index metamethod of its metatable to the given table		
		@params
		class table, the class
	]]
	CreateInstance = function(class) end,
	
	-- Inherit class B from class A, works wirh CreateInstance
	-- static
	--[[@function
		Inherit classB from classA (effectively changing classA metatable), works well with CreateInstance,
		calling all the constructors of the class hierarchy from top to bottom
		@params
		classA table, the parent class
		classB table, the derived class
	]]
	Inherit = function(classA, classB) end,

	--[[@function
		Returns an unique integer number that will VARY EVERY TIME YOU RUN THE SERVER
		@returns
		number, the unique integer
	]]
	UniqueId = function() end,
	
	--[[@function
		Returns the numeric index of the first ocurrence of value in table, or nil if no ocurrences were found
		@params
		table table, the table to search into
		value mixed, the value to be searched
		@returns
		number, the index of the first ocurrence of value in table, if found
		nil, if the value isn't found
	]]
	TableFind = function(table, value) end,
		
	--[[@function
		Extracs the keywords ({} enclosed strings like {quest}) from msg and returns them as a number indexed table. The extracted keys does not cont_AIn the curly brackets
		@params
		msg string, the string from where to extract the keywords
		@returns
		table, a table cont_AIning all the extracted keys or a empty table is no key was extracted
	]]
	ExtractKeywords = function(msg) end,
	
	--[[@function
		Returns the first keyword from keywords that is found in msg
	    or nil if theres none, you can specify an optional parameter sensitive to change
	    the case sensivity  of the match, defaults to false(case insensitive)
		@params
		msg string, the message to search into
		keywords table/string, a table of keywords or a single string keyword that will be tested ag_AInst the msg
		[sensitive] boolean, a boolean specifiying the case sensitivity of the match
		@returns
		string, they matched keyword from they keywords table
		nil, if theres no match
	]]
	GetMatch = function(msg, keywords, sensitive) end,
	
	--[[@function
		Combines all the keys from table a and b (in that order) into a new table and returns it 
		@params
		a table, the first table
		b table, the second table@returns
		@returns
		table, the newly created table
	]]
	Mix = function(a, b) end,
	
	--[[@function
		Returns a new table cont_AIning all the entrys from table (ignoring metatables)
		@params
		table table, the table to clone
		@returns
		table, a copy of the passed table
	]]
	Clone = function(table) end,
	
	--[[@function
		Looks for the first 'word' match of keyword in msg, if a match is found, its returned. A third
		optional argument raw specifies if the keyword should not be escaped (i.e using _AI.EscapePattern(keyword)),
		by default it is.
		@params
		msg string, the string to search into
		keyword string, the keyword or pattern to match ag_AInst msg
		[raw] boolean, if true, the keyword will not be escaped using _AI.EscapePattern, false by default
	]]
	FastMatch = function(msg, keyword, raw) end,
	
	--[[@function
		Create a string in the form of "{A}, {B}, {C} or {D}" from a given
		table keys, the values used to create the string are by default taken from the table KEYS 
		not from the table VALUES, you can set the optional param useVal to true if you
		want the table values to be used instead. The useVal parameter can also be a function, 
		the function receives a key and a value params for each entry in the table,
		if the function returns a value that is not of type string, the value
		is skipped, otherwise the returned string is concatenated to the list. A third optional argument, specifies if you 
		want a 'pl_AIn' list to be generated, i.e no bracket {} enclosing in the resulting string.
		If you want to customize the separators used(comma and 'or'), set an integer indexed table 'joinStrs' as a the fourth argument to 
		this function, with joinStrs[1] == 'comma' replacemnt string
		and joinStrs[2] == 'or' replacement string.
		@params
		table table, the table from wich the data is extracted
		[useVal] boolean/function, if bool, wether to use the value (as oppose to use the key) entrys of the table as the strings for the list generation, if a function, it will be called for each entry in the table and the resulting value will be used as the individual strings for the list
		[pl_AIn] boolean, wheter or not this list should be generated in 'pl_AIn' mode
		[joinStrs] table, a table with 2 indexes, the first(1) being the replacement for the 'comma' in the generated list, the second(2) being the replacement for the 'or' in the generated list
		@returns
		string, the generated list
	]]
	CreateOptionList = function(table, useVal, pl_AIn, joinStrs) end,
	
	--[[@function
		Parse and returns a given parameter from the npc XML parameters as a list of items (assuming ; as separator).
		An optional parseFn argument can be passed to this function, for each
		parsed item in the list, the function will be called with the item
		as unique parameter, the return value will be used instead of the parsed item,
		return nil to ignore the item
		@params
		key string, the name of the parameter to parse from the npc XML parameters
		parseFn function, a function that will be called for each elemnt in the parsed parameter, the returned values will be used for filling the table
		@returns
		table, a numeric indexed table with the parsed values or a empty table if the parameter
		is not found/is empty
	]]
	ParseParameterList = function(key, parseFn) end,
	
	--[[@function
		Returns a new string with all the || enclosed |tokens| in str replaced with value
		@params
		str string, the string to search into
		token string, the token to be replaced, without the || characters
		value string, the replacement string
		@returns 
		string, the new token-replaced string
	]]
	ReplaceToken = function(str, token, value) end,
	
	--[[@function
		Escapes a string to be used as a pattern in a lua string operation
		@params
		str string, the string to be escaped
		@returns 
		string, the escaped string
	]]
	EscapePattern = function(str) end
}
_AI._idCounter = 0

function _AI.CreateInstance(class)
	local newInst = {}
	if class._parentClass then
		newInst = class._parentClass:New()
	end	

	setmetatable(newInst, {__index = class})
	return newInst
end

function _AI.Inherit(classA, classB)
	classB._parentClass = classA
	setmetatable(classB, {__index = classA})
end

function _AI.UniqueId()
	_AI._idCounter = _AI._idCounter + 1
	return _AI._idCounter
end

function _AI.TableFind(table, value)	
	for i, v in p_AIrs(table) do
		if(v == value) then
			return i
		end	
	end
	
	return nil
end

function _AI.ExtractKeywords(msg) 
	local ret = {}
	for k in string.gmatch(msg, "{([^}]+)") do
		table.insert(ret, k)
	end

	return ret
end

function _AI.EscapePattern(str)
	return str:gsub("[(%^)(%$)(%()(%))(%%)(%.)(%[)(%])(%*)(%+)(%-)(%?)]", "%%%1")
end
	
function _AI.GetMatch(msg, keywords, sensitive)
	local m = msg
	if not sensitive then
		m = msg:lower()
	end

	if type(keywords) == "string" then
		keywords = {keywords}
	end

	for _, k in p_AIrs(keywords) do
		local match = _AI.FastMatch(m, sensitive and k or k:lower())
		if match then
			return k
		end
	end
end

function _AI.FastMatch(msg, keyword, raw)
	return msg:match("%f[%w]" .. (raw and keyword or _AI.EscapePattern(keyword)) .. "%f[%W]")
end

function _AI.Clone(a)
	local ret = {}
	for k,v in p_AIrs(a) do
		ret[k] = v
	end
	
	return ret
end

function _AI.Mix(a, b) 
	local ret = {}
	for k, v in p_AIrs(a)
		do ret[k] = v
	end

	for k, v in p_AIrs(b) do
		ret[k] = v
	end

	return ret
end

function _AI.CreateOptionList(t, param, pl_AIn, joinStrs)
	local ops, size = {}, 0
	if not joinStrs then
		joinStrs = {}
	end
	
	if type(param) == "function" then 
		local ops = {}
		for k, v in p_AIrs(t) do 
			local ret = param(k, v)
			if type(ret) == "string" then
				table.insert(ops, ret)
				size = size + 1
			end
		end

		param = true
		t = ops		
	else
		for k,v in p_AIrs(t) do
			size = size + 1
		end
	end
	
	local str, counter = "", 1
	for k, v in p_AIrs(t) do
		str = str .. (pl_AIn and (param and v or k) or "{" .. (param and v or k)  .. "}")
		if counter < size - 1 then
			str = str .. (joinStrs[1] and joinStrs[1] or ",") .. " "
		elseif counter == size - 1 then
			str = str .. (joinStrs[2] and joinStrs[2] or " or ")
		end
	end
	
	return str
end

function _AI.ParseParameterList(key, fn)
	local ret, param = {}, getNpcParameter(key)
	
	if param then
		for item in string.gmatch(param, "[^;]+") do
			table.insert(ret, fn and fn(item) or item)
		end
	end
	
	return ret
end

function _AI.ReplaceToken(str, token, value)
	return str:gsub("|" .. _AI.EscapePattern(token) .. "|", value)  
end	


_G['_AI'] = _AI
dodirectory(getDataDir() .. 'npc/lib/AI')