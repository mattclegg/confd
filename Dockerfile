FROM golang:alpine as builder

RUN mkdir -p /go/src/github.com/kelseyhightower/confd \
  && ln -s /go/src/github.com/kelseyhightower/confd /app

COPY . /app
WORKDIR /app

ENV GOOS=linux
ENV GOARCH=amd64
ENV CGO_ENABLED=0

RUN apk add --no-cache \
    make \
    git \
    dep \
  && dep ensure \
  && go build -o bin/confd

FROM alpine:latest

LABEL org.label-schema.name="confd" \
        org.label-schema.vendor="Mattclegg" \
        org.label-schema.description="Docker confd, built on Alpine Linux. confd is a lightweight configuration management tool." \
        org.label-schema.vcs-url="https://github.com/mattclegg/confd" \
        org.label-schema.version="alpine" \
        org.label-schema.license="MIT"

COPY --from=builder /app/bin/confd /bin/
