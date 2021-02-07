local import = shared.___navmesh_tool_import

local Roact = import "Roact"
local t = import "t"
local CuteButton = import "CuteButton"
local StepChain = import "StepChain"

local AnimatedCuteButton = Roact.PureComponent:extend("AnimatedCuteButton")

AnimatedCuteButton.defualtProps = {
	fps = 7
}

AnimatedCuteButton.validateProps = t.interface({
	fps = t.number(),
	hoverFrames = t.array(t.string),
})

function AnimatedCuteButton:init(initialProps)
	self.accumulator = 0

	self.frameNum, self.updateFrameNum = Roact.createBinding(1)

	self.stepChain =
	StepChain.new(function(passDown)
		-- Advance the frame
		self.updateFrameNum(self.frameNum:getValue() % #initialProps.hoverFrames + 1)
		passDown()
	end)
	:wait(initialProps.fps / 1)
	:restart()
end

function AnimatedCuteButton:render()
	local props = self.props

	-- Inject props
	if self.state.isHovering then
		props.image = props.hoverFrames[self.state.frameNum]
	end

	props.onMouseEnter = function()
		self.accumulator = 0
		self.stepChain:start()
	end

	props.onMouseLeave = function()
		self.stepChain:stop()
	end

	return Roact.createElement(CuteButton, props)
end

function AnimatedCuteButton:willUnmount()
	self.stepChain:stop()
end

return AnimatedCuteButton
