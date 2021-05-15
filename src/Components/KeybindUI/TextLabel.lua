local PluginRoot = script:FindFirstAncestor("SurfaceTool")
local Components = PluginRoot.Components

local Roact: Roact = require(PluginRoot.Packages.Roact)
local Llama = require(PluginRoot.Packages.Llama)

local StudioSettings = require(Components.StudioSettings)

local e = Roact.createElement

function render(props)
    props = Llama.Dictionary.merge({
        active = false, -- boolean
        text = nil, -- string
        order = nil, -- number
    }, props or {})

    return StudioSettings.use(function(_, theme: StudioTheme)
        local modifier = props.active and "Selected" or "Default"

        return e("TextLabel", {
            AutomaticSize = Enum.AutomaticSize.XY,
            BackgroundColor3 = theme:GetColor("Button", modifier),
            LayoutOrder = props.order,
            Font = Enum.Font.GothamSemibold,
            Text = props.text,
            TextColor3 = theme:GetColor("ButtonText", modifier),
            TextSize = 14,
        }, {
            borderRadius = e("UICorner", {
                CornerRadius = UDim.new(0, 4),
            }),

            padding = e("UIPadding", {
                PaddingBottom = UDim.new(0, 8),
                PaddingLeft = UDim.new(0, 16),
                PaddingRight = UDim.new(0, 16),
                PaddingTop = UDim.new(0, 8),
            }),

            -- Selene doesn't know what a UIStroke is yet...
            -- selene: allow(roblox_incorrect_roact_usage)
            stroke = e("UIStroke", {
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Color = theme:GetColor("ButtonBorder", modifier),
            }),
        })
    end)
end

return render
