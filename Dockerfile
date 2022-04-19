FROM node:10
WORKDIR /app
COPY ./package.json /app/package.json
RUN npm install --production
COPY ./bin /app/bin
COPY ./src /app/src
RUN echo $SECRET_WORD
ARG SECRET_WORD
ENV SECRET_WORD $SECRET_WORD
CMD ["npm", "start"]