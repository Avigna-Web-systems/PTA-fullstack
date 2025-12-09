FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy csproj files (using exact paths with dots)
COPY src/PTA.API/*.csproj ./PTA.API/
COPY src/PTA.Core/*.csproj ./PTA.Core/
COPY src/PTA.Infrastructure/*.csproj ./PTA.Infrastructure/

RUN dotnet restore ./PTA.API/PTA.API.csproj

# Copy source folders (with dots)
COPY src/PTA.API/ ./PTA.API/
COPY src/PTA.Core/ ./PTA.Core/
COPY src/PTA.Infrastructure/ ./PTA.Infrastructure/

# Publish
RUN dotnet publish ./PTA.API/PTA.API.csproj -c Release -o /app/publish --no-restore

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=build /app/publish .
EXPOSE 8080
ENV ASPNETCORE_URLS=http://+:8080
ENTRYPOINT ["dotnet", "PTA.API.dll"]
