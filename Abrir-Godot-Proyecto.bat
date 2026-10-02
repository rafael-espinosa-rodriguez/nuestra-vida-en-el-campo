@echo off
REM Abre este proyecto en el editor Godot evitando Vulkan (esta PC no tiene vulkan-1.dll).
REM El proyecto ya usa renderer gl_compatibility, asi que no se pierde nada.
REM Nota: se usa "%~dp0." (con punto) porque la barra final antes de la comilla rompia la ruta.
echo Abriendo editor Godot (OpenGL, sin Vulkan)...
"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --rendering-driver opengl3 --path "%~dp0." --editor
echo.
echo El editor se cerro (codigo %ERRORLEVEL%). Si hubo un error, copia el texto de arriba.
pause
