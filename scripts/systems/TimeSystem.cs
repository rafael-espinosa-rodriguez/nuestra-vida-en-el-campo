using Godot;

public partial class TimeSystem : Node
{
    [Signal] public delegate void DayChangedEventHandler(int newDay);
    [Signal] public delegate void TimeChangedEventHandler(float hour);

    public int CurrentDay { get; private set; } = 1;
    public float Hour { get; private set; } = 6.0f; // 06:00 D1
    public float DayLengthMinutes { get; set; } = 20.0f; // 15-25 configurable (§8)

    public override void _Process(double delta)
    {
        // TODO spec 002: avanzar hora, amanecer/día/atardecer/noche, dormir -> Day+1 + autosave.
    }

    public void SleepUntilMorning() { }
    public bool IsNight() => Hour < 6.0f || Hour >= 21.0f;
}
