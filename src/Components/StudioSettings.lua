local Studio: Studio = settings():GetService("Studio")
local PluginRoot = script:FindFirstAncestor("SurfaceTool")

local Roact: Roact = require(PluginRoot.Packages.Roact)

local e = Roact.createElement

local Context = Roact.createContext(nil)
local Component = Roact.Component:extend("StudioSettingsProvider")

function Component:init()
    self._changed = Studio.Changed:Connect(function()
        self:setState({})
    end)
end

function Component:didMount()
    self:setState({})
end

function Component:willUnmount()
    self._changed:Disconnect()
end

function Component:render()
    return e(Context.Provider, {
        value = {
            settings = Studio,
        },
    }, self.props[Roact.Children])
end

function Component.use(render)
    return e(Context.Consumer, {
        render = function(values)
            return render(values.settings)
        end,
    })
end

return Component
