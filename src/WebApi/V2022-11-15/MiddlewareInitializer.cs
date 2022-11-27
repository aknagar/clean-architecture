public static partial class MiddlewareInitializer
{
    public static WebApplication ConfigureMiddleware(this WebApplication app)
    {
        // Configure the HTTP request pipeline.
        if (app.Environment.IsDevelopment())
        {
            app.UseSwagger();
            app.UseSwaggerUI();
        }

        // https://learn.microsoft.com/en-us/aspnet/core/security/enforcing-ssl?view=aspnetcore-7.0&preserve-view=true&tabs=visual-studio#port-configuration
        app.UseHttpsRedirection();

        app.UseAuthorization();

        app.MapControllers();

        return app;

    }
}