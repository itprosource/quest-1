FROM node:10

WORKDIR /app

COPY package.json package.json

RUN npm install

COPY bin bin
COPY src src

EXPOSE 3000

#Inject secret word. Value stored in Github secrets and called via workflow action
ARG SECRET_WORD="default"
ENV SECRET_WORD=${SECRET_WORD}

CMD ["npm", "start"]