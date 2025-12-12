### BUILD STAGE ###
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

COPY . .

# Restore solution
RUN dotnet restore PTA.sln

# Publish the API project
RUN echo "=== Restoring ===" && \
    dotnet restore PTA.sln && \
    echo "=== Publishing ===" && \
    dotnet publish src/PTA.API/PTA.API.csproj -c Release -o /app/publish -v detailed


### RUNTIME STAGE ###
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app

# Expose the Render port
EXPOSE 5000

# Set ASP.NET Core to bind to Render port
ENV ASPNETCORE_URLS=http://0.0.0.0:5000

# Copy output from build stage
COPY --from=build /app/publish .

# Start API
ENTRYPOINT ["dotnet", "PTA.API.dll"]
