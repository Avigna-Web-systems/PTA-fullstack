using System;
using System.Collections.Generic;
using System.Linq;   // 🔴 THIS WAS MISSING

namespace PTA.Core.Services;

public class WeatherForecast
{
    public DateTime Date { get; set; }
    public int TemperatureC { get; set; }
    public string? Summary { get; set; }
}

public interface IWeatherService
{
    IEnumerable<WeatherForecast> GetForecast();
}

public class WeatherService : IWeatherService
{
    private static readonly string[] Summaries =
    {
        "Freezing","Bracing","Chilly","Cool","Mild",
        "Warm","Balmy","Hot","Sweltering","Scorching"
    };

    public IEnumerable<WeatherForecast> GetForecast() =>
        Enumerable.Range(1, 5)
            .Select(i => new WeatherForecast
            {
                Date = DateTime.Now.AddDays(i),
                TemperatureC = Random.Shared.Next(-20, 55),
                Summary = Summaries[Random.Shared.Next(Summaries.Length)]
            });
}
