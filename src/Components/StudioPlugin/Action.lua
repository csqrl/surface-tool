local PluginRoot = script:FindFirstAncestor("SurfaceTool")

local Roact: Roact = require(PluginRoot.Packages.Roact)
local Llama = require(PluginRoot.Packages.Llama)

local Contexts = require(script.Parent.Contexts)

local e = Roact.createElement

local Component = Roact.Component:extend("PluginAction")

Component.defaultProps = {
    id = nil, -- string
    tooltip = nil, -- string
    icon = nil, -- string
    label = nil, -- string

    allowBinding = true, -- boolean

    onInvoke = nil, -- callback(void)
}

function Component:init()
    local plugin: Plugin = self.props.plugin

    self.action = plugin:CreatePluginAction(
      self.props.id,
      self.props.label,
      self.props.tooltip,
      self.props.icon,
      self.props.allowBinding
    )

    self.action.Triggered:Connect(function()
        if type(self.props.onInvoke) == "function" then
            self.props.onInvoke()
        end
    end)
end

function Component:willUnmount()
    self.action:Destroy()
end

function Component:render()
    return nil
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
