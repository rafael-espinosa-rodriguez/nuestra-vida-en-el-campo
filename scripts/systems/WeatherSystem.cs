using Godot;

public partial class WeatherSystem : Node
{
    public enum Weather { Soleado, Nublado, Lluvia }
    public Weather Current { get; private set; } = Weather.Soleado;
    public void RollDailyWeather(int day) { if (day == 6) Current = Weather.Lluvia; }
}
