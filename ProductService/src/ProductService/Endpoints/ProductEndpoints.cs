using Microsoft.AspNetCore.Http.HttpResults;

namespace ProductService.Endpoints;

public static class ProductEndpoints
{
    private static readonly Product[] Products =
    [
        new(1, "Laptop", "Electronics", 1299.90m),
        new(2, "Smartphone", "Electronics", 899.00m),
        new(3, "Headphones", "Accessories", 199.50m),
        new(4, "Coffee Maker", "Home", 89.99m),
        new(5, "Running Shoes", "Sports", 129.00m),
    ];

    public static IEndpointRouteBuilder MapProductEndpoints(this IEndpointRouteBuilder app)
    {
        app.MapGet("/api/products", () => TypedResults.Ok(Products))
            .WithName("GetProducts")
            .WithTags("Products")
            .WithSummary("Lists all products");

        app.MapGet("/api/products/{id:int}", Results<Ok<Product>, NotFound> (int id) =>
                Products.FirstOrDefault(p => p.Id == id) is { } product
                    ? TypedResults.Ok(product)
                    : TypedResults.NotFound())
            .WithName("GetProductById")
            .WithTags("Products")
            .WithSummary("Gets a product by id");

        return app;
    }
}

public record Product(int Id, string Name, string Category, decimal Price);
