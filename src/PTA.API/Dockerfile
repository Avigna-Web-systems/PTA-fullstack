# syntax = docker/dockerfile:1
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy the solution file
COPY PTA.sln .

# Copy all project files
COPY src/PTA.API/PTA.API.csproj src/PTA.API/
COPY src/PTA.Core/PTA.Core.csproj src/PTA.Core/
COPY src/PTA.Infrastructure/PTA.Infrastructure.csproj src/PTA.Infrastructure/
COPY tests/PTA.Tests/PTA.Tests.csproj tests/PTA.Tests/

# Restore (this layer will be cached)
RUN dotnet restore

# Copy everything else
COPY . .

# Publish the API project
WORKDIR /src/src/PTA.API
RUN dotnet publish PTA.API.csproj -c Release -o /app/publish --no-restore /p:UseAppHost=false

# Runtime image
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=build /app/publish .

EXPOSE 8080
ENV ASPNETCORE_URLS=http://+:8080

ENTRYPOINT ["dotnet", "PTA.API.dll"]
