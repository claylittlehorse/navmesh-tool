local import = shared.___navmesh_tool_import

local Roact = import "Roact"
local Ketchup = import "Ketchup"
local RoactKetchup = import "RoactKetchup"
local ExportNavmeshToScript = import "PluginUtil/ExportNavmeshToScript"
local Promise = import "Promise"
local AnimatedCuteButton = import "./AnimatedCuteButton"

local function ExportButton(props)
	local enabled = props.enabled
	local navMesh = props.navMesh
	local plugin = props.plugin

	if not navMesh then
		return
	end

    -- local color = enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)

    return Roact.createElement(AnimatedCuteButton, {
		anchorPoint = Vector2.new(0.5, 0.5),
		position = UDim2.fromScale(0.75, 0.5),
		color = Color3.fromRGB(255, 0, 153),
		size = UDim2.fromOffset(172, 155),

		hoverFrames = {"rbxassetid://6356480655", "rbxassetid://6356199285"},
		image = "rbxassetid://6356480655",

		onClick = function()
			ExportNavmeshToScript(navMesh, plugin)
		end
    })
end

return RoactKetchup.connect(
	function(state)
		return {
			navMesh = state.navMesh,
			plugin = state.plugin
		}
	end
)(ExportButton)
