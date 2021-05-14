local PluginRoot = script:FindFirstAncestor("SurfaceTool")
local Components = PluginRoot.Components

local Roact: Roact = require(PluginRoot.Packages.Roact)

local StudioPlugin = require(Components.StudioPlugin)

local e = Roact.createElement

local Component = Roact.Component:extend("PluginFacade")

Component.defaultProps = {
    plugin = nil, -- Plugin
}

function Component:render()
    return e(StudioPlugin.Contexts.Plugin.Provider, {
        value = self.props.plugin,
    }, {
        toolbar = e(StudioPlugin.Toolbar, {
            name = "Appearance",
        }, {
            widgetToggle = e(StudioPlugin.Button, {
                id = "csqrl.surface-tool.button.main",
                tooltip = "Changes the surface input of a part's surface",
                icon = "rbxassetid://6814157597",
                label = "Surface",
                active = false,
                onClick = self.pluginButtonInvoked,
            }),
        }),
    })
end

return Component
