using Options;

public static partial class ServiceInitializer
{
    public static IServiceCollection RegisterApplicationServices(this IServiceCollection services, IConfiguration configuration)
    {
        // Add services to the DI container.

        services.AddControllers();
        // Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
        services.AddEndpointsApiExplorer();
        services.AddSwaggerGen();
        

        services.Configure<JwtOptions>(configuration.GetSection(nameof(JwtOptions)));

        services.AddProblemDetails(options => options.CustomizeProblemDetails = ctx => ctx.ProblemDetails.Extensions.Add("nodeId", Environment.MachineName));

        return services;
    }
}