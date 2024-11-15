FROM node:20-alpine

ARG PORT=8000

ENV PORT=${PORT}

WORKDIR /app

COPY package*.json .

RUN npm install

COPY . .

EXPOSE ${PORT}

CMD ["npm", "start"]
