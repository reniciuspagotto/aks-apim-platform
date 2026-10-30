using Microsoft.AspNetCore.Http.HttpResults;

namespace VehicleService.Endpoints;

public static class VehicleEndpoints
{
    private static readonly Vehicle[] Vehicles =
    [
        new(1, "Toyota", "Corolla", 2024),
        new(2, "Honda", "Civic", 2023),
        new(3, "Volkswagen", "Golf", 2022),
        new(4, "Ford", "Mustang", 2024),
        new(5, "Tesla", "Model 3", 2025),
    ];

    public static IEndpointRouteBuilder MapVehicleEndpoints(this IEndpointRouteBuilder app)
    {
        app.MapGet("/api/vehicles", () => TypedResults.Ok(Vehicles))
            .WithName("GetVehicles")
            .WithTags("Vehicles")
            .WithSummary("Lists all vehicles");

        app.MapGet("/api/vehicles/{id:int}", Results<Ok<Vehicle>, NotFound> (int id) =>
                Vehicles.FirstOrDefault(v => v.Id == id) is { } vehicle
                    ? TypedResults.Ok(vehicle)
                    : TypedResults.NotFound())
            .WithName("GetVehicleById")
            .WithTags("Vehicles")
            .WithSummary("Gets a vehicle by id");

        return app;
    }
}

public record Vehicle(int Id, string Brand, string Model, int Year);
