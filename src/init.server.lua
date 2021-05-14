local Components = script.Components
local Packages = script.Packages

local Roact: Roact = require(Packages.Roact)
local PluginFacade: RoactComponent = require(Components.PluginFacade)

local FacadeHandle: RoactTree = Roact.mount(
    Roact.createElement(PluginFacade, {
        plugin = plugin,
    }),
    nil,
    "SurfaceToolPluginHandle"
)

plugin.Unloading:Connect(function()
    Roact.unmount(FacadeHandle)
end)
