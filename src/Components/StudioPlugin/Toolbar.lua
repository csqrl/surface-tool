local PluginRoot = script:FindFirstAncestor("SurfaceTool")

local Roact: Roact = require(PluginRoot.Packages.Roact)
local Llama = require(PluginRoot.Packages.Llama)

local Contexts = require(script.Parent.Contexts)

local e = Roact.createElement

local Component: RoactComponent = Roact.Component:extend("PluginToolbar")

Component.defaultProps = {
    plugin = nil, -- Plugin

    name = nil, -- string
}

function Component:init()
    local plugin: Plugin = self.props.plugin

    self.toolbar = plugin:CreateToolbar(self.props.name)
end

function Component:willUnmount()
    self.toolbar:Destroy()
end

function Component:didUpdate(prevProps)
    if prevProps.name ~= self.props.name then
        self.toolbar.Name = self.props.name
    end
end

function Component:render()
    return e(Contexts.Toolbar.Provider, {
        value = self.toolbar,
    }, self.props[Roact.Children])
end

return function(props)
    props = props or {}

    return e(Contexts.Plugin.Consumer, {
        render = function(plugin: Plugin)
            return e(Component, Llama.Dictionary.merge(props, {
                plugin = plugin,
            }))
        end,
    })
end
