package main

import (
	"log"
	"test/config"
	"test/server"
)

func main() {
	cfg, err := config.LoadConfig()
	if err != nil {
		log.Fatal("cannot load config:", err)
	}

	app := server.NewApp()

	if err := app.Run(cfg.AppPort); err != nil {
		log.Fatalf("%s", err.Error())
	}
}
