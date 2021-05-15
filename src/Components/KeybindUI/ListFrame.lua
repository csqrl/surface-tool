local PluginRoot = script:FindFirstAncestor("SurfaceTool")

local Roact: Roact = require(PluginRoot.Packages.Roact)
local Llama = require(PluginRoot.Packages.Llama)

local e = Roact.createElement

function render(props)
    props = Llama.Dictionary.merge({
        direction = "x", -- "x" | "y"
        order = nil, -- number
        position = nil, -- UDim2
    }, props or {})

    return e("Frame", {
        AutomaticSize = Enum.AutomaticSize.XY,
        BackgroundTransparency = 1,
        LayoutOrder = props.order,
        Position = props.position,
    }, {
        listLayout = e("UIListLayout", {
            Padding = UDim.new(0, 8),
            FillDirection = props.direction == "x" and Enum.FillDirection.Horizontal or
                Enum.FillDirection.Vertical,
            SortOrder = Enum.SortOrder.LayoutOrder,
        }),

        children = Roact.createFragment(props[Roact.Children]),
    })
end

return render
