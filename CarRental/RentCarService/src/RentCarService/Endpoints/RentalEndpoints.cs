using System.Collections.Concurrent;
using Microsoft.AspNetCore.Http.HttpResults;

namespace RentCarService.Endpoints;

public static class RentalEndpoints
{
    private static readonly ConcurrentDictionary<int, Rental> Rentals = new();
    private static int _lastId;

    public static IEndpointRouteBuilder MapRentalEndpoints(this IEndpointRouteBuilder app)
    {
        app.MapPost("/api/rentals", (RentalRequest request) =>
            {
                var id = Interlocked.Increment(ref _lastId);
                var rental = new Rental(id, request.VehicleId, request.UserId, DateTime.UtcNow);
                Rentals[id] = rental;

                return TypedResults.Created($"/api/rentals/{id}", rental);
            })
            .WithName("CreateRental")
            .WithTags("Rentals")
            .WithSummary("Rents a vehicle for a user");

        app.MapGet("/api/rentals", () => TypedResults.Ok(Rentals.Values.OrderBy(r => r.Id).ToArray()))
            .WithName("GetRentals")
            .WithTags("Rentals")
            .WithSummary("Lists all rentals");

        app.MapGet("/api/rentals/{id:int}", Results<Ok<Rental>, NotFound> (int id) =>
                Rentals.TryGetValue(id, out var rental)
                    ? TypedResults.Ok(rental)
                    : TypedResults.NotFound())
            .WithName("GetRentalById")
            .WithTags("Rentals")
            .WithSummary("Gets a rental by id");

        return app;
    }
}

public record RentalRequest(int VehicleId, int UserId);

public record Rental(int Id, int VehicleId, int UserId, DateTime CreatedAt);
