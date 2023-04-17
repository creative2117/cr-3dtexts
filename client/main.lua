local function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.55)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry('STRING')
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    --DrawRect(0.0, 0.0+0.1525, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

CreateThread(function()
    while true do
        sleep = 1000
        
        local PlayerPed = PlayerPedId()
        local PlayerPos = GetEntityCoords(PlayerPed)
        local inRange = false

        for k, v in pairs(Config.Texts) do
            local coords = vector3(Config.Texts[k].Coords.x, Config.Texts[k].Coords.y, Config.Texts[k].Coords.z)
            local dist = #(PlayerPos - coords)
            if dist < Config.Texts[k].dist * 2 then
                inRange = true
                
                if dist < Config.Texts[k].dist then
                    DrawText3D(coords.x, coords.y, coords.z, Config.Texts[k].Text)
                    
                end
            else
                inRange = false
            end
            if inRange then
                sleep = 3
            end
        end
        Wait(sleep)
    end
end)