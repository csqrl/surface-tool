local PluginRoot = script:FindFirstAncestor("SurfaceTool")
local Components = PluginRoot.Components

local Roact: Roact = require(PluginRoot.Packages.Roact)
local ServiceAPI = require(PluginRoot.ServiceAPI)

local StudioPlugin = require(Components.StudioPlugin)

local e = Roact.createElement

local Component = Roact.Component:extend("SurfaceMenuActions")

Component.defaultProps = {
    onActionInvoked = nil, -- callback(menu: PluginMenu, action: PluginAction, metadata: any)
}

function Component:render()
    local menuActions = {}

    for index, surfaceEnum in ipairs(Enum.SurfaceType:GetEnumItems()) do
        local itemTitle = string.sub(string.gsub(surfaceEnum.Name, "%u", " %1"), 2)

        menuActions[index] = e(StudioPlugin.MenuAction, {
            id = surfaceEnum.Name,
            title = itemTitle,
            icon = ServiceAPI.GetIconFromSurfaceType(surfaceEnum),
            metadata = surfaceEnum,
            onClick = self.props.onActionInvoked,
        })
    end

    return Roact.createFragment(menuActions)
end

return Component
