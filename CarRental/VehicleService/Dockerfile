FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src
COPY src/VehicleService/VehicleService.csproj src/VehicleService/
RUN dotnet restore src/VehicleService/VehicleService.csproj
COPY . .
RUN dotnet publish src/VehicleService/VehicleService.csproj -c Release -o /app/publish --no-restore /p:UseAppHost=false

FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS final
WORKDIR /app
ENV ASPNETCORE_HTTP_PORTS=8080
EXPOSE 8080
COPY --from=build /app/publish .
USER $APP_UID
ENTRYPOINT ["dotnet", "VehicleService.dll"]
