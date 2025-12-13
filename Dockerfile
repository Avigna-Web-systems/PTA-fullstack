FROM mcr.microsoft.com/dotnet/sdk:8.0

WORKDIR /src

# Copy everything
COPY . .

# Print structure (VERY IMPORTANT)
RUN echo "===== DIRECTORY STRUCTURE =====" && ls -R . 

# Restore
RUN dotnet restore PTA.sln

# Build with full error output
RUN dotnet build src/PTA.API/PTA.API.csproj -c Release -v normal

