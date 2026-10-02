using Godot;

public partial class Player : CharacterBody3D
{
    [Export] public float Speed = 4.0f;
    public override void _PhysicsProcess(double delta)
    {
        // TODO spec 001: movimiento relativo a camara + sprint + Interact(E).
        Vector2 input = Input.GetVector("move_left", "move_right", "move_forward", "move_back");
        Vector3 dir = new(input.X, 0, input.Y);
        Velocity = dir * Speed;
        MoveAndSlide();
    }
}
