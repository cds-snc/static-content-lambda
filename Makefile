.PHONY: dev test release

dev:
	@mkdir -p build/debug
	@go build -o build/debug/main
	@CONTENT_DIR=/workspaces/static-content-lambda/static_demo exec /usr/bin/aws-lambda-rie build/debug/main

release:
	@mkdir -p release/latest
	@docker build -t static-content-lambda-build -f Dockerfile.build .
	@docker create -ti --name static-content-lambda-build static-content-lambda-build bash 
	@docker cp static-content-lambda-build:/lambda-static-server release/latest/lambda-static-server
	@docker rm -f static-content-lambda-build

test:
	@cat test_payloads/root.json  | curl -X POST "http://localhost:8080/2015-03-31/functions/function/invocations" --data-binary @-
	@cat test_payloads/css.json  | curl -X POST "http://localhost:8080/2015-03-31/functions/function/invocations" --data-binary @-

