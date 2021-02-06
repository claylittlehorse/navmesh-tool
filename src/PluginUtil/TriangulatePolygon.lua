-- This triangulation algorithm "zig-zags" triangles through the polygon, as
-- opposed to "radially sweeping" triangles. The zig-zagged triangles create
-- a better result in the final navmesh.

-- Spits out a new list of triangles from the provided list of points.

-- Algorithm assumes that the points aren't ordered randomly, that they are
-- either in a clockwise or counter-clockwise order.

-- Algorithm also assumes that all polygons are convex (this algorithm works
-- with some concave polygons, but not all.)
local function TriangulatePolygon(points)
	local triangles = {}


	if #points >= 3 then
		local aIndex = 1
		local bIndex = 2
		local cIndex

		-- This iteration algorithm is kind of hard to develop an intuition for.
		-- Here's a visual aid! https://imgur.com/a/mfxBXqm
		for _ = 1, #points - 2 do
			if not cIndex then
				cIndex = #points
			elseif cIndex > bIndex then
				aIndex, bIndex, cIndex = bIndex, cIndex, bIndex + 1
			else
				aIndex, bIndex, cIndex = bIndex, cIndex, bIndex - 1
			end

			table.insert(triangles, {points[aIndex], points[bIndex], points[cIndex]})
		end
	end

	return triangles
end

return TriangulatePolygon
