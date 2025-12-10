FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy absolutely everything (your repo layout is special)
COPY . .

# ONE SINGLE COMMAND — this forces the real error to appear if something is wrong
RUN dotnet publish src/PTA.API/PTA.API.csproj -c Release -o /app/publish /p:UseAppHost=false

# Runtime
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
EXPOSE 80
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "PTA.API.dll"]
