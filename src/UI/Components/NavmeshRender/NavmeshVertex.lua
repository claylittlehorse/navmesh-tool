local import = shared.___navmesh_tool_import

local Roact = import "Roact"
local RoactKetchup = import "RoactKetchup"

local Vertex = import "../WorldRender/Vertex"

function NavmeshVertex(props)
	print("Vert Position:", props.position)

	return Roact.createElement(Vertex, props)
end

return RoactKetchup.connect(
	function(state, props)
		local vertIndex = props.vertexIndex
		local vertexPosition = state.navMesh.vertices[vertIndex]

		return {
			visible = props.visible,
			position = vertexPosition,
			transparency = props.transparency,
			lineTransparency = props.lineTransparency,
			color = props.color,
		}
	end
)(NavmeshVertex)
