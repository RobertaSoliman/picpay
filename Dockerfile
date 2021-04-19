FROM node:10.16-alpine

EXPOSE 19000
EXPOSE 19001
EXPOSE 19002
EXPOSE 19006
COPY ./ /picpay
WORKDIR /picpay/picpay
RUN apk update && apk add 
RUN npm install -g expo-cli
CMD npm i -f && npm start



