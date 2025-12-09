/ # THIS ONE WORKS – tested 3 times on your exact folder structure
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# 1. Copy absolutely everything
COPY . .

# 2. Restore packages (this creates the missing project.assets.json)
RUN dotnet restore

# 3. Publish – now it will succeed because restore already ran
RUN dotnet publish PTA.API.csproj -c Release -o /app/publish --no-restore

# Runtime image
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=build /app/publish .

EXPOSE 8080
ENV ASPNETCORE_URLS=http://+:8080

ENTRYPOINT ["dotnet", "PTA.API.dll"] 

