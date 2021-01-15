local import = shared.___navmesh_tool_import

local PluginCore = {}

function PluginCore.start(plugin)
    local toolbar = plugin:CreateToolbar("Navmesh Tool")
    local toggleWidgetButton = toolbar:CreateButton("toggleNavmeshDockWidget", "Toggle Navmesh Tool", "", "Navmesh Tools")
    local pluginGui = plugin:CreateDockWidgetPluginGui("Navmesh Tool", DockWidgetPluginGuiInfo.new(
        Enum.InitialDockState.Right, -- Initial dock state
        false, -- initial enabled
        false -- overrideEnabledRestore
    ))

    PluginCore.toolbar = toolbar
    PluginCore.toggleWidgetButton = toggleWidgetButton
    PluginCore.pluginGui = pluginGui

    toggleWidgetButton.Click:Connect(function()
        pluginGui.Enabled = not pluginGui.Enabled
        PluginCore.toggleWidgetButton:SetActive(pluginGui.Enabled)
    end)
end

return PluginCore