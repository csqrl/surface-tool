local PluginRoot = script:FindFirstAncestor("SurfaceTool")

local Roact: Roact = require(PluginRoot.Packages.Roact)
local Llama = require(PluginRoot.Packages.Llama)

local Contexts = require(script.Parent.Contexts)

local e = Roact.createElement

local Component: RoactComponent = Roact.PureComponent:extend("PluginMenu")

Component.defaultProps = {
    plugin = nil, -- Plugin

    id = nil, -- string
    open = false, -- boolean

    onOpen = nil, -- callback(menu: PluginMenu)
    onClose = nil, -- callback(menu: PluginMenu, result: PluginAction?)
}

function Component:init()
    local plugin: Plugin = self.props.plugin

    self.menu = plugin:CreatePluginMenu(self.props.id)

    self.open = function()
        coroutine.wrap(function()
            local result = self.menu:ShowAsync()

            if type(self.props.onClose) == "function" then
                self.props.onClose(self.menu, result)

                if self.props.show then
                    self.open()
                end
            end
        end)()

        if type(self.props.onOpen) == "function" then
            self.props.onOpen(self.menu)
        end
    end
end

function Component:didMount()
    if self.props.open then
        self.open()
    end
end

function Component:willUnmount()
    self.menu:Destroy()
end

function Component:didUpdate(prevProps)
    if self.props.open ~= prevProps.open and self.props.open == true then
        self.open()
    end
end

function Component:render()
    return e(Contexts.Menu.Provider, {
        value = {
            instance = self.menu,
            open = self.open,
        },
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
