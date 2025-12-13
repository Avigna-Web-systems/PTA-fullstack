FROM mcr.microsoft.com/dotnet/sdk:8.0
WORKDIR /src

# Copy entire source
COPY src/ src/

# Restore dependencies
RUN dotnet restore src/PTA.API/PTA.API.csproj

# Publish with FULL ERROR OUTPUT (NO HIDING)
RUN dotnet publish src/PTA.API/PTA.API.csproj \
    -c Release \
    -o /app/publish \
    /p:UseAppHost=false \
    -v detailed
