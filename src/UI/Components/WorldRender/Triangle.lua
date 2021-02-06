local import = shared.___navmesh_tool_import

local Roact = import "Roact"
local t = import "t"
local LuaGeometry = import "LuaGeometry"

local EPSILON = 1e-06

local Mesh = import "./Mesh"
local Vertex = import "./Vertex"

local Triangle = Roact.PureComponent:extend("Line")

Triangle.defaultProps = {
	visible = true,

	pointA = Vector3.new(),
	pointB = Vector3.new(),
	pointC = Vector3.new(),

	transparency = 0.5,
	color = Color3.fromRGB(255, 255, 255),
}

Triangle.validateProps = t.strictInterface({
	visible = t.optional(t.boolean),

	pointA = t.Vector3,
	pointB = t.Vector3,
	pointC = t.Vector3,

	transparency = t.optional(t.number),
	color = t.optional(t.Color3),
})

local function rightTriangle(width, length, triangleCFrame, color, transparency)
	return Roact.createElement(Mesh, {
		importPath = "Assets/RightTriangle",

		size = Vector3.new(width, 0.05, length),
		cframe = triangleCFrame,
		color = color,
		transparency = transparency,
	})
end

function Triangle:render()
	local props = self.props
	local transparency = props.visible and props.transparency or 0
	local color = props.color

	local pointA, pointB, pointC = props.pointA, props.pointB, props.pointC

	local AB, BC, CA = pointA - pointB, pointB - pointC, pointC - pointA
	local lengthAB, lengthBC, lengthCA = AB.Magnitude, BC.Magnitude, CA.Magnitude

	if lengthAB < EPSILON or lengthBC < EPSILON or lengthCA < EPSILON then
		return
	end

	local hypotenuse = math.max(lengthAB, lengthBC, lengthCA)

	-- Rearrange the points such that pointC is the furthest from the hypotenuse
	-- and A and B are the points of the hypotenuse, if this is not already the
	-- case.
	if hypotenuse == lengthBC then
		pointA, pointB, pointC = props.pointB, props.pointC, props.pointA
		AB, BC, CA = BC, CA, AB
	elseif hypotenuse == lengthCA then
		pointA, pointB, pointC = props.pointC, props.pointA, props.pointB
		AB, BC, CA = CA, AB, BC
	end

	local length = (AB:Cross(CA)).Magnitude / AB.Magnitude
	local upVector = AB:Cross(BC).unit
	local forwardVector = upVector:Cross(AB).unit
	local rightVector = AB.Unit

	local tri1Width = math.sqrt(CA.Magnitude^2 - length^2)
	local tri1Pos = pointA:Lerp(pointC, 0.5)
	local tri1CFrame = CFrame.fromMatrix(tri1Pos, rightVector, upVector, forwardVector)

	local tri2Width = math.sqrt(BC.Magnitude^2 - length^2)
	local tri2Pos = pointB:Lerp(pointC, 0.5)
	local tri2CFrame = CFrame.fromMatrix(tri2Pos, -rightVector, -upVector, forwardVector)

	return Roact.createElement("Model", nil, {
		triangle1 = rightTriangle(tri1Width, length, tri1CFrame, color, transparency),
		triangle2 = rightTriangle(tri2Width, length, tri2CFrame, color, transparency)
	})
end

return Triangle
