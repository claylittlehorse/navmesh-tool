local import = shared.___navmesh_tool_import

local Roact = import "Roact"
local RoactKetchup = import "RoactKetchup"

local NavmeshLine = import "./NavmeshLine"
local NavmeshVertex = import "./NavmeshVertex"

function NavMesh(props)
	local navMesh = props.navMesh

	if not navMesh then
		return
	end

	local children = {}

	for index, line in ipairs(navMesh.lines) do
		children["line_"..index] = Roact.createElement(NavmeshLine, {
			lineIndex = index
		})
	end

	for index, vertex in ipairs(navMesh.vertices) do
		children["vertex_"..index] = Roact.createElement(NavmeshVertex, {
			vertexIndex = index
		})
	end

	return Roact.createElement(Roact.Portal, {
		target = workspace
	}, {
		Navmesh = Roact.createElement("Folder", nil, children)
	})
end

return RoactKetchup.connect(
	function(state, props)
		return {
			navMesh = state.navMesh
		}
	end
)(NavMesh)
