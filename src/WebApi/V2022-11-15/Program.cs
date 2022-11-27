var builder = WebApplication.CreateBuilder(args);

// https://www.jondjones.com/programming/aspnet-core/how-to/must-know-startupcs-to-programcs-refactoring-tips-in-net-7/ 
// Register Services
builder.Services.RegisterApplicationServices();

var app = builder.Build();

// Register Middleware/HttpPipeline
app.ConfigureMiddleware();

// Register Endpoints (for minimal Apis)
// app.RegisterEndpoints();

app.Run();
