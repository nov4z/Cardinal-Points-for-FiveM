# 🧭 novZ_compass

[![FiveM](https://img.shields.io/badge/FiveM-FXServer-orange.svg?style=flat-square)](https://fivem.net/)
[![Lua](https://img.shields.io/badge/Lua-5.4-blue.svg?style=flat-square)](https://www.lua.org/)
[![Tested](https://img.shields.io/badge/Tested%20On-ESX%20Legacy-blue.svg?style=flat-square)](https://github.com/nov4z/novZ_compass)
[![Resmon](https://img.shields.io/badge/Resmon-0.00ms-brightgreen.svg?style=flat-square)](https://github.com/nov4z/novZ_compass)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=flat-square)](LICENSE)

Un HUD de **Puntos Cardinales y Brújula** ligero, moderno, altamente optimizado (0.00ms resmon) y personalizable para servidores de **FiveM**.

> A lightweight, modern, highly optimized (0.00ms resmon), and customizable **Cardinal Points & Compass HUD** for **FiveM** servers.

---

## 🇪🇸 Descripción en Español

**`novZ_compass`** muestra en pantalla la orientación cardinal hacia donde mira la cámara del jugador (Norte, Sur, Este, Oeste y rumbos intermedios), con soporte opcional para nombres de calles, grados angulares y diferentes estilos visuales.

> [!IMPORTANT]
> **Compatibilidad de Frameworks:**
> - **Testeado y funcional en:** ESX Legacy.
> - **NO testeado:** Versión actual / más reciente de ESX.
> - **NO testeado:** QBCore ni Qbox.
> 
> *(Si alguien lo prueba en la versión actual de ESX, QBCore o Qbox, cualquier reporte o pull request es totalmente bienvenido).*

### Características
- **Rendimiento optimizado (0.00ms en reposo):** Hilo de cálculo desacoplado y suspensión automática en el menú de pausa.
- **Soporte de calles y cruces:** Muestra el nombre de la vía actual e intersecciones.
- **Estilos configurables:** Clásico (`- | - - - N - - - | -`), Minimalista (`[ N ]`), Barra (`--- N ---`) o con Grados (`N 180°`).
- **Comando y tecla registrados:** Comando `/compass` y asignación de tecla nativa (`K` por defecto) reasignable por cada jugador en los ajustes de GTA V.
- **Soporte bilingüe:** Español (`N, S, E, O`) e Inglés (`N, S, E, W`) seleccionable en `config.lua`.
- **Exportaciones públicas:** Permite a otros scripts activar, desactivar o consultar la orientación del jugador.

---

## 🇺🇸 English Description

**`novZ_compass`** displays on-screen the cardinal orientation the player's camera is facing (North, South, East, West and intermediate bearings), with optional support for street names, heading degrees, and different visual styles.

> [!IMPORTANT]
> **Framework Compatibility:**
> - **Tested and working on:** ESX Legacy.
> - **NOT tested:** Current / latest ESX version.
> - **NOT tested:** QBCore or Qbox.
> 
> *(If anyone tests this on current ESX, QBCore, or Qbox, feedback and pull requests are warmly welcome).*

### Features
- **Zero performance impact (0.00ms idle):** Decoupled calculation loop and automatic sleep when the pause menu is open.
- **Street & intersection names:** Displays current road and crossing intersection.
- **Configurable styles:** Classic (`- | - - - N - - - | -`), Minimalist (`[ N ]`), Bar (`--- N ---`), or with Degrees (`N 180°`).
- **Command & keybind:** `/compass` command and native keybind (`K` by default) rebindable in GTA V settings.
- **Bilingual support:** Spanish (`N, S, E, O`) and English (`N, S, E, W`) selectable in `config.lua`.
- **Public exports:** Allows other resources to toggle, check, or retrieve compass data.

---

## 📸 Vista Previa / Preview

[![Vista Previa de la Brújula](https://i.imgur.com/0nfgaxS.png)](https://imgur.com/0nfgaxS)

*Captura original: [Imgur Screenshot](https://imgur.com/0nfgaxS)*

---

## 📦 Instalación / Installation

1. Descarga o clona este repositorio en tu carpeta de recursos:
   ```bash
   cd resources/[standalone]
   git clone https://github.com/nov4z/novZ_compass.git
   ```
2. Asegúrate de que la carpeta se llame `novZ_compass`.
3. Añade la siguiente línea a tu archivo `server.cfg`:
   ```cfg
   ensure novZ_compass
   ```
4. Reinicia tu servidor o ejecuta en la consola:
   ```
   refresh
   start novZ_compass
   ```

---

## ⚙️ Configuración / Configuration

Toda la personalización se gestiona desde el archivo `config.lua`:

```lua
Config = {}

Config.Locale = 'es'            -- 'es' para Español (N, S, E, O) o 'en' para English (N, S, E, W)
Config.DefaultEnabled = true    -- Visible por defecto al entrar
Config.OnlyInVehicle = false    -- Si es true, solo aparece al subir a un vehículo
Config.HideInPauseMenu = true   -- Ocultar en el mapa/menú de pausa (0.00ms resmon)
Config.Style = 'classic'        -- 'classic', 'minimal', 'bar' o 'degrees'
Config.ShowDegrees = false      -- Mostrar grados de orientación (ej: 180°)
Config.ShowStreetNames = true   -- Mostrar nombre de calle y cruce

Config.Position = { x = 0.5, y = 0.02 }         -- Coordenadas compás (Centro superior)
Config.StreetPosition = { x = 0.5, y = 0.045 }   -- Coordenadas de la calle
Config.Command = 'compass'                      -- Comando para alternar
Config.KeyMapping = { Enabled = true, DefaultKey = 'K' }
```

---

## 🔌 Exportaciones / Exports

Puedes interactuar con el compás desde otros scripts cliente:

```lua
-- Alternar estado (toggle)
exports['novZ_compass']:ToggleCompass()

-- Forzar activación o desactivación
exports['novZ_compass']:ToggleCompass(true)  -- Activar
exports['novZ_compass']:ToggleCompass(false) -- Desactivar

-- Comprobar si está activo
local activo = exports['novZ_compass']:IsCompassActive()

-- Obtener la dirección cardinal actual (ej: "N", "SO", etc.)
local direccion = exports['novZ_compass']:GetCardinalDirection()

-- Obtener los grados actuales (0 - 359)
local grados = exports['novZ_compass']:GetHeadingDegrees()
```

---

## 📄 Licencia y Créditos / License & Credits

- Creado por **[NovZ](https://github.com/nov4z)**.
- Distribuido bajo la licencia [MIT](LICENSE). Eres libre de usarlo, modificarlo y compartirlo en tus servidores.
