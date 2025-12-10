# syntax = docker/dockerfile:1

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# 1. Copy the solution file from repository root
COPY PTA.sln .

# 2. Copy every single .csproj preserving folder structure (this is the correct glob)
COPY src/**/*.csproj ./src/

# 3. Restore as fast as possible (great caching)
RUN dotnet restore

# 4. Copy the rest of the source code
COPY src/ ./src/

# 5. Publish the backend API (change folder/name only if different)
RUN dotnet publish src/PTA.API/PTA.API.csproj -c Release -o /app/publish --no-restore

# Runtime image
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
EXPOSE 8080
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "PTA.API.dll"]
