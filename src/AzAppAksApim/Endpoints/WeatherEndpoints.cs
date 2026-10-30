using Microsoft.AspNetCore.Http.HttpResults;

namespace AzAppAksApim.Endpoints;

public static class WeatherEndpoints
{
    private static readonly CityClimate[] Climates =
    [
        new(new City("sao-paulo", "São Paulo", "Brazil", -23.5505, -46.6333), 21),
        new(new City("new-york", "New York", "United States", 40.7128, -74.0060), 13),
        new(new City("london", "London", "United Kingdom", 51.5074, -0.1278), 11),
        new(new City("paris", "Paris", "France", 48.8566, 2.3522), 12),
        new(new City("tokyo", "Tokyo", "Japan", 35.6762, 139.6503), 16),
        new(new City("sydney", "Sydney", "Australia", -33.8688, 151.2093), 18),
        new(new City("cairo", "Cairo", "Egypt", 30.0444, 31.2357), 23),
        new(new City("mumbai", "Mumbai", "India", 19.0760, 72.8777), 27),
        new(new City("toronto", "Toronto", "Canada", 43.6532, -79.3832), 9),
        new(new City("cape-town", "Cape Town", "South Africa", -33.9249, 18.4241), 17),
    ];

    private static readonly Dictionary<string, CityClimate> ClimatesById =
        Climates.ToDictionary(c => c.City.Id, StringComparer.OrdinalIgnoreCase);

    private static readonly City[] Cities = [.. Climates.Select(c => c.City)];

    public static IEndpointRouteBuilder MapWeatherEndpoints(this IEndpointRouteBuilder app)
    {
        app.MapGet("/api/cities", () => TypedResults.Ok(Cities))
            .WithName("GetCities")
            .WithTags("Cities")
            .WithSummary("Lists cities around the world")
            .WithDescription("Returns the cities available for temperature lookups.");

        app.MapGet("/api/cities/{cityId}/temperature", Results<Ok<TemperatureResponse>, NotFound> (string cityId) =>
            {
                if (!ClimatesById.TryGetValue(cityId, out var climate))
                {
                    return TypedResults.NotFound();
                }

                // Simulated reading: the city's average temperature with a random variation of ±5 °C
                var celsius = Math.Round(climate.AverageCelsius + (Random.Shared.NextDouble() * 10 - 5), 1);
                var fahrenheit = Math.Round(celsius * 9 / 5 + 32, 1);

                return TypedResults.Ok(new TemperatureResponse(
                    climate.City.Id,
                    climate.City.Name,
                    climate.City.Country,
                    celsius,
                    fahrenheit,
                    DateTime.UtcNow));
            })
            .WithName("GetCityTemperature")
            .WithTags("Temperature")
            .WithSummary("Gets the current temperature of a city")
            .WithDescription("Returns a simulated current temperature, in Celsius and Fahrenheit, for the given city id (e.g. 'sao-paulo').");

        return app;
    }

    private sealed record CityClimate(City City, double AverageCelsius);
}

/// <summary>City available for temperature lookups.</summary>
/// <param name="Id">City identifier used in the temperature route (e.g. 'sao-paulo').</param>
/// <param name="Name">City name.</param>
/// <param name="Country">Country name.</param>
/// <param name="Latitude">Latitude in decimal degrees.</param>
/// <param name="Longitude">Longitude in decimal degrees.</param>
public record City(string Id, string Name, string Country, double Latitude, double Longitude);

/// <summary>Current temperature of a city.</summary>
/// <param name="CityId">City identifier.</param>
/// <param name="City">City name.</param>
/// <param name="Country">Country name.</param>
/// <param name="Celsius">Temperature in degrees Celsius.</param>
/// <param name="Fahrenheit">Temperature in degrees Fahrenheit.</param>
/// <param name="Timestamp">UTC time of the reading.</param>
public record TemperatureResponse(string CityId, string City, string Country, double Celsius, double Fahrenheit, DateTime Timestamp);
