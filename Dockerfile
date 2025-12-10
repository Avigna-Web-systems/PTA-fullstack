FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy everything once and for all
COPY . .

# THIS SINGLE LINE WILL SHOW THE EXACT C# ERROR IN THE GITHUB LOG
RUN dotnet publish src/PTA.API/PTA.API.csproj -c Release -o /app/publish /p:UseAppHost=false || \
    (echo "BUILD FAILED — REAL ERRORS BELOW:" && \
     find . -name "*.csproj" -exec dotnet build "{}" -c Release -v normal \; 2>&1 | tail -200 && \
     exit 1)

FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "PTA.API.dll"]
