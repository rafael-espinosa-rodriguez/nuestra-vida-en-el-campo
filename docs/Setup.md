# Setup — qué instalar en esta máquina (pendiente)

1. **Godot 4.x .NET (no la clásica):** https://godotengine.org/download → pestaña `.NET`.
   Verificar: `godot --version` abre el proyecto sin errores C#.
2. **.NET 8 SDK:** https://dotnet.microsoft.com/download → `dotnet --version` debe dar `8.x`.
3. **Git LFS:** `git lfs install` (para `assets/`).
4. **gh CLI (para GitHub):** https://cli.github.com → `gh auth login` → crear repo:
   ```
   gh repo create nuestra-vida-en-el-campo --public --source=. --push
   ```
   Sin `gh`: crea el repo vacío en github.com/new con nombre `nuestra-vida-en-el-campo` y luego:
   ```
   git remote add origin https://github.com/<tu-usuario>/nuestra-vida-en-el-campo.git
   git branch -M main
   git push -u origin main
   ```

Estado actual detectado: git OK; Godot NO, .NET SDK NO, gh NO.
