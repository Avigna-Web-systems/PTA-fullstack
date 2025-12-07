using Microsoft.AspNetCore.Mvc;
using PTA.Core.Services;
namespace PTA.API.Controllers;
[ApiController]
[Route("api/[controller]")]
public class WeatherController : ControllerBase
{
    private readonly IWeatherService _svc;
    public WeatherController(IWeatherService svc) => _svc = svc;
    [HttpGet]
    public IActionResult Get() => Ok(_svc.GetForecast());
}
