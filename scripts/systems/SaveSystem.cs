using Godot;

public partial class SaveSystem : Node
{
    public const string SavePath = "user://savegame.json";
    public void SaveGame() { /* TODO spec 002: posicion, dia, estacion, clima, inventario, animales, cultivos, dinero, recuerdos */ }
    public void LoadGame() { }
    public bool HasSave() => FileAccess.FileExists(SavePath);
}
