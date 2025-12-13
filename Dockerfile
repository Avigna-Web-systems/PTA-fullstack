FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

COPY src/PTA.API/PTA.API.csproj src/PTA.API/
COPY src/PTA.Core/PTA.Core.csproj src/PTA.Core/
COPY src/PTA.Infrastructure/PTA.Infrastructure.csproj src/PTA.Infrastructure/

RUN dotnet restore src/PTA.API/PTA.API.csproj

COPY src/ src/

# FORCE FULL LOGGING
RUN dotnet publish src/PTA.API/PTA.API.csproj \
    -c Release \
    -o /app/publish \
    /p:UseAppHost=false \
    -bl:/tmp/publish.binlog || true

# PRINT LOG AS TEXT (CANNOT BE HIDDEN)
RUN dotnet tool install -g dotnet-msbuildlog && \
    export PATH="$PATH:/root/.dotnet/tools" && \
    dotnet msbuildlog /tmp/publish.binlog || true
