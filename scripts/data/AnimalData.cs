using Godot;

[GlobalClass]
public partial class AnimalData : Resource
{
    [Export] public string Species = "gallina";
    [Export] public string DisplayName = "Gallina";
    [Export] public int HungerMax = 100;
    [Export] public string ProduceId = "huevo";
    [Export] public int ProducePerDay = 1;
    [Export] public string[] Personalities = { "cariñoso", "tímido", "juguetón", "tranquilo", "curioso" };
}
