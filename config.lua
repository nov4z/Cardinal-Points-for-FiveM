-- ====================================================================
-- CONFIGURACIÓN PRINCIPAL / MAIN CONFIGURATION
-- ====================================================================
-- Todas las opciones de personalización del HUD se configuran aquí.
-- No es necesario modificar el código en client/main.lua.
-- ====================================================================

Config = {}

-- ====================================================================
-- 1. IDIOMA / LANGUAGE
-- ====================================================================
-- Define los textos y las letras de los puntos cardinales.
-- 'es' = Español  -> Norte (N), Sur (S), Este (E), Oeste (O), etc.
-- 'en' = English  -> North (N), South (S), East (E), West (W), etc.
Config.Locale = 'es'

-- ====================================================================
-- 2. COMPORTAMIENTO GENERAL DEL HUD / GENERAL BEHAVIOR
-- ====================================================================

-- ¿Debe aparecer la brújula en pantalla automáticamente al entrar al servidor?
-- true = Sí, visible desde el spawn.
-- false = Oculta por defecto (el jugador debe activarla con tecla o comando).
Config.DefaultEnabled = true

-- ¿Mostrar la brújula ÚNICAMENTE cuando el jugador está dentro de un vehículo?
-- true  = Solo se ve conduciendo o como pasajero (estilo velocímetro/HUD vehicular).
-- false = Se ve tanto a pie como en vehículos.
Config.OnlyInVehicle = false

-- ¿Ocultar el HUD cuando el jugador abre el menú de pausa / mapa (ESC)?
-- true  = Oculta el HUD y suspende los hilos a 0.00ms mientras el mapa está abierto.
-- false = Sigue dibujando encima del menú de pausa.
Config.HideInPauseMenu = true

-- Frecuencia en milisegundos con la que se calcula el rumbo de la cámara y la calle.
-- 100ms = 10 veces por segundo (muy fluido para la vista humana y consume 0.00ms).
-- Reducirlo a 0ms es innecesario y malgasta CPU. Aumentarlo (ej. 200ms) ahorra aún más.
Config.UpdateInterval = 100

-- ====================================================================
-- 3. ESTILO VISUAL DEL COMPÁS / VISUAL STYLES
-- ====================================================================
-- Selecciona el formato visual del texto cardinal:
-- 'classic' -> Estilo brújula táctica:  - | - - - N - - - | -
-- 'minimal' -> Estilo limpio:          [ N ]
-- 'bar'     -> Estilo barra simple:    --- N ---
-- 'degrees' -> Estilo con grados:      N (180°)
Config.Style = 'classic'

-- ¿Mostrar los grados numéricos de la orientación (0° a 359°)?
-- Si está en true, añadirá el número de grados junto a la dirección (ej: "- | - - - N - - - | - 180°").
Config.ShowDegrees = false

-- ¿Mostrar el nombre de la calle actual y el cruce debajo de la brújula?
-- Ejemplo: "Innocence Blvd & Strawberry Ave"
Config.ShowStreetNames = true

-- ====================================================================
-- 4. POSICIÓN Y COORDENADAS EN PANTALLA / SCREEN COORDINATES
-- ====================================================================
-- El sistema de coordenadas 2D de GTA V va de 0.0 a 1.0:
-- X = 0.0 (Borde izquierdo) | X = 0.5 (Centro horizontal) | X = 1.0 (Borde derecho)
-- Y = 0.0 (Borde superior)  | Y = 0.5 (Centro vertical)   | Y = 1.0 (Borde inferior)

-- Posición del compás cardinal (Por defecto: Centro superior)
Config.Position = {
    x = 0.5,   -- Horizontal: 0.5 = Centrado
    y = 0.02   -- Vertical: 0.02 = Justo debajo del borde superior
}

-- Posición del texto del nombre de la calle (se dibuja un poco más abajo del compás)
Config.StreetPosition = {
    x = 0.5,   -- Horizontal
    y = 0.045  -- Vertical
}

-- ====================================================================
-- 5. APARIENCIA VISUAL Y TIPOGRAFÍA / TEXT APPEARANCE
-- ====================================================================
-- Fuentes disponibles en GTA V:
-- 0 = Chalet-London (Normal estándar)
-- 1 = House Script (Cursiva)
-- 2 = Monospace (Ancho fijo)
-- 4 = Chalet-Comprime Cologne (HUD clásico de GTA, muy legible)
-- 7 = Pricedown (Fuente del título de GTA)

-- Configuración visual del compás cardinal
Config.Text = {
    Font = 4,                                         -- Fuente recomendada para HUD
    Scale = 0.45,                                     -- Tamaño del texto (0.3 a 0.6)
    Color = { r = 255, g = 255, b = 255, a = 240 },   -- Color RGBA: Blanco casi opaco
    Shadow = true,                                    -- Sombra para resaltar sobre fondos claros
    Outline = true,                                   -- Borde negro para legibilidad perfecta contra el cielo
    Centre = true                                     -- Centrar alineación horizontal
}

-- Configuración visual del texto de la calle
Config.StreetText = {
    Font = 4,                                         -- Fuente del texto de la calle
    Scale = 0.35,                                     -- Un poco más pequeña que el compás
    Color = { r = 220, g = 220, b = 220, a = 220 },   -- Gris claro suave
    Shadow = true,
    Outline = true,
    Centre = true
}

-- ====================================================================
-- 6. COMANDOS Y ACCESOS RÁPIDOS / COMMANDS & KEYBINDINGS
-- ====================================================================

-- Nombre del comando en chat para activar o desactivar la brújula.
-- Usa nil o false si prefieres deshabilitar el comando.
Config.Command = 'compass'

-- Registro nativo de tecla en FiveM (RegisterKeyMapping).
-- Ventajas: No entra en conflicto con otros scripts y los jugadores pueden
-- reasignar la tecla a su gusto desde: Ajustes del juego > Asignación de Teclas > FiveM.
Config.KeyMapping = {
    Enabled = true,
    DefaultKey = 'K',                                     -- Tecla por defecto
    Description = 'Alternar visibilidad de la Brújula'   -- Texto visible en los ajustes de GTA V
}

-- ¿Mostrar una pequeña notificación en pantalla al encender o apagar la brújula?
Config.NotifyOnToggle = true

-- ====================================================================
-- 7. TABLAS DE LOCALIZACIÓN / LOCALIZATION TABLES
-- ====================================================================
-- Letras asignadas a cada sector angular de 45°
Config.Directions = {
    ['es'] = {
        N  = "N",    -- Norte
        NE = "NE",   -- Noreste
        E  = "E",    -- Este
        SE = "SE",   -- Sureste
        S  = "S",    -- Sur
        SO = "SO",   -- Suroeste
        O  = "O",    -- Oeste
        NO = "NO"    -- Noroeste
    },
    ['en'] = {
        N  = "N",    -- North
        NE = "NE",   -- Northeast
        E  = "E",    -- East
        SE = "SE",   -- Southeast
        S  = "S",    -- South
        SO = "SW",   -- Southwest
        O  = "W",    -- West
        NO = "NW"    -- Northwest
    }
}

-- Mensajes de notificación del sistema
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
