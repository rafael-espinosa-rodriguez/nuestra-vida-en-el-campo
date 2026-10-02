using Godot;

[GlobalClass]
public partial class RecipeData : Resource
{
    [Export] public string RecipeId = "pan";
    [Export] public string DisplayName = "Pan";
    [Export] public string[] Ingredients = { "harina", "agua" };
    [Export] public string Station = "horno";
}
