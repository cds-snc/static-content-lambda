# Static content lambda

Because sometimes you just want to host static content inside an AWS lambda. 

## How it works

All this Go program does is wrap `http.FileServer` inside an AWS lambda handler that can interpret API Gateway requests, and tranforms the response into something API Gateway can return to the user.

It assumes that the static content is served from `/var/www/html`, however, that path can be changed with the `CONTENT_DIR` environment variable.

## Usage

The `Dockerfile` in this repo includes an example of how to use this server with the content located in `static_demo`, however, in production, you could just download the file binary directly without needing to compile it. This would look something like this:

```
FROM scratch
ADD https://github.com/cds-snc/static-content-lambda/release/latest/lamba-static-server /lamba-static-server

WORKDIR /var/www/html
COPY /content ./

ENTRYPOINT ["/lambda-static-server"]
```

## License
MIT