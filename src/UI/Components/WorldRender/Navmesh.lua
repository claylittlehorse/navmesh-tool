local import = shared.___navmesh_tool_import

local Roact = import "Roact"
local RoactKetchup = import "RoactKetchup"

local Line = import "./Line"
local Vertex = import "./Vertex"
local Polygon = import "./Polygon"

function NavMesh(props)
	local navMesh = props.navMesh

	if not navMesh then
		return
	end

	local children = {}

	for index, line in ipairs(navMesh.lines) do
		local vertIndexA = line.a
		local vertIndexB = line.b

		children["line_"..index] = Roact.createElement(Line, {
			pointA = navMesh.vertices[vertIndexA],
			pointB = navMesh.vertices[vertIndexB],
		})
	end

	-- for index, vertexPosition in ipairs(navMesh.vertices) do
	-- 	children["vertex_"..index] = Roact.createElement(Vertex, {
	-- 		position = vertexPosition
	-- 	})
	-- end

	for index, node in ipairs(navMesh.nodes) do
		local points = {}
		for i, vertexIndex in ipairs(node.vertices) do
			local vertexPosition = navMesh.vertices[vertexIndex]
			points[i] = vertexPosition
		end

		children["polygon_"..index] = Roact.createElement(Polygon, {
			points = points,
			transparency = 0.85,
		})
	end

	return Roact.createElement(Roact.Portal, {
		target = workspace
	}, {
		Navmesh = Roact.createElement("Folder", nil, children)
	})
end

return RoactKetchup.connect(
	function(state)
		return {
			navMesh = state.navMesh
		}
	end
)(NavMesh)
