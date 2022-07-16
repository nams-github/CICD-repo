FROM node:alpine
WORKDIR '/app'
COPY package.json server.js ./
RUN npm install
RUN apk update && apk add bash
COPY . .
CMD ["node", "server.js"]
EXPOSE 8082
