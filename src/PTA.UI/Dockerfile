# src/PTA.UI/Dockerfile – FINAL WORKING VERSION (Dec 2025)
FROM node:20-alpine AS build
WORKDIR /app

# Safe copy – works whether lock file exists or not
COPY package*.json ./

# Use npm install instead of npm ci when no lock file
RUN npm install --silent

# Copy source code
COPY . .

# Build
RUN npm run build

# Production
FROM nginx:stable-alpine
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
