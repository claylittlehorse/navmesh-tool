local RunService = game:GetService("RunService")

local StepChain = {}
StepChain.__index = StepChain

local function createStepChain()
	local self = {}
	self.__isStepChain = true
	self._callList = {}
	self._callListIndex = 1
	self._passedDownValues = {}
	self._passedOutValues = {}

	self._passDown = function(...)
		self._passedDownValues = table.pack(...)
		self._callListIndex = self._callListIndex + 1
	end

	self._passOut = function(...)
		self._passedOutValues = table.pack(...)
	end

	self._waitBeginTimestamp = -math.huge

	setmetatable(self, StepChain)
	return self
end

local function transplantCallList(fromStepChain, toStepChain, waitUntilNextStep)
	local fromCallList = fromStepChain._callList
	local toCallList = toStepChain._callList

	if #fromCallList == 0 then
		error("Cannot transplant empty step chain!")
	end

	-- If step chain was passed through andThenOnNextStep, change the first
	-- function in that step chain to wait until the next step.
	if waitUntilNextStep then
		fromCallList[1].waitUntilNextStep = true
	end

	for _, functionContainer in ipairs(fromCallList) do
		table.insert(toCallList, functionContainer)
	end
end

function StepChain.new(funcOrStepChain)
	assert(funcOrStepChain and funcOrStepChain ~= StepChain, "Call with ':' not '.' 😊")

	return createStepChain():andThen(funcOrStepChain)
end

function StepChain.delayedStart(interval)
	return createStepChain():wait(interval)
end

function StepChain:_andThen(funcOrStepChain, waitUntilNextStep)
	assert(funcOrStepChain, "andThen must be provided a function or another step chain!")
	assert(funcOrStepChain ~= StepChain, "Call with ':' not '.' 😊")

	if typeof(funcOrStepChain) == "function" then
		table.insert(self._callList, {func = funcOrStepChain, waitUntilNextStep = waitUntilNextStep})
	elseif typeof(funcOrStepChain) == "table" and funcOrStepChain.__isStepChain then
		transplantCallList(funcOrStepChain, self, waitUntilNextStep)
	else
		error("Invalid argument provided: must be function or step chain")
	end
end

function StepChain:andThen(funcOrStepChain)
	self:_andThen(funcOrStepChain)

	return self
end

function StepChain:andThenOnNextStep(funcOrStepChain)
	self:_andThen(funcOrStepChain, true)

	return self
end

function StepChain:wait(interval)
	self:andThen(function(passDown, passOut)
		self._waitBeginTimestamp = tick()
		passDown()
	end)
	:andThen(function(passDown, passOut)
		if tick() > self._waitBeginTimestamp + interval then
			passDown()
		end
	end)
	return self
end

function StepChain:restart()
	self:andThen(function()
		self._callListIndex = 1
	end)

	return self
end

function StepChain:step()
	repeat
		local thisIndex = self._callListIndex
		local currentContainer = self._callList[thisIndex]
		local nextContainer = self._callList[thisIndex + 1]

		currentContainer.func(self._passDown, self._passOut, table.unpack(self._passedDownValues))

		local didntPassDown = thisIndex == self._callListIndex
		local waitUntilNextStep = nextContainer and nextContainer.waitUntilNextStep
	until didntPassDown or waitUntilNextStep or not nextContainer

	return table.unpack(self._passedOutValues)
end

function StepChain:start()
	self.__heartbeatConnection = RunService.Heartbeat:Connect(function()
		self:step()
	end)
end

function StepChain:stop()
	if self.__heartbeatConnection then
		self.__heartbeatConnection:Disconnect()
	end
end

return StepChain
