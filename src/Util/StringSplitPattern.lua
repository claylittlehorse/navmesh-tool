-- unlike roblox's string.split is that d can be a pattern!
local function StringSplitPattern(s, d)
	local t = {}
	local i = 0
	local f
	local match = "(.-)" .. d .. "()"

	if string.find(s, d) == nil then
		return {s}
	end

	for sub, j in string.gmatch(s, match) do
		i = i + 1
		t[i] = sub
		f = j
	end

	if i ~= 0 then
		t[i + 1] = string.sub(s, f)
	end

	return t
end

return StringSplitPattern