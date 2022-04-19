FROM node:10

WORKDIR /app

COPY ./package.json /app/package.json
COPY ./bin /app/bin
COPY ./src /app/src

RUN npm install

EXPOSE 80
CMD ["npm", "start"]