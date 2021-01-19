local import = shared.___navmesh_tool_import

local StudioService = game:GetService("StudioService")

local StringSplitPattern = import "Util/StringSplitPattern"

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
			table.insert(polygons, polygon)
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
	}

	for nodeIndex, polygon in ipairs(polygons) do
		local navMeshNode = {
			vertices = {},
			nodeConnections = {},
			annotations = {}
		}

		for i, vertexIndex in pairs(polygon) do
			-- Assign vert position value to navmesh node
			navMeshNode.vertices[i] = vertexIndex

			-- Find the line in linesDict (or create a new entry for a line)
			local nextVertexIndex = polygon[i % #polygon + 1]
			local lineKey = tostring(vertexIndex) .. "," .. tostring(nextVertexIndex)
			local inverseLineKey = tostring(nextVertexIndex) .. "," .. tostring(vertexIndex)

			local polygonsWithLine = linesDict[lineKey] or linesDict[inverseLineKey]

			if not polygonsWithLine then
				polygonsWithLine = {}
				table.insert(lines, {a = vertexIndex, b = nextVertexIndex})

				linesDict[lineKey] = {
					polygonsWithLine = polygonsWithLine,
					lineIndex = #lines,
				}
			end

			-- Add the polygon to the lineDict for building connections between nodes later
			table.insert(polygonsWithLine, nodeIndex)
		end

		navMesh.nodes[nodeIndex] = navMeshNode
	end

	for lineKey, lineInfo in ipairs(linesDict) do
		local line = lines[lineInfo.lineIndex]
		local connectedNodeIndices = lineInfo.polygonsWithLine

		-- Connect nodes
		for i, nodeIndex in ipairs(connectedNodeIndices) do
			local thisNode = navMesh[nodeIndex]

			-- i+1 in the inner loop here makes the connection process O(n!) as
			-- opposed to O(n^2)
			for otherNodeIndex = i+1, #connectedNodeIndices do
				local otherNode = navMesh[otherNodeIndex]

				table.insert(thisNode.nodeConnections, {
					node = otherNode,
					line = line,
					annotations = {},
				})

				table.insert(otherNode.nodeConnections, {
					node = thisNode,
					line = line,
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
