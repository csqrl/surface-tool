local PluginRoot = script:FindFirstAncestor("SurfaceTool")
local Components = PluginRoot.Components

local Roact: Roact = require(PluginRoot.Packages.Roact)

local StudioPlugin = require(Components.StudioPlugin)
local TriggerButton = require(Components.SurfaceTriggerButton)
local SurfaceMenuActions = require(Components.SurfaceMenuActions)
local PartPicker = require(Components.PartPicker)

local e = Roact.createElement

local Component = Roact.Component:extend("App")

Component.defaultProps = {
    plugin = nil, -- Plugin
}

function Component:init()
    self:setState({
        menuOpen = false,
        surfaceType = nil,
    })

    self.onSurfaceActionSelected = function(_, _, surfaceType: Enum.SurfaceType?)
        self:setState({ surfaceType = surfaceType })
    end
end

function Component:render()
    return e(StudioPlugin.Menu, {
        id = "surface-selection-menu",
        open = self.state.menuOpen,

        onClose = function()
            self:setState({ menuOpen = false })
        end
    }, {
        triggerButton = e(TriggerButton, {
            active = self.state.menuOpen or self.state.surfaceType ~= nil,

            onInvoke = function()
                self:setState({ menuOpen = true })
            end,
        }),

        surfaceMenuActions = e(SurfaceMenuActions, {
            onActionInvoked = self.onSurfaceActionSelected,
        }),

        partPicker = self.state.surfaceType ~= nil and e(PartPicker, {
            surfaceType = self.state.surfaceType,
            onDismiss = function()
                self:setState({ surfaceType = Roact.None })
            end,
        }) or nil,
    })
end

return Component
