# syntax=docker/dockerfile:1.3-labs

FROM alpine:latest

WORKDIR /app

RUN apk add roswell --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing
RUN apk add make bash
RUN ros install sbcl-bin

COPY simplr.asd /app

# Load dependencies and preload them to cache them
RUN ros run <<EOF
  (load "simplr.asd")

  (dolist (dep (asdf:system-depends-on (asdf:find-system 'simplr))) ; ' <= Fix highlighting
    (ql:quickload dep))
EOF

RUN apk add clang
RUN apk add cmark-dev libev-dev sqlite-dev libc-dev
COPY . /app

EXPOSE 5000
CMD [ "ros", "start.ros" ]
