FROM nginx:1.19.0-alpine

RUN adduser -D -H -u 1005 -s /bin/bash -Gwww-data www-data

COPY ./wordpress.conf.template /etc/nginx/templates/ 

RUN rm /etc/nginx/conf.d/default.conf
