# 002 plan
- `TimeSystem` (Autoload) + `DayNight.tscn` (DirectionalLight+WorldEnvironment+Sky), curva de luz por hora.
- `SaveSystem` JSON: `SaveData{version,day,hour,playerPos,inventory,animals,crops,money,memories}`.
- Cama `IInteractable` → `TimeSystem.SleepUntilMorning()` + `SaveSystem.SaveOnSleep()`.
- Verificación: dormir D1→D2, cerrar/abrir juego, todo persiste.
