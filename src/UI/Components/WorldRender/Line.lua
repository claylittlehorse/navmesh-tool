local import = shared.___navmesh_tool_import

local Roact = import "Roact"
local t = import "t"

local Mesh = import "./Mesh"

local Line = Roact.PureComponent:extend("Line")

Line.defaultProps = {
	visible = true,

	pointA = Vector3.new(),
	pointB = Vector3.new(),

	transparency = 0.5,
	color = Color3.fromRGB(255, 255, 255),
}

Line.validateProps = t.strictInterface({
	visible = t.optional(t.boolean),

	pointA = t.Vector3,
	pointB = t.Vector3,

	transparency = t.optional(t.number),
	color = t.optional(t.Color3),
})

function Line:render()
	local props = self.props

	local ab = props.pointA - props.pointB
	local length = ab.Magnitude

	local centerCf = CFrame.new(props.pointA:Lerp(props.pointB, 0.5), props.pointA)

	local transparency = props.visible and props.transparency or 0

	return Roact.createElement(Mesh, {
		importPath = "Assets/CapsuleCenter",

		size = Vector3.new(0.05, 0.05, length),
		cframe = centerCf,
		color = props.color,
		transparency = transparency,
	})
end

return Line
