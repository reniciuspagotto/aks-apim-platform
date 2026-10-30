using AzAppAksApim.Endpoints;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddHealthChecks();

builder.Services.ConfigureHttpJsonOptions(options =>
    options.SerializerOptions.NumberHandling = System.Text.Json.Serialization.JsonNumberHandling.Strict);

builder.Services.AddOpenApi(options =>
{
    options.OpenApiVersion = Microsoft.OpenApi.OpenApiSpecVersion.OpenApi3_0;
    options.AddDocumentTransformer((document, _, _) =>
    {
        document.Info.Title = "AzAppAksApim API";
        document.Info.Version = "v1";
        document.Info.Description = "Sample API hosted on AKS and exposed through Azure API Management.";
        return Task.CompletedTask;
    });
});

var app = builder.Build();

app.MapOpenApi();

app.MapGet("/api/hello", () => Results.Ok(new HelloResponse("Hello from az-app-aks-apim", DateTime.UtcNow)))
    .WithName("GetHello")
    .WithTags("Hello")
    .WithSummary("Returns a greeting message")
    .WithDescription("Returns a static greeting along with the current UTC timestamp.")
    .Produces<HelloResponse>(StatusCodes.Status200OK);

app.MapHealthChecks("/api/health");

app.MapWeatherEndpoints();

app.Run();

public record HelloResponse(string Message, DateTime Timestamp);
