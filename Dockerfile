FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy everything at once — this is the only way that works 100% with your repo
COPY . .

# Restore + build + publish in ONE command so we finally see the real error if it still fails
RUN dotnet publish src/PTA.API/PTA.API.csproj \
    -c Release \
    -o /app/publish \
    /p:UseAppHost=false

# Runtime image
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
EXPOSE 8080
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "PTA.API.dll"]
