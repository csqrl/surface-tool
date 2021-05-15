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

    self._themeChanged = Studio.ThemeChanged:Connect(function()
        self:setState({})
    end)
end

function Component:didMount()
    self:setState({})
end

function Component:willUnmount()
    self._changed:Disconnect()
    self._themeChanged:Disconnect()
end

function Component:render()
    return e(Context.Provider, {
        value = {
            settings = Studio,
            theme = Studio.Theme,
        },
    }, self.props[Roact.Children])
end

function Component.use(render)
    return e(Context.Consumer, {
        render = function(values)
            return render(values.settings, values.theme)
        end,
    })
end

return Component
