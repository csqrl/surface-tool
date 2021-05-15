local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local CoreGui = game:GetService("CoreGui")

local PluginRoot = script:FindFirstAncestor("SurfaceTool")

local Roact: Roact = require(PluginRoot.Packages.Roact)

local TextLabel = require(script.TextLabel)
local ListFrame = require(script.ListFrame)

local e = Roact.createElement

local Component = Roact.Component:extend("PartPicker")

Component.defaultProps = {
    show = false,
}

function Component:init()
    self.connections = {}

    self:setState({
        shift = false,
        ctrl = false,
    })

    self:bindMouseEvents()
end

function Component:bindMouseEvents()
    local modifiers = {
        ctrl = { Enum.KeyCode.LeftControl, Enum.KeyCode.RightControl },
        shift = { Enum.KeyCode.LeftShift, Enum.KeyCode.RightShift },
    }

    table.insert(self.connections, UserInputService.InputBegan:Connect(function(input: InputObject)
        if input.UserInputType == Enum.UserInputType.Keyboard then
            if table.find(modifiers.ctrl, input.KeyCode) then
                self:setState({ ctrl = true })
            elseif table.find(modifiers.shift, input.KeyCode) then
                self:setState({ shift = true })
            end
        end
    end))

    table.insert(self.connections, UserInputService.InputEnded:Connect(function(input: InputObject)
        if input.UserInputType == Enum.UserInputType.Keyboard then
            if table.find(modifiers.ctrl, input.KeyCode) then
                self:setState({ ctrl = false })
            elseif table.find(modifiers.shift, input.KeyCode) then
                self:setState({ shift = false })
            end
        end
    end))
end

function Component:willUnmount()
    for _, connection in ipairs(self.connections) do
        connection:Disconnect()
    end
end

function Component:render()
    return e(Roact.Portal, {
        target = CoreGui,
    }, {
        surfaceToolKeybindsUI = e("ScreenGui", {
            ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
            Enabled = self.props.show == true,
        }, {
            keybindContainer = e(ListFrame, {
                position = UDim2.fromOffset(16, 16),
                direction = "y",
            }, {
                shiftRow = e(ListFrame, {
                    direction = "x",
                    order = 0,
                }, {
                    keybind = e(TextLabel, {
                        active = self.state.shift,
                        text = "SHIFT",
                    }),

                    info = e(TextLabel, {
                        active = self.state.shift,
                        text = "Continuous application",
                        order = 10,
                    }),
                }),

                ctrlRow = e(ListFrame, {
                    direction = "x",
                    order = 10,
                }, {
                    keybind = e(TextLabel, {
                        active = self.state.ctrl,
                        text = GuiService.IsWindows and "CTRL" or "⌘ CMD",
                    }),

                    info = e(TextLabel, {
                        active = self.state.ctrl,
                        text = "Apply all sides",
                        order = 10,
                    }),
                })
            })
        }),
    })
end

return Component
