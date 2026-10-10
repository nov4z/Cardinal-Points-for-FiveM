# 🧭 novz-compass

[![FiveM](https://img.shields.io/badge/FiveM-FXServer-orange.svg?style=flat-square)](https://fivem.net/)
[![Lua](https://img.shields.io/badge/Lua-5.4-blue.svg?style=flat-square)](https://www.lua.org/)
[![Framework](https://img.shields.io/badge/Framework-Standalone-success.svg?style=flat-square)](https://github.com/nov4z/novz-compass)
[![Resmon](https://img.shields.io/badge/Resmon-0.00ms-brightgreen.svg?style=flat-square)](https://github.com/nov4z/novz-compass)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=flat-square)](LICENSE)

Un HUD de **Puntos Cardinales y Brújula** ligero, moderno, altamente optimizado (0.00ms resmon) y personalizable para servidores de **FiveM**.

> A lightweight, modern, highly optimized (0.00ms resmon), and customizable **Cardinal Points & Compass HUD** for **FiveM** servers.

---

## 🇪🇸 Descripción en Español

**`novz-compass`** muestra en pantalla la orientación cardinal hacia donde mira la cámara del jugador (Norte, Sur, Este, Oeste y rumbos intermedios), con soporte opcional para **nombres de calles**, **grados angulares** y diferentes estilos visuales.

Es **100% Standalone**, lo que significa que funciona sin necesidad de frameworks, pero es totalmente compatible con **ESX**, **QBCore**, **Qbox**, **vRP** o cualquier servidor personalizado.

### ✨ Características
- ⚡ **Rendimiento Impecable (0.00ms en reposo):** Hilo de cálculo desacoplado y suspensión automática en el menú de pausa.
- 🗺️ **Soporte de Calles y Cruces:** Muestra el nombre de la calle actual y la intersección.
- 🎨 **Estilos Visuales Configurables:** Clásico (`- | - - - N - - - | -`), Minimalista (`[ N ]`), Barra (`--- N ---`) o con Grados (`N 180°`).
- ⌨️ **Tecla y Comando Registrados:** Comando `/compass` y asignación de tecla nativa (`K` por defecto) personalizable por cada jugador en *Ajustes de GTA > Asignación de Teclas > FiveM*.
- 🌐 **Soporte Bilingüe:** Español (`N, S, E, O`) e Inglés (`N, S, E, W`) seleccionable en `config.lua`.
- 🧩 **Exportaciones Públicas:** Permite a otros scripts activar, desactivar o consultar la orientación del jugador.

---

## 🇺🇸 English Description

**`novz-compass`** displays on-screen the cardinal orientation the player's camera is facing (North, South, East, West and intermediate bearings), with optional support for **street names**, **heading degrees**, and different visual styles.

It is **100% Standalone**, meaning it works without requiring any framework, yet it is fully compatible with **ESX**, **QBCore**, **Qbox**, **vRP**, or any custom server setup.

### ✨ Features
- ⚡ **Zero Performance Impact (0.00ms idle):** Decoupled calculation loop and automatic sleep when the pause menu is open.
- 🗺️ **Street & Intersection Names:** Displays the current street and crossing road.
- 🎨 **Configurable Visual Styles:** Classic (`- | - - - N - - - | -`), Minimalist (`[ N ]`), Bar (`--- N ---`), or with Degrees (`N 180°`).
- ⌨️ **Native Keymapping & Command:** `/compass` command and native keybind (`K` by default) customizable in *GTA Settings > Key Bindings > FiveM*.
- 🌐 **Bilingual Support:** Spanish (`N, S, E, O`) and English (`N, S, E, W`) selectable in `config.lua`.
- 🧩 **Public Exports:** Allows other resources to toggle, check, or retrieve compass data.

---

## 📸 Vista Previa / Preview

[![Vista Previa de la Brújula](https://i.imgur.com/0nfgaxS.png)](https://imgur.com/0nfgaxS)

*Captura original: [Imgur Screenshot](https://imgur.com/0nfgaxS)*

---

## 📦 Instalación / Installation

1. Descarga o clona este repositorio en tu carpeta de recursos:
   ```bash
   cd resources/[standalone]
   git clone https://github.com/nov4z/Cardinal-Points-for-FiveM.git novz-compass
   ```
2. Asegúrate de que la carpeta se llame `novz-compass` (o el nombre de tu preferencia).
3. Añade la siguiente línea a tu archivo `server.cfg`:
   ```cfg
   ensure novz-compass
   ```
4. Reinicia tu servidor o ejecuta en la consola:
   ```
   refresh
   start novz-compass
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
exports['novz-compass']:ToggleCompass()

-- Forzar activación o desactivación
exports['novz-compass']:ToggleCompass(true)  -- Activar
exports['novz-compass']:ToggleCompass(false) -- Desactivar

-- Comprobar si está activo
local activo = exports['novz-compass']:IsCompassActive()

-- Obtener la dirección cardinal actual (ej: "N", "SO", etc.)
local direccion = exports['novz-compass']:GetCardinalDirection()

-- Obtener los grados actuales (0 - 359)
local grados = exports['novz-compass']:GetHeadingDegrees()
```

---

## 📄 Licencia y Créditos / License & Credits

- Creado por **[NovZ](https://github.com/nov4z)**.
- Distribuido bajo la licencia [MIT](LICENSE). Eres libre de usarlo, modificarlo y compartirlo en tus servidores.
