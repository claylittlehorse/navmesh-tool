-- Entrypoint to game UI

local import = shared.___navmesh_tool_import

local Roact = import "Roact"
local RoactKetchup = import "RoactKetchup"

local TestButton = import "UI/Components/TestButton"

local function App(store)
	return Roact.createElement(RoactKetchup.StoreProvider, { store = store }, {
		AwesomeButton = Roact.createElement(TestButton)
	})
end

return App
