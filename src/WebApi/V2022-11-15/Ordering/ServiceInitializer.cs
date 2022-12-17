public static partial class ServiceInitializer
{
    public static IServiceCollection RegisterApplicationServices(this IServiceCollection services)
    {
        // Add services to the DI container.

        services.AddControllers();
        // Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
        services.AddEndpointsApiExplorer();
        services.AddSwaggerGen();
        
        return services;
    }
}