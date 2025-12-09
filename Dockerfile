FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app

COPY *.csproj ./
COPY ../PTA.Core/*.csproj ../PTA.Core/
COPY ../PTA.Infrastructure/*.csproj ../PTA.Infrastructure/

RUN dotnet restore

COPY . .

RUN dotnet publish -c Release -o /publish --no-restore

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=build /publish .
EXPOSE 8080
ENV ASPNETCORE_URLS=http://+:8080
ENTRYPOINT ["dotnet", "PTA.API.dll"]
