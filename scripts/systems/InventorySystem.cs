using Godot;
using System.Collections.Generic;

public partial class InventorySystem : Node
{
    public enum Category { Agricultura, Animales, Materiales, Comida, Herramientas, Objetos }
    public Dictionary<string, int> Items { get; } = new();
    public void Add(string id, int n = 1) { Items[id] = Items.GetValueOrDefault(id) + n; }
    public bool Remove(string id, int n = 1)
    {
        if (Items.GetValueOrDefault(id) < n) return false;
        Items[id] -= n; return true;
    }
}
