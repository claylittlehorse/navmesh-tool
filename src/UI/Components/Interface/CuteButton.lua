local import = shared.___navmesh_tool_import

local Roact = import "Roact"
local t = import "t"

local CuteButton = Roact.PureComponent:extend("CuteButton")

CuteButton.defaultProps = {
	visible = true,
	color = Color3.fromRGB(255, 255, 255),

	anchorPoint = Vector2.new(),
	position = UDim2.new(0, 0, 0, 0),

	onMouseEnter = function() end,
	onMouseLeave = function() end,
}

CuteButton.validateProps = t.strictInterface({
	size = t.UDim2,
	image = t.string,

	onClick = t.callback,
	onMouseEnter = t.optional(t.callback),
	onMouseLeave = t.optional(t.callback),

	visible = t.optional(t.boolean),
	color = t.optional(t.Color3),

	anchorPoint = t.optional(t.Vector2),
	position = t.optional(t.UDim2),
})


function CuteButton:render()
	local props = self.props

    return Roact.createElement("ImageButton", {
		BackgroundTransparency = 1,
		Image = props.image,
		ImageColor3 = props.color,
		AnchorPoint = props.anchorPoint,
		Position = props.position,
        Size = props.size,
		[Roact.Event.Activated] = function()
			props.onClick()
		end,
		[Roact.Event.MouseEnter] = function()
			props.onMouseEnter()
		end,
		[Roact.Event.MouseLeave] = function()
			props.onMouseLeave()
		end,
	})
end


return CuteButton
