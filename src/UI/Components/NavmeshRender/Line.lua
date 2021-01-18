local import = require(game.ReplicatedStorage.Lib.Import)

local Roact = import "Roact"
local t = import "t"

local Mesh = import "../Mesh"

local Line = Roact.PureComponent:extend("Line")

Line.defaultProps = {
	visible = true,

	pointA = Vector3.new(),
	pointB = Vector3.new(),

	transparency = 0.5,
	lineTransparency = 0,
	color = Color3.fromRGB(255, 255, 255),
}

Line.validateProps = t.strictInterface({
	visible = t.optional(t.boolean),

	pointA = t.Vector3,
	pointB = t.Vector3,

	transparency = t.optional(t.number),
	color = t.optional(t.Color3),
})

function Line:init()
	self.model = Instance.new("Model")
end

function Line:render()
	local props = self.props

	local ab = props.pointA - props.pointB
	local length = ab.magnitude

	local centerCf = CFrame.new(props.pointA:Lerp(props.pointB, 0.5), props.pointA)
	self.model.Parent = props.target

	local transparency = props.visible and props.transparency or 0

	return Roact.createElement("Model", {
		[Roact.Ref] = self.modelRef
	}, {
		LineCenter = Roact.createElement(Mesh, {
			importPath = "Assets/CapsuleCenter",

			size = Vector3.new(0.05, 0.05, length),
			cframe = centerCf,
			color = props.color,
			transparency = transparency,
		}),
		LineTop = Roact.createElement(Mesh, {
			importPath = "Assets/LineEnd",
			Material = Enum.Material.Neon,

			size = Vector3.new(0.2, 0.2, 0.2),
			cframe = CFrame.new(props.pointA),
			color = props.color,
			transparency = transparency,
		}),
		LineBottom = Roact.createElement(Mesh, {
			importPath = "Assets/LineEnd",

			size = Vector3.new(0.2, 0.2, 0.2),
			cframe = CFrame.new(props.pointB),
			color = props.color,
			transparency = transparency,
		}),
	})
end

return Line
