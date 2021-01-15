-- Represents a value that is intentionally present, but should be interpreted
-- as `nil`.

local None = newproxy(true)

getmetatable(None).__tostring = function()
	return "Ketchup.None"
end

return None