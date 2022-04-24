package main

import (
	"net/http"
	"os"

	"github.com/aws/aws-lambda-go/lambda"
	"github.com/awslabs/aws-lambda-go-api-proxy/httpadapter"
)

func addDefaultHeaders(w http.ResponseWriter) http.ResponseWriter {
	// HSTS
	w.Header().Set("Strict-Transport-Security", "max-age=31536000; includeSubDomains; preload")
	// X-Frame-Options
	w.Header().Set("X-Frame-Options", "SAMEORIGIN")
	// X-Content-Type-Options
	w.Header().Set("X-Content-Type-Options", "nosniff")
	// Referrer-Policy
	w.Header().Set("Referrer-Policy", "no-referrer-when-downgrade")

	return w
}

func addSecurityHeaders(h http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w = addDefaultHeaders(w)
		h.ServeHTTP(w, r)
	})
}

func main() {

	// Static dir from ENV
	static_dir := "/var/www/html"
	if static_dir_env := os.Getenv("CONTENT_DIR"); static_dir_env != "" {
		static_dir = static_dir_env
	}

	fs := http.FileServer(http.Dir(static_dir))
	http.Handle("/", addSecurityHeaders(fs))
	lambda.Start(httpadapter.NewV2(http.DefaultServeMux).ProxyWithContext)
}
