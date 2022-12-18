using Serilog;
using Utilities.AzureKeyVault;

// https://learn.microsoft.com/en-us/aspnet/core/fundamentals/configuration/?view=aspnetcore-7.0

var builder = WebApplication.CreateBuilder(args);
builder.Host.ConfigureKeyVaultAppConfiguration<Program>();
builder.Host.UseSerilog((ctx, lc) => lc.WriteTo.Console());

// https://www.jondjones.com/programming/aspnet-core/how-to/must-know-startupcs-to-programcs-refactoring-tips-in-net-7/ 

// Register Services
builder.Services.RegisterApplicationServices(builder.Configuration);

var app = builder.Build();

// Register Middleware/HttpPipeline
app.ConfigureMiddleware();

// Register Endpoints (for minimal Apis)
// app.RegisterEndpoints();

app.Run();
