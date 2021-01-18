local import = require(game.ReplicatedStorage.Lib.Import)

local Roact = import "Roact"

local Workspace = game:GetService("Workspace")
local GuiService = game:GetService("GuiService")

local insetV2 = GuiService:GetGuiInset()
local INSET = insetV2.Y

local function FullscreenViewport(props)
	return Roact.createElement("ViewportFrame", {
		Size = UDim2.new(1, 0, 1, INSET),
		Position = UDim2.new(0, 0, 0, -INSET),
		BackgroundTransparency = 1,
		Active = false,
		CurrentCamera = Workspace.CurrentCamera,
	}, props[Roact.Children])
end

return FullscreenViewport
