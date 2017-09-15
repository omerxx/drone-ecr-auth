FROM python:2.7-alpine

MAINTAINER omer@devops.co.il

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories
RUN pip install awscli
RUN apk update 
RUN apk add docker

