FROM golang:1.18-alpine3.16

RUN apk add build-base
RUN apk add libpcap-dev
RUN apk update
RUN apk add openssl
RUN mkdir certs
RUN openssl req -x509 -newkey rsa:4096 -keyout certs/key.pem -out certs/chain.pem -sha256 -days 365 -nodes
RUN cp config.example.json config.json
WORKDIR /app

COPY go.mod go.sum config.json ./
COPY *.go ./
COPY certs ./certs/
COPY static ./static/

RUN go mod download
RUN go build -o ./out/app *.go

CMD [ "./out/app" ]