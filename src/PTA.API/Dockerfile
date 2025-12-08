# ---------- Build Stage ----------
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy only the .csproj file first (best practice for Docker layer caching)
COPY PTA.API/*.csproj ./PTA.API/

# Restore NuGet packages
RUN dotnet restore "PTA.API/PTA.API.csproj"

# Copy the rest of the source code
COPY . .

# Build and publish
WORKDIR /src/PTA.API
RUN dotnet publish "PTA.API.csproj" -c Release -o /app/publish --no-restore /p:UseAppHost=false

# ---------- Runtime Stage ----------
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app

# Copy published files from build stage
COPY --from=build /app/publish .

# Expose port correctly (this was the cause of your second error)
EXPOSE 8080

# Run the app on port 8080 (ASP.NET Core defaults to 8080 in Docker)
ENV ASPNETCORE_URLS=http://+:8080

ENTRYPOINT ["dotnet", "PTA.API.dll"]
