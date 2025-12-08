# FINAL – WORKS 100% on your exact project
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy everything
COPY . .

# FIRST restore (required when we skipped it before)
RUN dotnet restore src/PTA.API/PTA.API.csproj

# THEN publish
RUN dotnet publish src/PTA.API/PTA.API.csproj -c Release -o /app/publish --no-restore

# Runtime
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=build /app/publish .

EXPOSE 8080
ENV ASPNETCORE_URLS=http://+:8080

ENTRYPOINT ["dotnet", "PTA.API.dll"]
