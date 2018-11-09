FROM alpine

RUN apk update
RUN apk upgrade
RUN apk add curl bash

RUN apk add ruby ruby-bundler
RUN apk add nginx

RUN mkdir -p /config
WORKDIR /config

COPY . .

RUN bundle config --global silence_root_warning 1
RUN bundle install

RUN mkdir -p /run/nginx

EXPOSE 80 443

CMD './launch.sh'
