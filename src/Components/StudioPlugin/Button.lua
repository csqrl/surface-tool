local PluginRoot = script:FindFirstAncestor("SurfaceTool")

local Roact: Roact = require(PluginRoot.Packages.Roact)
local Llama = require(PluginRoot.Packages.Llama)

local Contexts = require(script.Parent.Contexts)

local e = Roact.createElement

local Component = Roact.Component:extend("PluginToolbarButton")

Component.defaultProps = {
    toolbar = nil, -- PluginToolbar

    id = nil, -- string
    tooltip = nil, -- string
    icon = nil, -- string
    label = nil, -- string

    alwaysAvailable = true, -- boolean
    enabled = true, -- boolean
    active = false, -- boolean

    onClick = nil, -- callback(void)
}

function Component:init()
    local toolbar: PluginToolbar = self.props.toolbar

    self.button = toolbar:CreateButton(
        self.props.id,
        self.props.tooltip,
        self.props.icon,
        self.props.label
    )

    self.button.ClickableWhenViewportHidden = self.props.alwaysAvailable
    self.button:SetActive(self.props.active)

    self.button.Click:Connect(function()
        if type(self.props.onClick) == "function" then
            self.props.onClick()
        end
    end)
end

function Component:willUnmount()
    self.button:Destroy()
end

function Component:didUpdate(prevProps)
    if prevProps.enabled ~= self.props.enabled then
        self.button.Enabled = self.props.enabled
    end

    if prevProps.active ~= self.props.active then
        self.button:SetActive(self.props.active)
    end

    if prevProps.alwaysAvailable ~= self.props.alwaysAvailable then
        self.button.ClickableWhenViewportHidden = self.props.alwaysAvailable
    end
end

function Component:render()
    return nil
end

return function(props)
    props = props or {}

    return e(Contexts.Toolbar.Consumer, {
        render = function(toolbar: PluginToolbar)
            return e(Component, Llama.Dictionary.merge(props, {
                toolbar = toolbar,
            }))
        end,
    })
end
