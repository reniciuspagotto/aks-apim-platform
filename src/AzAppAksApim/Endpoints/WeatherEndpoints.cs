namespace AzAppAksApim.Endpoints;

public static class WeatherEndpoints
{
    private static readonly string[] Cities =
    [
        "Sao Paulo",
        "New York",
        "London",
        "Paris",
        "Tokyo",
        "Sydney",
        "Cairo",
        "Mumbai",
        "Toronto",
        "Cape Town",
    ];

    private static readonly string[] Countries =
    [
        "Brazil",
        "United States",
        "United Kingdom",
        "France",
        "Japan",
        "Australia",
        "Egypt",
        "India",
        "Canada",
        "South Africa",
    ];

    public static IEndpointRouteBuilder MapWeatherEndpoints(this IEndpointRouteBuilder app)
    {
        app.MapGet("/api/temperature", () =>
            {
                var city = Cities[Random.Shared.Next(Cities.Length)];
                var celsius = Random.Shared.Next(-10, 41);
                var fahrenheit = celsius * 9 / 5 + 32;

                return TypedResults.Ok(new TemperatureResponse(city, celsius, fahrenheit));
            })
            .WithName("GetTemperature")
            .WithTags("Temperature")
            .WithSummary("Returns a random city with a random temperature");

        app.MapGet("/api/country", () =>
                TypedResults.Ok(new CountryResponse(Countries[Random.Shared.Next(Countries.Length)])))
            .WithName("GetCountry")
            .WithTags("Country")
            .WithSummary("Returns a random country");

        return app;
    }
}

public record TemperatureResponse(string City, int Celsius, int Fahrenheit);

public record CountryResponse(string Country);
