local PluginRoot = script:FindFirstAncestor("SurfaceTool")
local Components = PluginRoot.Components

local Roact: Roact = require(PluginRoot.Packages.Roact)

local StudioPlugin = require(Components.StudioPlugin)

local e = Roact.createElement

local Component = Roact.Component:extend("SurfaceTriggerButton")

Component.defaultProps = {
    active = false, -- boolean
    onInvoke = nil, -- callback
}

function Component:render()
    return Roact.createFragment({
        button = e(StudioPlugin.Button, {
            id = "csqrl.surface-tool.button.main",
            tooltip = "Changes the surface input of a part's surface",
            icon = "rbxassetid://6814748754",
            label = "Surface",
            active = self.props.active,
            onClick = self.props.onInvoke,
        }),

        action = e(StudioPlugin.Action, {
            id = "csqrl.surface-tool.action.main",
            tooltip = "Changes the surface input of a part's surface",
            icon = "rbxassetid://6814748754",
            label = "Surface Tool (Action)",
            onInvoke = self.props.onInvoke,
        }),
    })
end

return Component
