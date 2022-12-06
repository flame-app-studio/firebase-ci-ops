FROM node:16.18-alpine3.15

RUN npm install -g firebase-tools

COPY entrypoint.sh /usr/local/bin

ENTRYPOINT ["entrypoint.sh"]
