FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy the entire src folder at once (bypasses individual folder checksum errors)
COPY src/ ./src/
WORKDIR /src

# Restore the solution (uses PTA.sln for all projects)
RUN dotnet restore PTA.sln

# Publish the API project
RUN dotnet publish src/PTAAPI/PTAAPI.csproj -c Release -o /app/publish --no-restore

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=build /app/publish .
EXPOSE 8080
ENV ASPNETCORE_URLS=http://+:8080
ENTRYPOINT ["dotnet", "PTAAPI.dll"]
