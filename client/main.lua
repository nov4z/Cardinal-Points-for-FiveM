-- ====================================================================
-- CLIENT/MAIN.LUA - LÓGICA DEL HUD DE PUNTOS CARDINALES Y COMPÁS
-- ====================================================================
-- Autor: NovZ
-- Repositorio: https://github.com/nov4z/novZ_compass
-- Descripción:
--   Este archivo contiene toda la lógica cliente para calcular hacia dónde
--   mira el jugador, determinar la dirección cardinal (N, S, E, O, etc.),
--   obtener los nombres de las calles de Los Santos y dibujar el HUD
--   en pantalla mediante nativos 2D de GTA V.
--
-- ARQUITECTURA DE RENDIMIENTO (0.00ms RESMON):
--   En FiveM, los scripts que ejecutan cálculos pesados dentro de un bucle
--   con Wait(0) causan picos de consumo (0.05ms - 0.10ms).
--   Para lograr un consumo de 0.00ms a 0.01ms, este script utiliza DOS hilos:
--     1. Hilo de Cálculo (100ms): Calcula el ángulo, dirección cardinal y calles.
--     2. Hilo de Renderizado (0ms): Dibuja el texto ya calculado en pantalla.
--        Si el HUD está apagado o en menú de pausa, duerme a 500ms automáticamente.
-- ====================================================================

-- ====================================================================
-- VARIABLES DE ESTADO Y MEMORIA EN CACHÉ
-- ====================================================================
local isCompassEnabled = Config.DefaultEnabled   -- Estado actual de visibilidad (true = encendido, false = apagado)
local cachedDirection = "N"                     -- Dirección cardinal calculada en caché
local cachedDegrees = 0                         -- Grados numéricos en caché (0 a 359)
local cachedCompassText = ""                    -- Cadena formateada del compás lista para dibujar
local cachedStreetText = ""                     -- Nombre de calle y cruce listos para dibujar
local shouldDisplay = false                     -- Bandera global que indica al renderizador si debe dibujar

-- ====================================================================
-- 1. FUNCIÓN: GetCardinalDirection(heading)
-- ====================================================================
-- Recibe:
--   heading (número float): Ángulo de rotación de 0.0 a 360.0 grados.
-- Retorna:
--   (string): Letra o sigla del punto cardinal (ej: "N", "NE", "E", etc.).
--
-- EXPLICACIÓN MATEMÁTICA:
--   Una brújula completa tiene 360 grados repartidos en 8 sectores cardinales.
--   Cada sector abarca un arco de 45 grados (360 / 8 = 45):
--     - Norte (N)   está centrado en 0° / 360° (desde 337.5° hasta 22.5°)
--     - Noreste (NE) está centrado en 45°      (desde 22.5° hasta 67.5°)
--     - Este (E)    está centrado en 90°       (desde 67.5° hasta 112.5°)
--     - Sureste (SE) está centrado en 135°     (desde 112.5° hasta 157.5°)
--     - Sur (S)     está centrado en 180°      (desde 157.5° hasta 202.5°)
--     - Suroeste (SO/SW) centrado en 225°      (desde 202.5° hasta 247.5°)
--     - Oeste (O/W)  está centrado en 270°     (desde 247.5° hasta 292.5°)
--     - Noroeste (NO/NW) centrado en 315°      (desde 292.5° hasta 337.5°)
-- ====================================================================
local function GetCardinalDirection(heading)
    -- Seleccionar el diccionario de idioma configurado (Español o Inglés)
    local lang = Config.Locale or 'es'
    local dict = Config.Directions[lang] or Config.Directions['es']

    -- Normalizar el ángulo asegurando que esté estrictamente entre 0.0 y 359.99
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
-- 2. FUNCIÓN: FormatCompassText(direction, degrees)
-- ====================================================================
-- Genera la cadena de texto con el formato visual elegido en Config.Style.
-- ====================================================================
local function FormatCompassText(direction, degrees)
    local text = ""
    local style = Config.Style or 'classic'

    if style == 'minimal' then
        -- Ejemplo: [ N ]
        text = string.format("[ %s ]", direction)
    elseif style == 'bar' then
        -- Ejemplo: --- N ---
        text = string.format("--- %s ---", direction)
    elseif style == 'degrees' then
        -- Ejemplo: N (180°)
        text = string.format("%s (%d°)", direction, degrees)
    else
        -- Estilo por defecto 'classic': - | - - - N - - - | -
        text = string.format("- | - - - %s - - - | -", direction)
    end

    -- Si se activó ShowDegrees y el estilo no es ya 'degrees', se añade el grado al final
    if Config.ShowDegrees and style ~= 'degrees' then
        text = string.format("%s %d°", text, degrees)
    end

    return text
end

-- ====================================================================
-- 3. FUNCIÓN: Draw2DText(x, y, text, style)
-- ====================================================================
-- Renderiza texto plano en la pantalla utilizando los nativos del motor de GTA V.
-- Nativos utilizados:
--   - SetTextFont: Elige la fuente de texto del juego (0, 1, 2, 4, 7).
--   - SetTextProportional: Activa espaciado proporcional entre caracteres.
--   - SetTextScale: Define el ancho y alto de cada letra.
--   - SetTextColour: Define el color RGBA (Rojo, Verde, Azul, Opacidad de 0 a 255).
--   - SetTextDropshadow: Dibuja una sombra detrás de las letras para mejorar contraste.
--   - SetTextOutline: Dibuja un fino reborde negro alrededor del texto.
--   - SetTextCentre: Centra el texto horizontalmente respecto a la coordenada X dada.
--   - SetTextEntry & AddTextComponentString: Carga la cadena en el buffer de texto.
--   - DrawText: Dibuja efectivamente el texto en la posición de pantalla (x, y).
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
-- 4. FUNCIÓN: ShowNotification(message)
-- ====================================================================
-- Muestra una notificación nativa rápida en la esquina inferior izquierda
-- sobre el minimapa del jugador (feed ticker de GTA V).
-- ====================================================================
local function ShowNotification(message)
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName(message)
    EndTextCommandThefeedPostTicker(false, true)
end

-- ====================================================================
-- 5. FUNCIÓN: ToggleCompass(forcedState)
-- ====================================================================
-- Permite encender o apagar la visibilidad del HUD.
-- Si forcedState es nil, simplemente invierte el estado actual.
-- ====================================================================
local function ToggleCompass(forcedState)
    if forcedState ~= nil then
        isCompassEnabled = forcedState
    else
        isCompassEnabled = not isCompassEnabled
    end

    -- Notificar al jugador si está habilitado en config.lua
    if Config.NotifyOnToggle then
        local lang = Config.Locale or 'es'
        local trans = Config.Translations[lang] or Config.Translations['es']
        local msg = isCompassEnabled and trans.toggled_on or trans.toggled_off
        ShowNotification(msg)
    end
end

-- ====================================================================
-- 6. HILO 1: CÁLCULOS MATEMÁTICOS Y CALLES (Cada 100ms)
-- ====================================================================
-- Este hilo se encarga exclusivamente de computar la dirección y los nombres
-- de las calles. Al ejecutarse cada 100 milisegundos en lugar de cada fotograma (0ms),
-- ahorra una enorme cantidad de ciclos de CPU sin pérdida perceptible de fluidez.
-- ====================================================================
CreateThread(function()
    while true do
        local waitMs = Config.UpdateInterval or 100
        local ped = PlayerPedId()
        local isInVehicle = IsPedInAnyVehicle(ped, false)

        -- Condiciones de visibilidad:
        -- 1. El HUD debe estar activado por el jugador (isCompassEnabled).
        -- 2. Si Config.OnlyInVehicle está activo, debe estar en un vehículo.
        -- 3. Si Config.HideInPauseMenu está activo, no debe estar en menú de pausa.
        local isPaused = Config.HideInPauseMenu and IsPauseMenuActive()
        local vehicleCondition = (not Config.OnlyInVehicle) or isInVehicle

        shouldDisplay = isCompassEnabled and vehicleCondition and not isPaused

        if shouldDisplay then
            -- Obtener rotación de la cámara libre del jugador (Gameplay Cam).
            -- GetGameplayCamRot(0) devuelve un vector rotX, rotY, rotZ.
            -- El componente rotZ representa el rumbo horizontal de la mirada del jugador en grados.
            local camRot = GetGameplayCamRot(0)
            local camZ = camRot.z or 0.0
            local angle = (camZ % 360.0 + 360.0) % 360.0
            cachedDegrees = math.floor(angle)

            -- Calcular punto cardinal y formatear el texto
            cachedDirection = GetCardinalDirection(angle)
            cachedCompassText = FormatCompassText(cachedDirection, cachedDegrees)

            -- Obtener nombres de calles mediante nativos del mapa de GTA V si está activado
            if Config.ShowStreetNames then
                local coords = GetEntityCoords(ped)
                -- GetStreetNameAtCoord devuelve los hashes numéricos de la calle principal y del cruce
                local streetHash, crossingHash = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
                -- GetStreetNameFromHashKey convierte el hash en texto legible (ej: "Vinewood Blvd")
                local streetName = GetStreetNameFromHashKey(streetHash) or ""

                -- Si hay una intersección o cruce cercano, se añade con formato "Calle & Cruce"
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
            -- Si el HUD no debe mostrarse, dejamos descansar el hilo por 500ms
            waitMs = 500
        end

        Wait(waitMs)
    end
end)

-- ====================================================================
-- 7. HILO 2: RENDERIZADO VISUAL EN PANTALLA (0ms solo al dibujar)
-- ====================================================================
-- Este hilo se dedica exclusivamente a pintar el texto en pantalla.
-- Como todos los textos ya están precalculados en las variables en caché,
-- el dibujado es prácticamente instantáneo y no genera lag.
-- Si el HUD está oculto, entra en reposo a 500ms (0.00ms de resmon garantizado).
-- ====================================================================
CreateThread(function()
    while true do
        if shouldDisplay then
            -- Dibuja el compás cardinal
            Draw2DText(Config.Position.x, Config.Position.y, cachedCompassText, Config.Text)

            -- Dibuja el nombre de la calle si existe
            if Config.ShowStreetNames and cachedStreetText ~= "" then
                Draw2DText(Config.StreetPosition.x, Config.StreetPosition.y, cachedStreetText, Config.StreetText)
            end

            -- Debe ser 0ms para refrescar el render en cada fotograma del juego
            Wait(0)
        else
            -- Si no está visible, suspender por medio segundo
            Wait(500)
        end
    end
end)

-- ====================================================================
-- 8. COMANDO EN CHAT Y VINCULACIÓN DE TECLA NATIVA
-- ====================================================================
if Config.Command and Config.Command ~= '' then
    -- Registrar comando /compass
    RegisterCommand(Config.Command, function()
        ToggleCompass()
    end, false)

    -- Registrar tecla nativa de GTA V mediante RegisterKeyMapping
    if Config.KeyMapping and Config.KeyMapping.Enabled then
        RegisterKeyMapping(
            Config.Command,
            Config.KeyMapping.Description or 'Alternar Visibilidad del Compás',
            'keyboard',
            Config.KeyMapping.DefaultKey or 'K'
        )
    end
end

-- ====================================================================
-- 9. EXPORTACIONES PÚBLICAS (EXPORTS) PARA OTROS SCRIPTS
-- ====================================================================
-- Otros recursos de tu servidor pueden llamar estas funciones directamente:
--
-- Ejemplo desde otro script Lua cliente:
--   exports['novZ_compass']:ToggleCompass()
--   local direccion = exports['novZ_compass']:GetCardinalDirection()
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
