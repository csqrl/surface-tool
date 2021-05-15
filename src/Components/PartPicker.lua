local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local PluginRoot = script:FindFirstAncestor("SurfaceTool")
local Components = PluginRoot.Components

local Roact: Roact = require(PluginRoot.Packages.Roact)
local Llama = require(PluginRoot.Packages.Llama)
local ServiceAPI = require(PluginRoot.ServiceAPI)

local StudioPlugin = require(Components.StudioPlugin)
local StudioSettings = require(Components.StudioSettings)

local e = Roact.createElement

local Component = Roact.Component:extend("PartPicker")

Component.defaultProps = {
    plugin = nil, -- Plugin
    surfaceType = nil, -- Enum.SurfaceType
    onDismiss = nil, -- callback()
}

function Component:init()
    self.mouse = self.props.plugin:GetMouse()
    self.connections = {}

    self:setState({
        active = self.props.surfaceType ~= nil,
        target = nil,
        surface = nil,
    })

    self:bindMouseEvents()

    self.dismissPicker = function()
        if type(self.props.onDismiss) == "function" then
            self.props.onDismiss()
        end
    end
end

function Component:bindMouseEvents()
    table.insert(self.connections, self.props.plugin.Deactivation:Connect(function()
        self.dismissPicker()
    end))

    table.insert(self.connections, self.mouse.Move:Connect(function()
        if self.state.target ~= self.mouse.Target then
            self:setState({ target = self.mouse.Target })
        end

        if self.state.surface ~= self.mouse.TargetSurface then
            self:setState({ surface = self.mouse.TargetSurface })
        end
    end))

    table.insert(self.connections, self.mouse.Button1Up:Connect(function()
        ServiceAPI.ApplySurfaceTypeToPartNormal(self.props.surfaceType, self.mouse.Target, self.mouse.TargetSurface)

        if not (UserInputService:IsKeyDown("LeftShift") or UserInputService:IsKeyDown("RightShift")) then
            self.dismissPicker()
        end
    end))
end

function Component:unbindMouseEvents()
    for _, connection in ipairs(self.connections) do
        connection:Disconnect()
    end

    self.props.plugin:Deactivate()
end

function Component:didUpdate(prevProps, prevState)
    if prevProps.surfaceType ~= self.props.surfaceType then
        local isActive = self.props.surfaceType ~= nil

        if prevState.active ~= isActive then
            self:setState({ active = isActive })
        end
    end

    if prevState.action ~= self.state.active then
        if self.state.active then
            self.props.plugin:Activate(false)
        else
            self.props.plugin:Deactivate()
        end
    end
end

function Component:willUnmount()
    self:unbindMouseEvents()
end

function Component:render()
    if not self.state.target or not self.state.surface then
        return nil
    end

    if not self.state.target:IsA("BasePart") or self.state.target.Locked then
        return nil
    end

    return StudioSettings.use(function(settings: Studio)
        return e(Roact.Portal, {
            target = CoreGui,
        }, {
            surfaceSelection = e("SurfaceSelection", {
                Adornee = self.state.target,
                TargetSurface = self.state.surface,
                Color3 = settings["Active Color"],
            }),
        })
    end)
end

return function(props)
    props = props or {}

    return e(StudioPlugin.Contexts.Plugin.Consumer, {
        render = function(plugin: Plugin)
            return e(Component, Llama.Dictionary.merge(props, {
                plugin = plugin,
            }))
        end,
    })
end
