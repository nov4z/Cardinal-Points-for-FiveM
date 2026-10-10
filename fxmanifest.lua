-- ====================================================================
-- MANIFIESTO DEL RECURSO (FXMANIFEST)
-- ====================================================================
-- Define los metadatos, versiones y archivos que componen este script
-- para que el servidor de FiveM (FXServer) pueda cargarlo correctamente.
-- ====================================================================

-- Versión del manifiesto de FiveM. 'cerulean' es el estándar moderno recomendado.
fx_version 'cerulean'

-- Especifica el juego compatible (GTA V).
game 'gta5'

-- Habilita el intérprete moderno de Lua 5.4.
-- Proporciona mejor rendimiento, operadores bit a bit, enteros nativos y variables const.
lua54 'yes'

-- ====================================================================
-- METADATOS DEL RECURSO / INFORMACIÓN GENERAL
-- ====================================================================
name 'novz-compass'
author 'NovZ'
description 'HUD de Puntos Cardinales y Brújula ligero, moderno y optimizado para FiveM'
version '2.0.0'
repository 'https://github.com/nov4z/Cardinal-Points-for-FiveM'

-- ====================================================================
-- CARGA DE SCRIPTS
-- ====================================================================

-- Archivos compartidos (se cargan tanto en el cliente como en el servidor).
-- Contiene todas las variables de configuración editables por el usuario.
shared_scripts {
    'config.lua'
}

-- Archivos que se ejecutan del lado del cliente (en el juego del jugador).
-- Contiene toda la lógica del compás, cálculo de rumbos y dibujado en pantalla.
client_scripts {
    'client/main.lua'
}
