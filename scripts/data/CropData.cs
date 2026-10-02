using Godot;

[GlobalClass]
public partial class CropData : Resource
{
    [Export] public string CropId = "trigo";
    [Export] public string DisplayName = "Trigo";
    [Export] public int GrowDays = 3;
    [Export] public string Season = "primavera";
    [Export] public bool NeedsWater = true;
}
