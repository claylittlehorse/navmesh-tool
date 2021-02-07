local SCRIPT_TEMPLATE =
[[local navMesh = {
	verts = {%s},
	vertAnnotations = {%s},
	lines = {%s},
	nodes = {%s}
}

return navMesh
]]

local VERT_TEMPLATE = "		{x = %s, y = %s, z = %s},\n" -- Position
local VERT_ANNOTATIONS_TEMPLATE =
[[		{
			annotations = {%s},
			index = %d,
		},
]]
local LINE_TEMPLATE =
[[		{%d, %d},
]]

local NODE_TEMPLATE =
[[		{
			vertices = {%s},
			annotations = {%s},
			connections = {%s}
		},
]]
local CONNECTION_TEMPLATE =
[[				{
					nodeIndex = %d,
					lineIndex = %d,
					annotations = {%s}
				},
]]

local function listOutItems(list)
	local itemsString = ""
	for index, item in ipairs(list) do
		local comma = index < #list and ", " or ""
		itemsString = itemsString..item..comma
	end
	return itemsString
end

local function createScriptString(navMesh)
	local vertString = ""
	if #navMesh.vertices > 0 then
		vertString = vertString.."\n"
		for _, vertex in ipairs(navMesh.vertices) do
			vertString = vertString .. string.format(VERT_TEMPLATE, tostring(vertex.X), tostring(vertex.Y), tostring(vertex.Z))
		end
		vertString = vertString.."	"
	end

	local vertAnnotationsString = ""
	if #navMesh.vertexAnnotations > 0 then
		vertAnnotationsString = vertAnnotationsString .."\n"
		for _, annotationInfo in ipairs(navMesh.vertexAnnotations) do
			local annotationsString = listOutItems(annotationInfo.annotations)
			vertAnnotationsString = vertAnnotationsString..string.format(VERT_ANNOTATIONS_TEMPLATE, annotationsString, annotationInfo.vertIndex)
		end
		vertAnnotationsString = vertAnnotationsString.."	"
	end

	local linesString = ""
	if #navMesh.lines > 0 then
		linesString = linesString.."\n"
		for _, line in ipairs(navMesh.lines) do
			linesString = linesString..string.format(LINE_TEMPLATE, line.a, line.b)
		end
		linesString = linesString.."	"
	end

	local nodesString = ""
	if #navMesh.nodes > 0 then
		nodesString = nodesString.."\n"
		for _, node in ipairs(navMesh.nodes) do
			local verticesString = listOutItems(node.vertices)
			local annotationsString = listOutItems(node.annotations)
			local connectionsString = ""
			if #node.connections > 0 then
				connectionsString = connectionsString.."\n"
				for _, connection in ipairs(node.connections) do
					local connectionAnnotationsString = listOutItems(connection.annotations)
					connectionsString = connectionsString..string.format(CONNECTION_TEMPLATE, connection.nodeIndex, connection.lineIndex, connectionAnnotationsString)
				end
				connectionsString = connectionsString.."			"
			end
			nodesString = nodesString..string.format(NODE_TEMPLATE, verticesString, annotationsString, connectionsString)
		end
		nodesString = nodesString.."	"
	end

	local scriptString = string.format(SCRIPT_TEMPLATE, vertString, vertAnnotationsString, linesString, nodesString)
	return scriptString
end

local function ExportNavmeshToScript(navMesh, plugin)
	local scriptSourceString = createScriptString(navMesh)

	local navmeshScript = Instance.new("ModuleScript")
	navmeshScript.Name = "Navmesh"
	navmeshScript.Parent = workspace
	navmeshScript.Source = scriptSourceString
	plugin:OpenScript(navmeshScript)
end

return ExportNavmeshToScript
