FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

WORKDIR /src

# Copy solution file
COPY PTA.sln .

# Copy project files
COPY src/PTA.Core/PTA.Core.csproj src/PTA.Core/
COPY src/PTA.Infrastructure/PTA.Infrastructure.csproj src/PTA.Infrastructure/
COPY src/PTA.API/PTA.API.csproj src/PTA.API/

# Restore all projects in the solution
RUN dotnet restore PTA.sln

# Copy the remaining source code
COPY . .

# Publish API
WORKDIR /src/src/PTA.API
RUN dotnet publish PTA.API.csproj -c Release -o /app/publish


# -------- RUNTIME IMAGE --------
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app

COPY --from=build /app/publish .

ENV ASPNETCORE_URLS=http://+:80
EXPOSE 80

ENTRYPOINT ["dotnet", "PTA.API.dll"]

