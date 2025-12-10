# src/PTA.UI/Dockerfile  ←  THIS IS THE ONLY CORRECT VERSION
FROM node:20-alpine AS build
WORKDIR /app

# Copy from the context root (which is already ./src/PTA.UI)
COPY package.json ./
COPY package-lock.json* ./
RUN npm ci --silent

COPY . .
RUN npm run build

FROM nginx:stable-alpine
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
