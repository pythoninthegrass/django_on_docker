# syntax=docker/dockerfile:1.7

FROM nginx:1.27.0-alpine

ARG USER_NAME=nginx
ARG USER_UID=${UID:-1000}
ARG USER_GID=${GID:-$USER_UID}

RUN rm /etc/nginx/conf.d/default.conf

COPY nginx.conf /etc/nginx/nginx.conf

RUN apk add --no-cache shadow

RUN groupmod -g $USER_GID $USER_NAME \
    && usermod -u $USER_UID -g $USER_GID $USER_NAME

RUN chown -R nginx:nginx /var/cache/nginx /var/log/nginx /tmp

USER $USER_NAME
