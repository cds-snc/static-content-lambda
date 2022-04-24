package main

import (
	"net/http"
	"os"

	"github.com/aws/aws-lambda-go/lambda"
	"github.com/awslabs/aws-lambda-go-api-proxy/httpadapter"
)

func main() {

	// Static dir from ENV
	static_dir := "/var/www/html"
	if static_dir_env := os.Getenv("CONTENT_DIR"); static_dir_env != "" {
		static_dir = static_dir_env
	}

	fs := http.FileServer(http.Dir(static_dir))
	http.Handle("/", fs)
	lambda.Start(httpadapter.NewV2(http.DefaultServeMux).ProxyWithContext)
}
