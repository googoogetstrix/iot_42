FROM node:22-alpine

WORKDIR /app
COPY package*.json ./
# RUN npm ci --omit=dev
COPY ./srcs/* ./

CMD ["node", "server.js"]