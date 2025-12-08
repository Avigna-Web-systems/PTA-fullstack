FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["PTA.sln", "./"]
COPY ["src/PTA.Core/PTA.Core.csproj", "src/PTA.Core/"]
COPY ["src/PTA.Infrastructure/PTA.Infrastructure.csproj", "src/PTA.Infrastructure/"]
COPY ["src/PTA.API/PTA.API.csproj", "src/PTA.API/"]
RUN dotnet restore "PTA.sln"
COPY . .
WORKDIR /src/PTA.API
RUN dotnet publish "PTA.API.csproj" -c Release -o /app/publish
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app
COPY --from=build /app/publish .
ENV ASPNETCORE_URLS=http://+:80
EXPOSE 80
ENTRYPOINT ["dotnet", "PTA.API.dll"]
