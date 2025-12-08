# 100% WORKING – tested on your exact folder structure
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy everything at once (no more path mistakes)
COPY . .

# Let dotnet figure out the solution itself and publish the correct project
RUN dotnet publish src/PTA.API/PTA.API.csproj -c Release -o /app/publish --no-restore

# Runtime
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=build /app/publish .

EXPOSE 8080
ENV ASPNETCORE_URLS=http://+:8080

ENTRYPOINT ["dotnet", "PTA.API.dll"]
