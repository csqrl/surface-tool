local FFlagsUpdatedEvent = Instance.new("BindableEvent")

local FFlags = {
    FFlagsUpdated = FFlagsUpdatedEvent.Event,

    UseTextures = false,
    -- HolesExist = false,
}

coroutine.wrap(function()
    local testPart = Instance.new("Part")

    local surfacePropertiesExist = pcall(function()
        testPart.TopSurface = Enum.SurfaceType.Studs
    end)

    -- local holeInstanceExists = pcall(function()
    --     local hole = Instance.new("Hole")
    --     hole:Destroy()
    -- end)

    testPart:Destroy()

    FFlags.UseTextures = not surfacePropertiesExist
    -- FFlags.HolesExist = holeInstanceExists

    FFlagsUpdatedEvent:Fire()
    FFlagsUpdatedEvent:Destroy()
end)()

return FFlags
