using Godot;

public interface IInteractable
{
    string GetPrompt();
    void Interact(Node player);
}
