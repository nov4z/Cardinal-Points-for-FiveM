local isCompassEnabled = Config.DefaultEnabled
local cachedDirection = "N"
local cachedDegrees = 0
local cachedCompassText = ""
local cachedStreetText = ""
local shouldDisplay = false

-- ====================================================================
-- OBTENCIÓN DE DIRECCIÓN CARDINAL / CARDINAL DIRECTION CALCULATION
-- ====================================================================
local function GetCardinalDirection(heading)
    local lang = Config.Locale or 'es'
    local dict = Config.Directions[lang] or Config.Directions['es']
    local angle = (heading % 360.0 + 360.0) % 360.0

    if angle >= 337.5 or angle < 22.5 then
        return dict.N
    elseif angle >= 22.5 and angle < 67.5 then
        return dict.NE
    elseif angle >= 67.5 and angle < 112.5 then
        return dict.E
    elseif angle >= 112.5 and angle < 157.5 then
        return dict.SE
    elseif angle >= 157.5 and angle < 202.5 then
        return dict.S
    elseif angle >= 202.5 and angle < 247.5 then
        return dict.SO
    elseif angle >= 247.5 and angle < 292.5 then
        return dict.O
    elseif angle >= 292.5 and angle < 337.5 then
        return dict.NO
    end

    return dict.N
end

-- ====================================================================
-- FORMATO DEL TEXTO DE LA BRÚJULA / COMPASS TEXT FORMATTER
-- ====================================================================
local function FormatCompassText(direction, degrees)
    local text = ""
    local style = Config.Style or 'classic'

    if style == 'minimal' then
        text = string.format("[ %s ]", direction)
    elseif style == 'bar' then
        text = string.format("--- %s ---", direction)
    elseif style == 'degrees' then
        text = string.format("%s (%d°)", direction, degrees)
    else -- 'classic'
        text = string.format("- | - - - %s - - - | -", direction)
    end

    if Config.ShowDegrees and style ~= 'degrees' then
        text = string.format("%s %d°", text, degrees)
    end

    return text
end

-- ====================================================================
-- DIBUJADO DE TEXTO 2D EN PANTALLA / 2D ON-SCREEN TEXT RENDERING
-- ====================================================================
local function Draw2DText(x, y, text, style)
    if not text or text == "" then return end

    SetTextFont(style.Font or 4)
    SetTextProportional(true)
    SetTextScale(style.Scale or 0.45, style.Scale or 0.45)
    
    local col = style.Color or { r = 255, g = 255, b = 255, a = 255 }
    SetTextColour(col.r or 255, col.g or 255, col.b or 255, col.a or 255)

    if style.Shadow then
        SetTextDropshadow(1, 0, 0, 0, 200)
    end

    if style.Outline then
        SetTextOutline()
    end

    if style.Centre ~= false then
        SetTextCentre(true)
    end

    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

-- ====================================================================
-- NOTIFICACIÓN AL JUGADOR / PLAYER NOTIFICATION HELPER
-- ====================================================================
local function ShowNotification(message)
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName(message)
    EndTextCommandThefeedPostTicker(false, true)
end

-- ====================================================================
-- ALTERNAR ESTADO / TOGGLE STATE
-- ====================================================================
local function ToggleCompass(forcedState)
    if forcedState ~= nil then
        isCompassEnabled = forcedState
    else
        isCompassEnabled = not isCompassEnabled
    end

    if Config.NotifyOnToggle then
        local lang = Config.Locale or 'es'
        local trans = Config.Translations[lang] or Config.Translations['es']
        local msg = isCompassEnabled and trans.toggled_on or trans.toggled_off
        ShowNotification(msg)
    end
end

-- ====================================================================
-- BUCLE DE CÁLCULO DESACOPLADO (100ms) / DECOUPLED CALCULATION LOOP
-- ====================================================================
CreateThread(function()
    while true do
        local waitMs = Config.UpdateInterval or 100
        local ped = PlayerPedId()
        local isInVehicle = IsPedInAnyVehicle(ped, false)

        local isPaused = Config.HideInPauseMenu and IsPauseMenuActive()
        local vehicleCondition = (not Config.OnlyInVehicle) or isInVehicle

        shouldDisplay = isCompassEnabled and vehicleCondition and not isPaused

        if shouldDisplay then
            -- Obtener rotación de cámara de juego (GamePlayCam)
            local camRot = GetGameplayCamRot(0)
            local camZ = camRot.z or 0.0
            local angle = (camZ % 360.0 + 360.0) % 360.0
            cachedDegrees = math.floor(angle)

            cachedDirection = GetCardinalDirection(angle)
            cachedCompassText = FormatCompassText(cachedDirection, cachedDegrees)

            -- Cálculo de nombres de calle si está activado
            if Config.ShowStreetNames then
                local coords = GetEntityCoords(ped)
                local streetHash, crossingHash = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
                local streetName = GetStreetNameFromHashKey(streetHash) or ""

                if crossingHash and crossingHash ~= 0 then
                    local crossingName = GetStreetNameFromHashKey(crossingHash)
                    if crossingName and crossingName ~= "" and crossingName ~= streetName then
                        streetName = streetName .. " & " .. crossingName
                    end
                end

                cachedStreetText = streetName
            else
                cachedStreetText = ""
            end
        else
            waitMs = 500
        end

        Wait(waitMs)
    end
end)

-- ====================================================================
-- BUCLE DE RENDERIZADO VISUAL / HUD RENDERING LOOP
-- ====================================================================
CreateThread(function()
    while true do
        if shouldDisplay then
            -- Dibuja el compás
            Draw2DText(Config.Position.x, Config.Position.y, cachedCompassText, Config.Text)

            -- Dibuja el nombre de la calle si está habilitado
            if Config.ShowStreetNames and cachedStreetText ~= "" then
                Draw2DText(Config.StreetPosition.x, Config.StreetPosition.y, cachedStreetText, Config.StreetText)
            end

            Wait(0)
        else
            Wait(500)
        end
    end
end)

-- ====================================================================
-- COMANDO Y REGISTRO DE TECLAS / COMMAND & KEY MAPPING
-- ====================================================================
if Config.Command and Config.Command ~= '' then
    RegisterCommand(Config.Command, function()
        ToggleCompass()
    end, false)

    if Config.KeyMapping and Config.KeyMapping.Enabled then
        RegisterKeyMapping(
            Config.Command,
            Config.KeyMapping.Description or 'Toggle Compass HUD',
            'keyboard',
            Config.KeyMapping.DefaultKey or 'K'
        )
    end
end

-- ====================================================================
-- EXPORTACIONES PARA OTROS SCRIPTS / PUBLIC EXPORTS
-- ====================================================================
exports('ToggleCompass', ToggleCompass)
exports('IsCompassActive', function()
    return isCompassEnabled
end)
exports('GetCardinalDirection', function()
    return cachedDirection
end)
exports('GetHeadingDegrees', function()
    return cachedDegrees
end)
