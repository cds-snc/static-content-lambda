FROM golang:1.18-alpine as build

WORKDIR /app

COPY go.mod ./
COPY go.sum ./
RUN go mod download

COPY *.go ./

RUN CGO_ENABLED=0 GOOS=linux go build -trimpath -o /lambda-static-server


FROM scratch
COPY --from=build /lambda-static-server /lambda-static-server

WORKDIR /var/www/html
COPY /static_demo ./

ENTRYPOINT ["/lambda-static-server"]