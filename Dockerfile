FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src
COPY src/AzAppAksApim/AzAppAksApim.csproj src/AzAppAksApim/
RUN dotnet restore src/AzAppAksApim/AzAppAksApim.csproj
COPY . .
RUN dotnet publish src/AzAppAksApim/AzAppAksApim.csproj -c Release -o /app/publish --no-restore /p:UseAppHost=false

FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS final
WORKDIR /app
ENV ASPNETCORE_HTTP_PORTS=8080
EXPOSE 8080
COPY --from=build /app/publish .
USER $APP_UID
ENTRYPOINT ["dotnet", "AzAppAksApim.dll"]
