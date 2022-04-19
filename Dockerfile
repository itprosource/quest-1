FROM node:10

WORKDIR /app

COPY package.json package.json

RUN npm install

COPY bin bin
COPY src src

EXPOSE 80
CMD ["npm", "start"]