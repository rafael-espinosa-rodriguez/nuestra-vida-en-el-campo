# MCP — Godot conectado al asistente

## Qué hay instalado
- Plugin **Godot MCP Toolkit** v1.0.2 (MIT, local, sin telemetría) en `addons/godot_mcp_toolkit/`.
- Puente npm `@npgamedev/godot-mcp-server` (se descarga solo vía `npx`, requiere Node 22+; hay Node 24).
- Servidor `godot` registrado en `~/.config/opencode/opencode.json` (aplica al reiniciar opencode).

## Activar la conexión (ya lo hice casi todo por ti)
- ✅ Plugin activado en `project.godot` (`[editor_plugins]` + autoload `MCPRuntimeServer`).
  Verificado headless: `[MCPServer] listening on 127.0.0.1:6550`, sin errores.
- ✅ Servidor `godot` registrado en opencode (`npx -y @npgamedev/godot-mcp-server`).
- ⏳ **Lo único manual (2 min, requiere tus ojos):**
  1. Abre el proyecto en el editor Godot (doble clic en `project.godot`). Confirma abajo el dock
     MCP y en Output la línea `[MCPServer] listening on 127.0.0.1:6550`. **Deja el editor abierto**
     mientras trabajemos: el puente solo habla con el editor en marcha.
  2. Reinicia esta sesión de opencode para que cargue las herramientas `godot_*`.
- El paso "Write .mcp.json" del menú del plugin es solo para Claude/Cursor: **con opencode no hace falta** (ya está en tu config global).

## Notas
- Todo es local: nada sale de la máquina.
- Si el puerto cambia, el dock indica el activo; el puente lo detecta solo.
- Alternativa valorada y descartada por ahora: `hi-godot/godot-ai` (más popular pero pide `uv` y telemetría limitada).
