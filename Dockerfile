FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

COPY src/PTA.API/PTA.API.csproj src/PTA.API/
COPY src/PTA.Core/PTA.Core.csproj src/PTA.Core/
COPY src/PTA.Infrastructure/PTA.Infrastructure.csproj src/PTA.Infrastructure/

RUN dotnet restore src/PTA.API/PTA.API.csproj

COPY src/ src/

# FORCE FULL LOGGING
RUN dotnet publish src/PTA.API/PTA.API.csproj \
    -c Release \
    -o /app/publish \
    /p:UseAppHost=false \
    -bl:/tmp/publish.binlog || true

# ---------- RUNTIME STAGE ----------
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app

COPY --from=build /app/publish .

EXPOSE 8080
ENTRYPOINT ["dotnet", "PTA.API.dll"]
