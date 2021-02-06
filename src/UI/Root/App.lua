-- Entrypoint to game UI

local import = shared.___navmesh_tool_import

local Roact = import "Roact"
local RoactKetchup = import "RoactKetchup"

local TestButton = import "UI/Components/Interface/ImportButton"
local Navmesh = import "UI/Components/NavmeshRender/Navmesh"

Roact.setGlobalConfig({
    typeChecks = true,
    propValidation = true,
})

local function App(store)
	return Roact.createElement(RoactKetchup.StoreProvider, { store = store }, {
		AwesomeButton = Roact.createElement(TestButton),
		Navmesh = Roact.createElement(Navmesh),
	})
end

return App
