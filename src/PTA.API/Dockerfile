# ---------- Build Stage ----------
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy solution + every single .csproj exactly where they are on disk
COPY PTA.sln .
COPY src/PTA.API/PTA.API.csproj src/PTA.API/
COPY src/PTA.Core/PTA.Core.csproj src/PTA.Core/
COPY src/PTA.Infrastructure/PTA.Infrastructure.csproj src/PTA.Infrastructure/
COPY tests/PTA.Tests/PTA.Tests.csproj tests/PTA.Tests/

# Restore (this layer is cached forever unless csproj changes)
RUN dotnet restore

# Copy absolutely everything else
COPY . .

# Publish – correct path, no extra "src" duplication
WORKDIR /src/src/PTA.API
RUN dotnet publish PTA.API.csproj -c Release -o /app/publish --no-restore

# ---------- Runtime Stage ----------
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=build /app/publish .

EXPOSE 8080
ENV ASPNETCORE_URLS=http://+:8080

ENTRYPOINT ["dotnet", "PTA.API.dll"]
