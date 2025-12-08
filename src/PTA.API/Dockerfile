# Build Stage: Restore and Build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy csproj and restore (caches layers for faster rebuilds)
COPY ["PTA.API/PTA.API.csproj", "PTA.API/"]
RUN dotnet restore "PTA.API/PTA.API.csproj"

# Copy full source code
COPY . .

# Set working directory to the project folder
WORKDIR "/src/PTA.API"

# Build the project
RUN dotnet build "PTA.API.csproj" -c Release -o /app/build

# Publish Stage: Optimize for production
FROM build AS publish
WORKDIR "/src/PTA.API"
RUN dotnet publish "PTA.API.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Runtime Stage: Lightweight ASP.NET runtime
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app
COPY --from=publish /app/publish .
EXPOSE 80  # Or 8080 if needed
ENTRYPOINT ["dotnet", "PTA.API.dll"]
