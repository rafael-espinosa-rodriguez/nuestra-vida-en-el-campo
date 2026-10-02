using Godot;

public partial class AnimalSystem : Node
{
    // Sistema UNICO para todas las especies (principio GDD §78). Los animales son datos (AnimalData), no sistemas.
    public void Feed(string animalId, string foodId) { }
    public void Pet(string animalId) { }
    public string Collect(string animalId) => "";
}
