using QueueWorker;

IHost host = Host.CreateDefaultBuilder(args)
    .ConfigureServices(services =>
    {
        services.AddHostedService<OrdersQueueProcessor>();
    })
    .Build();

host.Run();
