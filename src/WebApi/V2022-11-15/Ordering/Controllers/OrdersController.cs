using System.Net;
using System.Text.Json;
using Azure.Messaging.ServiceBus;
using Bogus;
using clean_architecture.Domain.Entities;
using Contracts;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;
using Options;

/// <summary>
/// https://localhost:7089/orders
/// </summary>
[ApiController]
[Route("[controller]")]
public class OrdersController : ControllerBase
{
    private static readonly string[] Summaries = new[]
    {
        "Freezing", "Bracing", "Chilly", "Cool", "Mild", "Warm", "Balmy", "Hot", "Sweltering", "Scorching"
    };
    private readonly ILogger<OrdersController> _logger;
    private readonly IConfiguration _configuration;

    private readonly JwtOptions _options;

    public OrdersController(IConfiguration configuration, ILogger<OrdersController> logger, IOptions<JwtOptions> options)
    {
         _configuration = configuration;
        _logger = logger;
        _options = options.Value;
    }

    [HttpGet]
    [ProducesResponseType(typeof(IEnumerable<WeatherForecast>), (int)HttpStatusCode.OK)]
    public async Task<ActionResult<IEnumerable<WeatherForecast>>> GetOrdersAsync()
    {
         _logger.LogError("GetWeatherForecast executed." + _options.TestAttribute);
        
        return Enumerable.Range(1, 5).Select(index => new WeatherForecast
        {
            Date = DateOnly.FromDateTime(DateTime.Now.AddDays(index)),
            TemperatureC = Random.Shared.Next(-20, 55),
            Summary = Summaries[Random.Shared.Next(Summaries.Length)]
        })
        .ToArray();
    }

    [Route("{orderAmount:int}/ship")]
    [HttpPut]
    [ProducesResponseType((int)HttpStatusCode.OK)]
    [ProducesResponseType((int)HttpStatusCode.BadRequest)]
    public async Task<IActionResult> ShipOrderAsync(int orderAmount, [FromHeader(Name = "x-requestid")] string requestId)
    {
        bool result = false;

        if (orderAmount > 100)
        {
            return BadRequest("Order amount above 100 not allowed");
        }

        if (Guid.TryParse(requestId, out Guid guid) && guid != Guid.Empty)
        {
            var ConnectionString = _configuration["ConnectionStrings:ServiceBus"];
            await QueueOrders(orderAmount, ConnectionString);
            result = true;
        }

        if (!result)
        {
            return BadRequest();
        }

        return Ok();
    }

    static async Task QueueOrders(int requestedAmount, string connectionString)
    {        
        var serviceBusClient = new ServiceBusClient(connectionString);
        var serviceBusSender = serviceBusClient.CreateSender("orders");

        for (int currentOrderAmount = 0; currentOrderAmount < requestedAmount; currentOrderAmount++)
        {
            var order = GenerateOrder();
            var rawOrder = JsonSerializer.Serialize(order);
            var orderMessage = new ServiceBusMessage(rawOrder);

            Console.WriteLine($"Queuing order {order.Id} - A {order.ArticleNumber} for {order.Customer.FirstName} {order.Customer.LastName}");
            await serviceBusSender.SendMessageAsync(orderMessage);
        }
    } 
    static Order GenerateOrder()
{
    var customerGenerator = new Faker<Customer>()
        .RuleFor(u => u.FirstName, (f, u) => f.Name.FirstName())
        .RuleFor(u => u.LastName, (f, u) => f.Name.LastName());

    var orderGenerator = new Faker<Order>()
        .RuleFor(u => u.Customer, () => customerGenerator)
        .RuleFor(u => u.Id, f => Guid.NewGuid().ToString())
        .RuleFor(u => u.Amount, f => f.Random.Int())
        .RuleFor(u => u.ArticleNumber, f => f.Commerce.Product());

    return orderGenerator.Generate();
}
}
