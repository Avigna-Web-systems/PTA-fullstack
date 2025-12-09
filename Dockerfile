FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

COPY src/PTA.API/PTA.API.csproj ./PTA.API/
COPY src/PTA.Core/PTA.Core.csproj ./PTA.Core/
COPY src/PTA.Infrastructure/PTA.Infrastructure.csproj ./PTA.Infrastructure/

RUN dotnet restore ./PTA.API/PTA.API.csproj

COPY src/ .

# THIS IS THE ONLY LINE YOU CHANGED
RUN dotnet publish PTA.API.csproj -c Release -o /app/publish --no-restore

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=build /app/publish .
EXPOSE 8080
ENV ASPNETCORE_URLS=http://+:8080
ENTRYPOINT ["dotnet", "PTA.API.dll"]
