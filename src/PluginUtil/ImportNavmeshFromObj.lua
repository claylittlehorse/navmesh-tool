local import = shared.___navmesh_tool_import

local StudioService = game:GetService("StudioService")

local StringSplitPattern = import "Util/StringSplitPattern"
local TriangulatePolygon = import "PluginUtil/TriangulatePolygon"

local function convertObjToVertsAndPolygons(objFileBinary)
	local lines = string.split(objFileBinary, "\n")
	local vertices = {}
	local polygons = {}
	for linenum, line in ipairs(lines) do
		local lineStrings = StringSplitPattern(line, "%s+")

		if lineStrings[1] == "v" then
			-- w is ignored. We're only processing polygon meshes.
			local x, y, z = tonumber(lineStrings[2]), tonumber(lineStrings[3]), tonumber(lineStrings[4])
			if not x or not y or not z then
				error("Error while parsing vertex at line " .. linenum)
			end
			table.insert(vertices, Vector3.new(-x, y, -z))
		elseif lineStrings[1] == "f" then
			local polygon = {}
			for i = 2, #lineStrings do
				if lineStrings[i] ~= "" then
					local vertexIndex = tonumber(string.split(lineStrings[i], "/")[1])
					if not vertexIndex then
						error("Error while parsing polygon at line " .. linenum)
					end
					-- negative indices relative to end of list of vertices
					vertexIndex = vertexIndex % (#vertices + 1)
					table.insert(polygon, vertexIndex)
				end
			end

			local newTris = TriangulatePolygon(polygon)
			for _, tri in ipairs(newTris) do
				table.insert(polygons, tri)
			end
		end
	end

	return vertices, polygons
end

local function createNavMesh(vertices, polygons)
	local linesDict = {}
	local lines = {}

	local navMesh = {
		nodes = {},
		lines = lines,
		vertices = vertices,
		vertexAnnotations = {}
	}

	for nodeIndex, polygon in ipairs(polygons) do
		local navMeshNode = {
			vertices = {},
			connections = {},
			annotations = {}
		}

		for i, vertexIndex in pairs(polygon) do
			-- Assign vert position value to navmesh node
			navMeshNode.vertices[i] = vertexIndex

			-- Find the line in linesDict (or create a new entry for a line)
			local nextVertexIndex = polygon[i % #polygon + 1]
			local lineKey = tostring(vertexIndex) .. "," .. tostring(nextVertexIndex)
			local inverseLineKey = tostring(nextVertexIndex) .. "," .. tostring(vertexIndex)

			local lineInfo = linesDict[lineKey] or linesDict[inverseLineKey]

			if not lineInfo then
				table.insert(lines, {a = vertexIndex, b = nextVertexIndex})

				lineInfo = {
					polygonsWithLine = {},
					lineIndex = #lines,
				}
				linesDict[lineKey] = lineInfo
			end

			-- Add the polygon to the lineDict for building connections between nodes later
			table.insert(lineInfo.polygonsWithLine, nodeIndex)
		end

		navMesh.nodes[nodeIndex] = navMeshNode
	end

	for lineKey, lineInfo in pairs(linesDict) do
		local line = lines[lineInfo.lineIndex]
		local connectedNodeIndices = lineInfo.polygonsWithLine

		-- Connect nodes
		for i, nodeIndex in ipairs(connectedNodeIndices) do
			local thisNode = navMesh.nodes[nodeIndex]
			print('>>> trying to connect!', #connectedNodeIndices)

			-- i+1 in the inner loop here makes the connection process O(n!) as
			-- opposed to O(n^2)
			for otherNodeIndexIndex = i+1, #connectedNodeIndices do
				local otherNodeIndex = connectedNodeIndices[otherNodeIndexIndex]
				local otherNode = navMesh.nodes[otherNodeIndex]

				table.insert(thisNode.connections, {
					node = otherNode,
					nodeIndex = otherNodeIndex,
					line = line,
					lineIndex = lineInfo.lineIndex,
					annotations = {},
				})

				table.insert(otherNode.connections, {
					node = thisNode,
					nodeIndex = nodeIndex,
					line = line,
					lineIndex = lineInfo.lineIndex,
					annotations = {},
				})
			end
		end
	end

	return navMesh
end

local function ImportObj()
	local objFile = StudioService:PromptImportFile({"obj"})
	if not objFile then
		return
	end

	local objFileBinary = objFile:GetBinaryContents()
	local vertices, polygons = convertObjToVertsAndPolygons(objFileBinary)
	local navMesh = createNavMesh(vertices, polygons)

	return navMesh
end

return ImportObj
