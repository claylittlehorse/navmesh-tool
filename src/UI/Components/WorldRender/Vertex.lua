local import = shared.___navmesh_tool_import

local Roact = import "Roact"
local t = import "t"

local Mesh = import "./Mesh"

local Line = Roact.PureComponent:extend("Line")

Line.defaultProps = {
	visible = true,

	position = Vector3.new(),

	transparency = 0.5,
	color = Color3.fromRGB(255, 255, 255),
}

Line.validateProps = t.strictInterface({
	visible = t.optional(t.boolean),

	position = t.Vector3,

	transparency = t.optional(t.number),
	color = t.optional(t.Color3),
})

function Line:render()
	local props = self.props
	local position = props.position

	local transparency = props.visible and props.transparency or 0

	return Roact.createElement(Mesh, {
		importPath = "Assets/LineEnd",
		Material = Enum.Material.Neon,

		size = Vector3.new(0.2, 0.2, 0.2),
		cframe = CFrame.new(position),
		color = props.color,
		transparency = transparency,
	})
end

return Line
