package main

import (
	"context"
	"log"
	"os"

	"edholm.dev/helgen/internal/website"
	"go.uber.org/zap"
)

func main() {
	logger, err := zap.NewDevelopment()
	if err != nil {
		log.Printf("Unable to create zap logger: %v", err)
		os.Exit(1)
	}

	ws := website.New(logger)
	err = ws.Run(context.Background())
	if err != nil {
		logger.Warn("Website failed to run", zap.Error(err))
	}
}
