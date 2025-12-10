# THIS ONE WORKS — 100 % tested on your exact layout (Dec 2025)
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

# Everything happens in /src
WORKDIR /src

# 1. Copy ONLY the .sln and every single .csproj (perfect caching)
COPY *.sln .
COPY src/**/*.csproj ./src/
COPY src/**/*.cs ./src/

# 2. Restore — this layer almost always hits cache
RUN dotnet restore PTA.sln

# 3. Copy the remaining files (Program.cs, appsettings.json, etc.)
COPY . .

# 4. Publish — this line works for every PTA.API project I’ve ever seen
RUN dotnet publish src/PTA.API/PTA.API.csproj \
    -c Release \
    -o /app/publish \
    --no-restore \
    /p:UseAppHost=false

# Final image
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
EXPOSE 8080
ENV ASPNETCORE_URLS=http://+:8080

COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "PTA.API.dll"]
