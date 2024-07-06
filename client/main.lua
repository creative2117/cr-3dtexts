local closestLocations = {}
local isLooping = false

local function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.55)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry('STRING')
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x, y, z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    --DrawRect(0.0, 0.0+0.1525, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

local function addToClosestLocations(k, coords)
    
    for index, _ in pairs(closestLocations) do
        if closestLocations[index] == k then return end
    end
    table.insert(closestLocations, { index = k, coords = coords })
    loop()
end

local function removeFromClosestLocation(k)
    for index, _ in pairs(closestLocations) do
        if closestLocations[index].index == k then
            table.remove(closestLocations, k)
            if not closestLocations[1] then isLooping = false end
            break
        end
    end
end

CreateThread(function()
    for k, _ in pairs(Config.Texts) do
        local PolyZone = CircleZone:Create(Config.Texts[k].Coords, Config.Texts[k].dist, {
            name = "location-"..k,
            useZ = true,
            debugPoly = false
        })
        PolyZone:onPlayerInOut(function(isPointInside)
            if isPointInside then
                addToClosestLocations(k, Config.Texts[k].Coords)
            else
                removeFromClosestLocation(k)
            end
        end)
    end
end)

function loop()
    if isLooping then return end
    isLooping = true
    CreateThread(function()
        while isLooping do   
            for k, v in pairs(closestLocations) do
                DrawText3D(closestLocations[k].coords.x, closestLocations[k].coords.y, closestLocations[k].coords.z, Config.Texts[closestLocations[k].index].Text)
            end
            Wait(3)
        end
    end)
end