using QueueWorker;
public static partial class ServiceInitializer
{
    public static IServiceCollection RegisterApplicationServices(this IServiceCollection services)
    {
        // Add services to the DI container.

        services.AddHostedService<OrdersQueueProcessor>();
        
        return services;
    }
}