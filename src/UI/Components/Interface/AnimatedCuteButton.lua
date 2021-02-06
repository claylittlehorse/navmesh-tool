local import = shared.___navmesh_tool_import

local Roact = import "Roact"
local t = import "t"
local CuteButton = import "CuteButton"

local RunService = game:GetService("RunService")

local ANIMATE_FPS = 7

local AnimatedCuteButton = Roact.PureComponent:extend("AnimatedCuteButton")

AnimatedCuteButton.validateProps = t.interface({
	hoverFrames = t.array(t.string)
})

function AnimatedCuteButton:init()
	self.accumulator = 0

	self.state = {
		isHovering = false,
		frameNum = 1,
	}
end

function AnimatedCuteButton:render()
	local props = self.props

	-- Inject props
	if self.state.isHovering then
		props.image = props.hoverFrames[self.state.frameNum]
	end

	props.onMouseEnter = function()
		self.accumulator = 0
		self:setState({isHovering = true})
	end

	props.onMouseLeave = function()
		self:setState({
			isHovering = false,
			frameNum = 1
		})
	end

	return Roact.createElement(CuteButton, props)
end

function AnimatedCuteButton:didMount()
	RunService.Heartbeat:Connect(function(dt)
		if self.state.isHovering then
			self.accumulator = self.accumulator + dt

			if self.accumulator >= ANIMATE_FPS then
				self.accumulator = 0
				self:setState({
					frameNum = (self.state.frameNum % #self.props.hoverFrames) + 1
				})
			end
		end
	end)
end

return AnimatedCuteButton
