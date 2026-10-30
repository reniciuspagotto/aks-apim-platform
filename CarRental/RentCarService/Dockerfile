FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src
COPY src/RentCarService/RentCarService.csproj src/RentCarService/
RUN dotnet restore src/RentCarService/RentCarService.csproj
COPY . .
RUN dotnet publish src/RentCarService/RentCarService.csproj -c Release -o /app/publish --no-restore /p:UseAppHost=false

FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS final
WORKDIR /app
ENV ASPNETCORE_HTTP_PORTS=8080
EXPOSE 8080
COPY --from=build /app/publish .
USER $APP_UID
ENTRYPOINT ["dotnet", "RentCarService.dll"]
