local import = shared.___navmesh_tool_import

local t = import "t"
local Roact = import "Roact"
local Triangle = import "./Triangle"
local TriangulatePolygon = import "PluginUtil/TriangulatePolygon"

local Polygon = Roact.Component:extend("Polygon")

Polygon.defaultProps = {
	visible = true,

	transparency = 0.5,
	color = Color3.fromRGB(255, 255, 255),
}

Polygon.validateProps = t.strictInterface({
	visible = t.optional(t.boolean),

	points = t.table,

	transparency = t.optional(t.number),
	color = t.optional(t.Color3),
})


function Polygon.getDerivedStateFromProps(nextProps, lastState)
	local nextPoints = nextProps.points
	local prevPoints = lastState.points

	if not nextPoints then
		return
	end

	if prevPoints == nil or (prevPoints ~= nextPoints and #prevPoints ~= #nextPoints) then
		return {
			triangles = TriangulatePolygon(nextPoints),
			prevPoints = nextPoints,
		}
	end

	return lastState
end

function Polygon:shouldUpdate(nextProps, nextState)
	if nextProps == self.props then
		return false
	end

	if nextState ~= self.state then
		return true
	end

	for key, value in pairs(nextProps) do
		if key ~= "points" and self.props[key] ~= value then
			return true
		end
	end

	for key, value in pairs(self.props) do
		if key ~= "points" and nextProps[key] ~= value then
			return true
		end
	end

	local points = self.props.points
	if points ~= nextProps.points then
		if #points ~= #nextProps.points then
			return true
		end

		for index, oldPointPosition in ipairs(points) do
			local newPointPosition = self.props.points[index]

			if oldPointPosition ~= newPointPosition then
				return true
			end
		end
	end

	return false
end

function Polygon:render()
	local props = self.props
	local color = props.color
	local transparency = props.transparency

	local triangles = self.state.triangles

	local children = {}

	for i, triangle in ipairs(triangles) do
		children["triangle_"..i] = Roact.createElement(Triangle, {
			pointA = triangle[1],
			pointB = triangle[2],
			pointC = triangle[3],

			color = color,
			transparency = transparency,
		})
	end

	return Roact.createElement("Model", nil, children)
end

return Polygon
