FROM node:10

WORKDIR /app

COPY package.json package.json
COPY bin bin
COPY src src

RUN npm install

EXPOSE 80
CMD ["npm", "start"]