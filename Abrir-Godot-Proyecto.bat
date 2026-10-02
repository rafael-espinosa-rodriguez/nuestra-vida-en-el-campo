@echo off
REM Abre este proyecto en el editor Godot evitando Vulkan (esta PC no tiene vulkan-1.dll).
REM El proyecto ya usa renderer gl_compatibility, asi que no se pierde nada.
start "" "%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --rendering-driver opengl3 --path "%~dp0" --editor
