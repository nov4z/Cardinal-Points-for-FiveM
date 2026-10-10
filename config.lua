Config = {}

-- ====================================================================
-- IDIOMA / LANGUAGE
-- ====================================================================
-- 'es' = Español (N, NE, E, SE, S, SO, O, NO)
-- 'en' = English (N, NE, E, SE, S, SW, W, NW)
Config.Locale = 'es'

-- ====================================================================
-- COMPORTAMIENTO GENERAL / GENERAL BEHAVIOR
-- ====================================================================
-- Iniciar con la brújula visible por defecto / Show compass on spawn by default
Config.DefaultEnabled = true

-- Mostrar solo cuando el jugador esté en un vehículo / Only show while inside a vehicle
Config.OnlyInVehicle = false

-- Ocultar automáticamente en el menú de pausa / Hide HUD while pause menu is active
Config.HideInPauseMenu = true

-- Intervalo de cálculo en milisegundos (100ms recomendado para 0.00ms resmon)
-- Calculation tick interval in ms (100ms recommended for optimum performance)
Config.UpdateInterval = 100

-- ====================================================================
-- ESTILO VISUAL DEL COMPÁS / COMPASS VISUAL STYLE
-- ====================================================================
-- Estilos disponibles / Available styles:
-- 'classic' -> - | - - - N - - - | -
-- 'minimal' -> [ N ]
-- 'bar'     -> --- N ---
-- 'degrees' -> N (180°)
Config.Style = 'classic'

-- Mostrar grados de orientación (ej: 180°) / Show heading degrees (e.g. 180°)
Config.ShowDegrees = false

-- Mostrar nombres de calle actual y cruce / Show current street & crossing road name
Config.ShowStreetNames = true

-- ====================================================================
-- POSICIÓN Y APARIENCIA / POSITION & APPEARANCE
-- ====================================================================
-- Coordenadas de pantalla para el compás / Screen coordinates for compass (X: 0.0 - 1.0, Y: 0.0 - 1.0)
Config.Position = {
    x = 0.5,
    y = 0.02
}

-- Coordenadas de pantalla para el texto de la calle / Screen coordinates for street name
Config.StreetPosition = {
    x = 0.5,
    y = 0.045
}

-- Tipografía y colores del compás / Typography & colors for compass
Config.Text = {
    Font = 4,                       -- 0: Normal, 1: Cursiva, 2: Todo mayúsculas, 4: HUD/Chalet, 7: Pricedown
    Scale = 0.45,                   -- Tamaño del texto
    Color = { r = 255, g = 255, b = 255, a = 240 }, -- Color RGBA (Blanco)
    Shadow = true,                  -- Activar sombra
    Outline = true,                 -- Activar contorno negro para mayor visibilidad
    Centre = true                   -- Centrar texto en la coordenada X
}

-- Tipografía y colores de la calle / Typography & colors for street name
Config.StreetText = {
    Font = 4,
    Scale = 0.35,
    Color = { r = 220, g = 220, b = 220, a = 220 },
    Shadow = true,
    Outline = true,
    Centre = true
}

-- ====================================================================
-- COMANDO Y ACCESO RÁPIDO / COMMAND & KEYBIND
-- ====================================================================
-- Comando en chat para activar/desactivar (pon nil o false para deshabilitar)
-- Chat command to toggle HUD (set to nil or false to disable)
Config.Command = 'compass'

-- Registro nativo de tecla (los jugadores pueden cambiar la tecla en Ajustes > FiveM)
-- Native key mapping (players can rebind in GTA Settings > Key Bindings > FiveM)
Config.KeyMapping = {
    Enabled = true,
    DefaultKey = 'K',
    Description = 'Alternar HUD de Puntos Cardinales'
}

-- Mostrar notificación al alternar con comando/tecla / Show chat notification on toggle
Config.NotifyOnToggle = true

-- ====================================================================
-- DICCIONARIO DE PUNTOS CARDINALES / CARDINAL POINTS DICTIONARY
-- ====================================================================
Config.Directions = {
    ['es'] = {
        N  = "N",
        NE = "NE",
        E  = "E",
        SE = "SE",
        S  = "S",
        SO = "SO",
        O  = "O",
        NO = "NO"
    },
    ['en'] = {
        N  = "N",
        NE = "NE",
        E  = "E",
        SE = "SE",
        S  = "S",
        SO = "SW",
        O  = "W",
        NO = "NW"
    }
}

Config.Translations = {
    ['es'] = {
        toggled_on  = "Brújula activada.",
        toggled_off = "Brújula desactivada."
    },
    ['en'] = {
        toggled_on  = "Compass activated.",
        toggled_off = "Compass deactivated."
    }
}
