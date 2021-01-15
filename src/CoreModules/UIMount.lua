local import = shared.___navmesh_tool_import

local Roact = import "Roact"
local PluginCore = import "./PluginCore"

local App = import "UI/Root/App"

local UIMount = {}

function UIMount.start(plugin, store)
	print("mounting")
	Roact.mount(App(store), PluginCore.pluginGui, "NavmeshTool")
end

return UIMount