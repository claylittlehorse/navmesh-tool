local import = shared.___navmesh_tool_import

local Roact = import "Roact"
local RoactKetchup = import "RoactKetchup"
local ImportNavmeshFromObj = import "PluginUtil/ImportNavmeshFromObj"

local function ImportButton(props)
	local enabled = props.enabled
	local pushToStore = props.pushToStore

    local color = enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)

    return Roact.createElement("TextButton", {
        Text = "Import!",
        Position = UDim2.fromScale(0.5, 0.5),
        BackgroundColor3 = color,
        Size = UDim2.fromOffset(75, 75),
		[Roact.Event.Activated] = function()
			local navMesh = ImportNavmeshFromObj()
			pushToStore({
				navMesh = navMesh,
			})
		end
    })
end

return RoactKetchup.connect()(ImportButton)
