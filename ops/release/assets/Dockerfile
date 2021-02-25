FROM nginx:stable-alpine
LABEL maintainer="Dominique Lebrun <dominique.lebrun@belighted.com>"

RUN mkdir -p /app/public/assets
WORKDIR /app/public/assets

ADD ./public/assets /app/public/assets
ADD ./ops/release/assets/nginx.conf /etc/nginx/conf.d/default.conf
