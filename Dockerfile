FROM alpine:latest

WORKDIR /app

RUN apk add roswell --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing
RUN apk add make bash
RUN ros install sbcl-bin

# Load dependencies
RUN echo '(ql:quickload :mito)' | ros run
RUN echo '(ql:quickload :clack)' | ros run
RUN echo '(ql:quickload :ningle)' | ros run
RUN echo '(ql:quickload :ten)' | ros run
RUN echo '(ql:quickload :cmark)' | ros run
RUN echo '(ql:quickload :str)' | ros run

RUN apk add clang
RUN apk add cmark-dev libev-dev sqlite-dev libc-dev
COPY . /app

EXPOSE 5000
CMD [ "ros", "start.ros" ]
