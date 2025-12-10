# Build stage
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy solution file and all csproj files first (best caching)
COPY src/PTA.sln .                     # ← .sln is inside src folder in your repo
COPY src/**/*.csproj ./src/            # restore all projects in correct folders

# Restore (now PTA.sln exists at /src/PTA.sln)
RUN dotnet restore PTA.sln

# Copy the rest of the source code
COPY src/ ./src/

# Publish the API project (change if your project name differs)
RUN dotnet publish src/PTA.API/PTA.API.csproj -c Release -o /app/publish --no-restore

# Final runtime image
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
EXPOSE 8080

COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "PTA.API.dll"]
