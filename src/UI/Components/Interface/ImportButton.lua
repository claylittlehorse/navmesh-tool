local import = shared.___navmesh_tool_import

local Roact = import "Roact"
local Ketchup = import "Ketchup"
local RoactKetchup = import "RoactKetchup"
local ImportNavmeshFromObj = import "PluginUtil/ImportNavmeshFromObj"
local Promise = import "Promise"
local AnimatedCuteButton = import "./AnimatedCuteButton"

local function ImportButton(props)
	local enabled = props.enabled
	local pushToStore = props.pushToStore

    -- local color = enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)

    return Roact.createElement(AnimatedCuteButton, {
		anchorPoint = Vector2.new(0.5, 0.5),
		position = UDim2.fromScale(0.5, 0.5),
		color = Color3.fromRGB(255, 0, 153),
		size = UDim2.fromOffset(172, 155),

		hoverFrames = {"rbxassetid://6356480655", "rbxassetid://6356199285"},
		image = "rbxassetid://6356480655",

		onClick = function()
			local navMesh = ImportNavmeshFromObj()

			if navMesh then
				pushToStore({
					navMesh = Ketchup.None,
				})
				Promise.defer(function()
					pushToStore({
						navMesh = navMesh,
					})
				end)
			end
		end
    })
end

return RoactKetchup.connect()(ImportButton)
