--!strict
type EnumValue<T> = (string | number | T)

local CollectionService = game:GetService("CollectionService")
local ChangeHistory = game:GetService("ChangeHistoryService")

local fmt = string.format

local Service = {
    Tag = "__SurfaceTool__",
    FFlags = require(script.FFlags),
}

local assets = {
    icons = {
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
    },
    textures = {
        [Enum.SurfaceType.Glue] = "rbxassetid://6825367738",
        [Enum.SurfaceType.Studs] = "rbxassetid://6825367598",
        [Enum.SurfaceType.Universal] = "rbxassetid://6825367536",
        [Enum.SurfaceType.Inlet] = "rbxassetid://6825367663",
        [Enum.SurfaceType.Weld] = "rbxassetid://6825367478",
    }
}

function Service.GetIconFromSurfaceType(surfaceType: EnumValue<Enum.SurfaceType>): string
    surfaceType = Service.ResolveEnumable(surfaceType, Enum.SurfaceType)
    local icon = assets.icons[surfaceType]
    return icon
end

function Service.FormatEnumName(value: EnumValue<Enum.SurfaceType>): string
    value = Service.ResolveEnumable(value, Enum.SurfaceType)
    return string.sub(string.gsub(value.Name, "%u", " %1"), 2)
end

function Service.ResolveEnumable(value: EnumValue<EnumItem>, enumBase: Enum): EnumItem
    if typeof(value) == "EnumItem" then
        return value
    end

    return enumBase[value]
end

function Service.GetSurfacePropertyFromNormalId(normal: EnumValue<Enum.NormalId>)
    normal = Service.ResolveEnumable(normal, Enum.NormalId)

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

function Service.DoesSurfacePropertyExist()
    return not Service.FFlags.UseTextures
end

function Service._applySurfaceTypeToPartNormalAsTexture(
    surfaceType: EnumValue<Enum.SurfaceType>,
    part: BasePart,
    normal: EnumValue<Enum.NormalId>
)
    if not (surfaceType and part and normal and part:IsA("BasePart") and not part.Locked) then
        return
    end

    surfaceType = Service.ResolveEnumable(surfaceType, Enum.SurfaceType)
    normal = Service.ResolveEnumable(normal, Enum.NormalId)

    local matchedTexture: Texture = nil

    for _, child in ipairs(part:GetChildren()) do
        if child.ClassName == "Texture" and child.Face == normal and CollectionService:HasTag(child, Service.Tag) then
            matchedTexture = child
            break
        end
    end

    local surfaceTexture = assets.textures[surfaceType]

    if surfaceTexture then
        if not matchedTexture then
            matchedTexture = Instance.new("Texture")
            matchedTexture.Name = string.format("SurfaceToolTexture%s", normal.Name)
            matchedTexture.Face = normal
            matchedTexture.Parent = part

            CollectionService:AddTag(matchedTexture, Service.Tag)
        end

        matchedTexture.Texture = surfaceTexture
    else
        -- if surfaceType.Name:match("%w*Motor$") then
        --     -- TODO: Fancy handle stuff to "emulate" motors/hinges
        -- elseif surfaceType == Enum.SurfaceType.Hinge then
        --     -- TODO: Fancy handle stuff to "emulate" motors/hinges
        -- elseif surfaceType.Name:match("^Smooth%w*") then
        --     -- TODO: Nothing??
        -- end

        if matchedTexture then
            matchedTexture:Destroy()
        end
    end

    return true, fmt("apply %q to %s of %s", surfaceType.Name, normal.Name, part.Name)
end

function Service._applySurfaceTypeToPartNormal(
    surfaceType: EnumValue<Enum.SurfaceType>,
    part: BasePart,
    normal: EnumValue<Enum.NormalId>
)
    if not (surfaceType and part and normal and part:IsA("BasePart") and not part.Locked) then
        return
    end

    surfaceType = Service.ResolveEnumable(surfaceType, Enum.SurfaceType)
    local surfaceProperty = Service.GetSurfacePropertyFromNormalId(normal)

    part[surfaceProperty] = surfaceType

    return true, fmt("apply %q to %s of %s", surfaceType.Name, surfaceProperty, part.Name)
end

function Service.ApplySurfaceTypeToPartNormal(
    surfaceType: EnumValue<Enum.SurfaceType>,
    part: BasePart,
    normal: EnumValue<Enum.NormalId>
)
    local success, message = nil, nil

    if Service.DoesSurfacePropertyExist() then
        success, message = Service._applySurfaceTypeToPartNormal(surfaceType, part, normal)
    else
        success, message = Service._applySurfaceTypeToPartNormalAsTexture(surfaceType, part, normal)
    end

    if success then
        ChangeHistory:SetWaypoint(message)
    end
end

function Service.ApplySurfaceTypeToPartAcrossAllNormals(
    surfaceType: EnumValue<Enum.SurfaceType>,
    part: BasePart
)
    if not (surfaceType and part and part:IsA("BasePart") and not part.Locked) then
        return
    end

    local normalEnumItems = Enum.NormalId:GetEnumItems()
    local appliedNormals = 0

    for _, normalIdEnumItem in ipairs(normalEnumItems) do
        local success = nil

        if Service.DoesSurfacePropertyExist() then
            Service._applySurfaceTypeToPartNormal(surfaceType, part, normalIdEnumItem)
        else
            Service._applySurfaceTypeToPartNormalAsTexture(surfaceType, part, normalIdEnumItem)
        end

        if success then
            appliedNormals += 1
        end
    end

    if appliedNormals == #normalEnumItems then
        ChangeHistory:SetWaypoint(fmt("apply %q to all sides of %s", surfaceType.Name, part.Name))
    end
end

return Service
