.PHONY: dev test release

dev:
	@mkdir -p build/debug
	@go build -o build/debug/main
	@CONTENT_DIR=/workspaces/static-content-lambda/static_demo exec /usr/bin/aws-lambda-rie build/debug/main

release:
	@mkdir -p release/latest
	@CGO_ENABLED=0 GOOS=linux go build -trimpath -o release/latest/lambda-static-server
	@chmod +x release/latest/lambda-static-server

test:
	@cat test_payloads/root.json  | curl -X POST "http://localhost:8080/2015-03-31/functions/function/invocations" --data-binary @-
	@cat test_payloads/css.json  | curl -X POST "http://localhost:8080/2015-03-31/functions/function/invocations" --data-binary @-

