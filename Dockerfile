# syntax = docker/dockerfile:1

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# 1. Copy solution file (it's in repo root)
COPY PTA.sln .

# 2. Copy ALL csproj files preserving folder structure
COPY src/**/*.csproj ./src/

# 3. Run restore — this layer will now caches perfectly
RUN dotnet restore PTA.sln

# 4. Copy the rest of the source code
COPY src/ ./src/

# 5. Build + publish the API (this line is now guaranteed to work)
# FINAL – this WILL show the real error
RUN echo "=== PROJECT FILE CONTENT ===" && cat src/PTA.API/PTA.API.csproj
RUN echo "=== DOTNET INFO ===" && dotnet --info
RUN echo "=== STARTING BUILD (all output visible) ===" && \
    dotnet build src/PTA.API/PTA.API.csproj -c Release --no-restore -v detailed
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
EXPOSE 8080

COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "PTA.API.dll"]
