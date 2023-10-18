if not AI then
	return false
end

local Stack = {}
local PriorityQueue = {}
local function lessThan(a, b) return a < b end

-- Stack
function Stack:New()
	local stack = {}
	setmetatable(stack, {__index = Stack})
	return stack
end

function Stack:Push(v)
	table.insert(self, v)
end

function Stack:Pop()
	local val = self[table.size(self)]
	table.remove(self)
	return val
end

function Stack:Top()
	return self[table.size(self)]
end

function Stack:Size()
	return table.size(self)
end

function Stack:IsEmpty()
	return table.size(self) == 0
end 

--  Queue
--[[function Queue:New()
	local queue = {}
	setmetatable(queue, {__index = Queue})
	return queue
end

function Queue:Push(v)
	table.insert(self, v) 
end

function Queue:Pop()
	local v = self[1]
	table.remove(self, 1)
	return v
end

function Queue:Size()
	return #self
end

function Queue:Top()
	return self[1]
end

function Queue:IsEmpty()
	return #self == 0
end ]]

-- Priority Queue
local function upi(h, lt, obj, i)
	local j = math.floor(i / 2)
	local hj = h[j]

	while j > 0 and lt(obj, hj) do
		h[i] = hj
		i, j = j, math.floor(j / 2)
		hj = h[j]
	end

	h[i] = obj
end

local function downi(h, lt, obj, i, n)
	local j = i * 2
	while j <= n do
		local hj = h[j]
		if j < n then
			local hj1 = h[j + 1]
			if lt(hj1, hj) then
				j = j + 1
				hj = hj1
			end
		end
		
		if lt(obj, hj) then
			break
		end
		
		h[i] = hj
		i = j
		j = j * 2
	end
	
	h[i] = obj
end

function PriorityQueue:New(lt)
	local heap = { compareCallback = lt or lessThan }
	setmetatable(heap, {__index = PriorityQueue})
	return heap
end

function PriorityQueue:Top()
	return self[1]
end

function PriorityQueue:Push(v)
	return upi(self, self.compareCallback, v, table.size(self) + 1)
end

function PriorityQueue:Pop()
	local size = table.size(self)
	assert(size > 0, "PriorityQueue:Pop() Heap is empty")

	local ret = self[1]
	if size > 1 then
		local last = self[size]
		self[1] = last 
		self[size] = nil
		downi(self, self.compareCallback, last, 1, size - 1)
	else
		self[1] = nil
	end

	return ret
end

function PriorityQueue:Size()
	return table.size(self)
end

function PriorityQueue:IsEmpty()
	return table.size(self) == 0
end


-- Register
AI.Stack = Stack
AI.PriorityQueue = PriorityQueue