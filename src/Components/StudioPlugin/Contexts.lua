local PluginRoot = script:FindFirstAncestor("SurfaceTool")

local Roact: Roact = require(PluginRoot.Packages.Roact)

return {
    Plugin = Roact.createContext(nil),
    Toolbar = Roact.createContext(nil),
    Menu = Roact.createContext(nil),
}
