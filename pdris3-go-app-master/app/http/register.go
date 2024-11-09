package http

import (
	"github.com/go-chi/chi/v5"
)

func RegisterHTTPEndpoints(router *chi.Mux) {
	router.Get("/health_ping", heathPing)

}
