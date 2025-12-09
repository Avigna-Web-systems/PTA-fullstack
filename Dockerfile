FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy csproj files – using real no-dot folder names
COPY src/PTAAPI/*.csproj ./PTAAPI/
COPY src/PTACore/*.csproj ./PTACore/
COPY src/PTAInfrastructure/*.csproj ./PTAInfrastructure/

RUN dotnet restore ./PTAAPI/PTAAPI.csproj

# Copy source code – real no-dot folders
COPY src/PTAAPI/ ./PTAAPI/
COPY src/PTACore/ ./PTACore/
COPY src/PTAInfrastructure/ ./PTAInfrastructure/

# Publish
RUN dotnet publish ./PTAAPI/PTAAPI.csproj -c Release -o /app/publish --no-restore

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=build /app/publish .
EXPOSE 8080
ENV ASPNETCORE_URLS=http://+:8080
ENTRYPOINT ["dotnet", "PTAAPI.dll"]
