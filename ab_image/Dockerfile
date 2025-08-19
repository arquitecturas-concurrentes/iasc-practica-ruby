FROM alpine:latest

ENV TERM=linux
RUN apk --no-cache add apache2-utils vim
RUN apk add --update bash && rm -rf /var/cache/apk/*

RUN mkdir scripts
COPY . ./scripts

RUN adduser -D ab

RUN chown -R ab:ab scripts

USER ab

ENTRYPOINT [ "/bin/bash" ]