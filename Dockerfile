FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY . .

# THIS WILL PRINT EVERY SINGLE ERROR LINE — GITHUB CANNOT HIDE IT
RUN echo "===== LISTING ALL PROJECT FILES =====" && \
    find src -name "*.csproj" | head -20 && \
    echo "===== CONTENT OF PTA.API.csproj =====" && \
    cat src/PTA.API/PTA.API.csproj && \
    echo "===== DOTNET --info =====" && \
    dotnet --info && \
    echo "===== TRYING TO RESTORE =====" && \
    dotnet restore PTA.sln && \
    echo "===== TRYING TO BUILD (ALL OUTPUT VISIBLE) =====" && \
    dotnet build src/PTA.API/PTA.API.csproj -c Release -v detailed

FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "PTA.API.dll"]


