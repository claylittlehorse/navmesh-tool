local import = shared.___navmesh_tool_import

local Roact = import "Roact"
local Ketchup = import "Ketchup"
local RoactKetchup = import "RoactKetchup"
local ImportNavmeshFromObj = import "PluginUtil/ImportNavmeshFromObj"
local Promise = import "Promise"
local AnimatedCuteButton = import "./AnimatedCuteButton"

local DEFAULT_COLOR = Color3.fromRGB(255, 93, 180)
local HOVER_COLOR = Color3.fromRGB(255, 0, 153)

local ImportButton = Roact.PureComponent:extend("ImportButton")

function ImportButton:init()
	self.color, self.setColor = Roact.createBinding(DEFAULT_COLOR)
end

function ImportButton:render(props)
	local pushToStore = self.props.pushToStore

    return Roact.createElement(AnimatedCuteButton, {
		anchorPoint = Vector2.new(0.5, 0.5),
		position = UDim2.fromScale(0.5, 0.5),
		color = self.color,
		size = UDim2.fromOffset(171, 171),

		fps = 7.5,
		hoverFrames = {
			"rbxassetid://6357857882",
			"rbxassetid://6357858349",
			"rbxassetid://6357861691",
			"rbxassetid://6357862020",
		},

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
		end,
		onMouseEnter = function()
			self.setColor(HOVER_COLOR)
		end,
		onMouseLeave = function()
			self.setColor(DEFAULT_COLOR)
		end
    })
end

return RoactKetchup.connect()(ImportButton)
