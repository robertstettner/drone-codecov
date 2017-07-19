FROM alpine:3.4

RUN apk upgrade --no-cache && apk add --no-cache bash curl git coreutils ca-certificates
RUN curl -L https://codecov.io/bash > codecov && \
    chmod +x codecov && \
    mv ./codecov /bin

ADD ./entrypoint.sh /bin

ENTRYPOINT ["entrypoint.sh"]
