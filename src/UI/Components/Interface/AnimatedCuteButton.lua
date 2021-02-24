local import = shared.___navmesh_tool_import

local Roact = import "Roact"
local t = import "t"
local Cryo = import "Cryo"
local StepChain = import "StepChain"
local CuteButton = import "./CuteButton"

local AnimatedCuteButton = Roact.PureComponent:extend("AnimatedCuteButton")

AnimatedCuteButton.defaultProps = {
	fps = 6,
	onMouseEnter = function() end,
	onMouseLeave = function() end,
}

AnimatedCuteButton.validateProps = t.interface({
	fps = t.number,
	hoverFrames = t.array(t.string),
})

function AnimatedCuteButton:init(initialProps)
	self.frameNum, self.updateFrameNum = Roact.createBinding(1)

	self.stepChain =
		StepChain.new(function(passDown)
			-- Advance the frame
			self.updateFrameNum(self.frameNum:getValue() % #initialProps.hoverFrames + 1)
			passDown()
		end)
		:wait(1 / initialProps.fps)
		:restart()
end

function AnimatedCuteButton:render()
	local props = self.props

	local newProps = Cryo.Dictionary.join(props, {
		image = self.frameNum:map(function(frameNum)
			return props.hoverFrames[frameNum]
		end),
		onMouseEnter = function()
			self.stepChain:start()
			self.props.onMouseEnter()
		end,
		onMouseLeave = function()
			self.stepChain:stop()
			self.updateFrameNum(1)
			self.props.onMouseLeave()
		end,

		fps = Cryo.None,
		hoverFrames = Cryo.None,
	})

	return Roact.createElement(CuteButton, newProps)
end

function AnimatedCuteButton:willUnmount()
	self.stepChain:stop()
end

return AnimatedCuteButton
