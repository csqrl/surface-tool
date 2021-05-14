local PluginRoot = script:FindFirstAncestor("SurfaceTool")

local Roact: Roact = require(PluginRoot.Packages.Roact)
local Llama = require(PluginRoot.Packages.Llama)

local Contexts = require(script.Parent.Contexts)

local e = Roact.createElement

local Component: RoactComponent = Roact.PureComponent:extend("PluginMenuAction")

Component.defaultProps = {
    menu = nil, -- PluginMenu

    id = nil, -- string
    title = nil, -- string
    icon = nil, -- string
    metadata = nil, -- any

    onClick = nil, -- callback(action: PluginAction)
}

function Component:init()
    local menu: PluginMenu = self.props.menu

    self.action = menu:AddNewAction(self.props.id, self.props.title, self.props.icon)
    self.action.Name = self.props.id

    self.action.Triggered:Connect(function()
        if type(self.props.onClick) == "function" then
            self.props.onClick(menu, self.action, self.props.metadata)
        end
    end)
end

function Component:willUnmount()
    self.action:Destroy()
end

function Component:didUpdate(prevProps)
    if prevProps.title ~= self.props.title then
        self.action.Text = self.props.title
    end

    if prevProps.icon ~= self.props.icon then
        local newAction = self.props.menu:AddNewAction(self.props.id, self.props.title, self.props.icon)

        self.action:Destroy()
        self.action = newAction
    end
end

function Component:render()
    return nil
end

return function(props)
    props = props or {}

    return e(Contexts.Menu.Consumer, {
        render = function(menu)
            return e(Component, Llama.Dictionary.merge(props, {
                menu = menu.instance,
            }))
        end,
    })
end
