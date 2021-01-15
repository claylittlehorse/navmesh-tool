local RunService = game:GetService("RunService")
local NoYield = require(script.Parent.NoYield)
local Signal = require(script.Parent.Signal)
local None = require(script.Parent.None)

local Store = {}
Store.__index = Store
Store._flushEvent = RunService.Heartbeat

local function recursiveJoin(oldState, newState)
    for index, oldValue in pairs(oldState) do
        local newValue = newState[index]

        if not newValue then
            newState[index] = oldValue
        else
            if newValue == None then
                newState[index] = nil
            elseif typeof(newValue) == "table" and typeof(oldValue) == "table" then
                recursiveJoin(oldValue, newValue)
            end
        end
    end

    return newState
end

function Store.new(initialState)
    local self = {}

    self._state = initialState or {}
    self._lastState = self._state
    self._connections = {}
    self.changed = Signal.new()

    setmetatable(self, Store)

    local connection = self._flushEvent:Connect(function()
		self:flush()
    end)
    
	table.insert(self._connections, connection)

    return self
end

function Store:getState()
    return self._state
end

function Store:push(newState)
    self._mutatedSinceFlush = true

    self._state = recursiveJoin(self._state, newState)
end

function Store:flush()
	if not self._mutatedSinceFlush then
		return
	end

	self._mutatedSinceFlush = false

	local state = self._state

	NoYield(function()
		self.changed:fire(state, self._lastState)
	end)

	self._lastState = state
end

function Store:destruct()
	for _, connection in ipairs(self._connections) do
		connection:Disconnect()
	end

	self._connections = nil
end

return Store