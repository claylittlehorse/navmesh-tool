local import = require(script.Parent.Lib.Import)
local ImportAliases = require(script.Parent.ImportAliases)

import.setConfig({
    aliases = ImportAliases,
    dataModel = script.Parent
})
shared.___navmesh_tool_import = import

local Ketchup = import "Ketchup"
local CoreModules = import "CoreModules"

local coreModuleLoadOrder = {
	"PluginCore",
	"UIMount",
}

local loadedModules = {}

local store = Ketchup.Store.new({
	enabled = false,
	plugin = plugin
})

for _, moduleName in ipairs(coreModuleLoadOrder) do
	local coreModule = import("CoreModules/"..moduleName)
	coreModule.start(plugin, store)

	loadedModules[moduleName] = true
end

local unloadedModuleNames = {}
for _, module in ipairs(CoreModules:GetChildren()) do
	if not loadedModules[module.name] then
		table.insert(unloadedModuleNames, module.name)
	end
end

-- If there are unloaded modules, build a string of unloaded modules and then
-- throw an error displaying them
if #unloadedModuleNames > 0 then
	local moduleNamesString = table.concat(unloadedModuleNames, ", ")

	error("CoreModules exist but are never loaded: "..moduleNamesString)
end
