-- Entrypoint to game UI

local import = shared.___navmesh_tool_import

local Roact = import "Roact"
local RoactKetchup = import "RoactKetchup"

local ImportButton = import "UI/Components/Interface/ImportButton"
local Navmesh = import "UI/Components/WorldRender/Navmesh"

Roact.setGlobalConfig({
    typeChecks = true,
	propValidation = true,
	elementTracing = true,
})

local function App(store)
	return Roact.createElement(RoactKetchup.StoreProvider, { store = store }, {
		BackgroundFrame = Roact.createElement("Frame", {
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = Color3.fromRGB(255, 231, 48),
		}, {
			ImportButton = Roact.createElement(ImportButton),
		}),
		Navmesh = Roact.createElement(Navmesh),
	})
end

return App
