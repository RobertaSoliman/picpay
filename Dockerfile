FROM mysql:latest
ARG ROOT_PASSWORD=admin
ENV MYSQL_ROOT_PASSWORD=${ROOT_PASSWORD}
ARG SETUP_DATABASE=picpay_db
ENV MYSQL_DATABASE=${SETUP_DATABASE}
EXPOSE 3306
CMD ["mysqld"]

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

FROM mongo:latest
ENV AUTH yes
ENV MONGODB_ADMIN_USER admin
ENV MONGODB_ADMIN_PASS admin
ENV MONGODB_APPLICATION_DATABASE picpay_db
ENV MONGODB_APPLICATION_USER picpay
ENV MONGODB_APPLICATION_PASS admin
EXPOSE 27017 27017
ADD run.sh /run.sh
ADD set_mongodb_password.sh /set_mongodb_password.sh
RUN chmod +x /run.sh
RUN chmod +x /set_mongodb_password.sh
CMD ["/run.sh"]




