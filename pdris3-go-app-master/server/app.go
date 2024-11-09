package server

import (
	"context"
	"github.com/go-chi/chi/v5"
	"github.com/go-chi/chi/v5/middleware"
	"log"
	"net/http"
	"os"
	"os/signal"
	"time"

	apphttp "test/app/http"
)

type App struct {
	httpServer *http.Server
}

func NewApp() *App {
	// bd
	return &App{}
}

func (a *App) Run(port string) error {
	router := chi.NewRouter()

	router.Use(middleware.Logger)
	apphttp.RegisterHTTPEndpoints(router)

	a.httpServer = &http.Server{
		Addr:           ":" + port,
		Handler:        router,
		ReadTimeout:    10 * time.Second,
		WriteTimeout:   10 * time.Second,
		MaxHeaderBytes: 1 << 20,
	}

	if err := http.ListenAndServe(":"+port, router); err != nil {
		log.Fatalf("Failed to listen and serve: %+v", err)
	}

	quit := make(chan os.Signal, 1)
	signal.Notify(quit, os.Interrupt, os.Interrupt)

	<-quit

	ctx, shutdown := context.WithTimeout(context.Background(), 5*time.Second)
	defer shutdown()

	return a.httpServer.Shutdown(ctx)

}
