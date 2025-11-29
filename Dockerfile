# ---- Build stage ----
FROM node:18 as build

WORKDIR /app

# Kopiujemy package.json i package-lock.json
COPY package*.json ./

# Instalujemy zależności
RUN npm install

# Kopiujemy cały projekt
COPY . .

# Budujemy aplikację React
RUN npm run build

# ---- Production stage ----
FROM nginx:alpine

# Usuwamy domyślny nginx index
RUN rm -rf /usr/share/nginx/html/*

# Kopiujemy pliki z buildu Reacta
COPY --from=build /app/build /usr/share/nginx/html

# Otwieramy port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
