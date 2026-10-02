# Setup — estado de esta máquina

1. **Godot 4.x clásica 4.7.2:** ✅ instalada en `%LOCALAPPDATA%\Programs\Godot`.
   Verificar: `Godot_v4.7.2-stable_win64_console.exe --version` → `4.7.2.stable`.
2. **Plugin MCP Toolkit:** ✅ en `addons/godot_mcp_toolkit` + servidor `godot` en opencode.
   Para activar la conexión: abre el proyecto en el editor → Project Settings → Plugins → activar
   "Godot MCP Toolkit" → Project → Tools → MCP Toolkit → Write .mcp.json. Ver `docs/MCP.md`.
   El servidor MCP (`npx -y @npgamedev/godot-mcp-server`) se conecta solo cuando el editor está abierto.
3. **Git LFS:** pendiente `git lfs install` (para `assets/`).
4. **Repo GitHub:** ✅ creado y subido: https://github.com/rafael-espinosa-rodriguez/nuestra-vida-en-el-campo (rama `main`).
   `gh` CLI v2.102.0 instalado en `%LOCALAPPDATA%\Programs\gh` (en PATH). Pendiente: `gh auth login` interactivo del usuario para futuros push/PR.
