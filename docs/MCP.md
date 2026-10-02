# MCP — Godot conectado al asistente

## Qué hay instalado
- Plugin **Godot MCP Toolkit** v1.0.2 (MIT, local, sin telemetría) en `addons/godot_mcp_toolkit/`.
- Puente npm `@npgamedev/godot-mcp-server` (se descarga solo vía `npx`, requiere Node 22+; hay Node 24).
- Servidor `godot` registrado en `~/.config/opencode/opencode.json` (aplica al reiniciar opencode).

## Activar la conexión (2 pasos manuales en el editor)
1. Abre el proyecto en Godot 4.7.2 → **Project → Project Settings → Plugins** → activa **Godot MCP Toolkit**.
   Verás el dock MCP abajo y en Output: `[MCPServer] listening on 127.0.0.1:6550` (puerto 6550-6560).
2. Reinicia opencode para que cargue el servidor `godot`. A partir de ahí el asistente puede
   crear escenas/nodos, editar scripts, inspeccionar y hacer playtests dentro del editor.

## Notas
- Todo es local: nada sale de la máquina.
- Si el puerto cambia, el dock indica el activo; el puente lo detecta solo.
- Alternativa valorada y descartada por ahora: `hi-godot/godot-ai` (más popular pero pide `uv` y telemetría limitada).
