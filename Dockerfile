FROM node:14-alpine

WORKDIR /app

COPY package*.json ./

RUN npm install --production

RUN apk --no-cache --virtual build-dependencies add python make g++ \
    && npm install --production

COPY . .

RUN mkdir -p ./public ./data \
    && cd ./client \
    && npm run build \
    && cd .. \
    && mv ./client/build/* ./public \
    && rm -rf ./client \
    && apk del build-dependencies

EXPOSE 5005

ENV NODE_ENV=production

CMD ["node", "server.js"]