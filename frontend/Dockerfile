FROM node:20 AS build

ARG REACT_APP_BASE_URL

ENV REACT_APP_BASE_URL=${REACT_APP_BASE_URL}

WORKDIR /app

COPY package*.json ./

RUN npm install --legacy-peer-deps

COPY . .

RUN npm run build 

FROM nginx:alpine

COPY --from=build /app/build /usr/share/nginx/html

COPY nginx.conf /etc/nginx/nginx.conf

COPY mern-shop.conf /etc/nginx/conf.d/default.conf

COPY env.sh /docker-entrypoint.d/env.sh

RUN chmod +x /docker-entrypoint.d/env.sh

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
