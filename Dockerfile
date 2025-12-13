FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

COPY src/PTA.API/PTA.API.csproj src/PTA.API/
COPY src/PTA.Core/PTA.Core.csproj src/PTA.Core/
COPY src/PTA.Infrastructure/PTA.Infrastructure.csproj src/PTA.Infrastructure/

RUN dotnet restore src/PTA.API/PTA.API.csproj

COPY src/ src/

# 🔴 THIS MUST SUCCEED OR DOCKER STOPS
RUN dotnet publish src/PTA.API/PTA.API.csproj \
    -c Release \
    -o /app/publish \
    /p:UseAppHost=false \
    -v minimal

# 🔴 PROOF
RUN echo "===== PUBLISH FOLDER CONTENT =====" && ls -R /app

FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build /app/publish .
EXPOSE 8080
ENTRYPOINT ["dotnet", "PTA.API.dll"]
