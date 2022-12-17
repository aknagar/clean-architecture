using clean_architecture.Domain.Entities;
using Microsoft.AspNetCore.Mvc;

/// https://learn.microsoft.com/en-us/aspnet/core/web-api/?view=aspnetcore-7.0
/// [ApiController] enables opinionated behaviors that make it easier to build web APIs. 
/// Some behaviors include parameter source inference, attribute routing as a requirement, and model validation error-handling enhancements.
/// [Route] defines the routing pattern [controller]. The [controller] token is replaced by the controller's name (case-insensitive, without the Controller suffix).
/// This controller handles requests to https://localhost:{PORT}/weatherforecast.
///
[ApiController]
[Route("[controller]")]
public class WeatherForecastController : ControllerBase
{
    private static readonly string[] Summaries = new[]
    {
        "Freezing", "Bracing", "Chilly", "Cool", "Mild", "Warm", "Balmy", "Hot", "Sweltering", "Scorching"
    };

    private readonly ILogger<WeatherForecastController> _logger;
    private readonly IConfiguration _configuration;

    public WeatherForecastController(IConfiguration configuration, ILogger<WeatherForecastController> logger)
    {
        _configuration = configuration;
        _logger = logger;
    }

    [HttpGet(Name = "GetWeatherForecast")]
    public IEnumerable<WeatherForecast> Get()
    {
        _logger.LogError("GetWeatherForecast executed.");
        return Enumerable.Range(1, 5).Select(index => new WeatherForecast
        {
            Date = DateOnly.FromDateTime(DateTime.Now.AddDays(index)),
            TemperatureC = Random.Shared.Next(-20, 55),
            Summary = Summaries[Random.Shared.Next(Summaries.Length)]
        })
        .ToArray();
    }
}
