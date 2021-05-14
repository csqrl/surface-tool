type EnumValue<T> = (string | number | T)

local ChangeHistory = game:GetService("ChangeHistoryService")
local Service = {}

local fmt = string.format

local icons = {
    [Enum.SurfaceType.Glue] = "rbxassetid://133619761",
    [Enum.SurfaceType.SmoothNoOutlines] = "rbxassetid://133619617",
    [Enum.SurfaceType.SteppingMotor] = "",
    [Enum.SurfaceType.Studs] = "rbxassetid://133619576",
    [Enum.SurfaceType.Universal] = "rbxassetid://133619554",
    [Enum.SurfaceType.Smooth] = "rbxassetid://133619617",
    [Enum.SurfaceType.Inlet] = "rbxassetid://133619724",
    [Enum.SurfaceType.Motor] = "",
    [Enum.SurfaceType.Hinge] = "",
    [Enum.SurfaceType.Weld] = "rbxassetid://133619512",
}

function Service.GetIconFromSurfaceType(surfaceType: EnumValue<Enum.SurfaceType>): string
    surfaceType = Service.ResolveEnumable(surfaceType)
    local icon = icons[surfaceType]
    return icon
end

function Service.FormatEnumName(value: EnumValue<Enum.SurfaceType>): string
    value = Service.ResolveEnumable(value)
    return string.sub(string.gsub(value.Name, "%u", " %1"), 2)
end

function Service.ResolveEnumable(value: EnumValue<EnumItem>, enumBase: Enum): EnumItem
    if typeof(value) == "EnumItem" then
        return value
    end

    return enumBase[value]
end

function Service.GetSurfacePropertyFromNormalId(normal: EnumValue<Enum.NormalId>)
    normal = Service.ResolveEnumable(normal)

    if normal == Enum.NormalId.Back then
        return "BackSurface"
    elseif normal == Enum.NormalId.Left then
        return "LeftSurface"
    elseif normal == Enum.NormalId.Right then
        return "RightSurface"
    elseif normal == Enum.NormalId.Front then
        return "FrontSurface"
    elseif normal == Enum.NormalId.Bottom then
        return "BottomSurface"
    end

    return "TopSurface"
end

function Service.ApplySurfaceTypeToPartNormal(
    surfaceType: EnumValue<Enum.SurfaceType>,
    part: BasePart,
    normal: EnumValue<Enum.NormalId>
)
    if not surfaceType or not part or not normal then
        return
    end

    if not part:IsA("BasePart") or part.Locked then
        return
    end

    surfaceType = Service.ResolveEnumable(surfaceType)
    local surfaceProperty = Service.GetSurfacePropertyFromNormalId(normal)

    part[surfaceProperty] = surfaceType

    ChangeHistory:SetWaypoint(fmt("apply %q to %s of %s", surfaceType.Name, surfaceProperty, part.Name))
end

return Service
