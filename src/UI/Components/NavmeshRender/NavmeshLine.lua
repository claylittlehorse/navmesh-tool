local import = shared.___navmesh_tool_import

local Roact = import "Roact"
local RoactKetchup = import "RoactKetchup"

local Line = import "../WorldRender/Line"

function NavmeshLine(props)
	return Roact.createElement(Line, props)
end

return RoactKetchup.connect(
	function(state, props)
		local lineIndex = props.lineIndex
		local line = state.navMesh.lines[lineIndex]

		local vertIndexA = line.a
		local vertIndexB = line.b

		print("Line vert index a:", vertIndexA, "b:", vertIndexB)
		local pointA = state.navMesh.vertices[vertIndexA]
		local pointB = state.navMesh.vertices[vertIndexB]
		print("Line vert position a:", pointA, "b:", pointB)

		return {
			visible = props.visible,
			pointA = pointA,
			pointB = pointB,
			transparency = props.transparency,
			lineTransparency = props.lineTransparency,
			color = props.color,
		}
	end
)(NavmeshLine)
