# Build Stage
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy solution file
COPY PTA.sln .

# Copy project files
COPY src/PTA.Core/PTA.Core.csproj src/PTA.Core/
COPY src/PTA.Infrastructure/PTA.Infrastructure.csproj src/PTA.Infrastructure/
COPY src/PTA.API/PTA.API.csproj src/PTA.API/

# Restore
RUN dotnet restore PTA.sln

# Copy entire source
COPY . .

# Correct working directory
WORKDIR /src/PTA.API

# Publish API
RUN dotnet publish PTA.API.csproj -c Release -o /app/publish

# Runtime Stage
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "PTA.API.dll"]
