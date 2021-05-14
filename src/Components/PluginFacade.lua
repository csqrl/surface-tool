local PluginRoot = script:FindFirstAncestor("SurfaceTool")
local Components = PluginRoot.Components

local Roact: Roact = require(PluginRoot.Packages.Roact)

local StudioPlugin = require(Components.StudioPlugin)
local StudioSettings = require(Components.StudioSettings)
local App = require(Components.App)

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
            studioSettingsProvider = e(StudioSettings, nil, {
                surfaceMenu = e(App),
            }),
        }),
    })
end

return Component
