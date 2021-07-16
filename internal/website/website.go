package website

import (
	"context"
	"errors"
	"fmt"
	"html/template"
	"io"
	"net/http"
	"time"

	"edholm.dev/helgen/web"

	"github.com/labstack/echo/v4"
	"go.uber.org/zap"
)

type Website struct {
	server *echo.Echo
	logger *zap.Logger
}

func New(logger *zap.Logger) *Website {
	return &Website{
		server: echo.New(),
		logger: logger,
	}
}

func (r *Website) Run(ctx context.Context) error {
	// Wait and do a clean shutdown
	go func() {
		<-ctx.Done()
		err := r.server.Shutdown(context.Background())
		if err != nil {
			r.logger.Warn("Unable to cleanly shutdown the HTTP server", zap.Error(err))
		}
	}()

	t := &Template{
		templates: template.Must(template.ParseFS(web.Content, "template/*.gohtml")),
	}
	r.server.Renderer = t

	r.setupRoutes()

	err := r.server.Start("0.0.0.0:8080")
	if err != nil && !errors.Is(err, http.ErrServerClosed) {
		return fmt.Errorf("echo server failed: %w", err)
	}

	return nil
}

func (r *Website) setupRoutes() {
	r.server.GET("/static/*", echo.WrapHandler(http.FileServer(http.FS(web.Content))))
	r.server.GET("/", r.getRootHandler)
}

func (r *Website) getRootHandler(c echo.Context) error {
	data := struct {
		Day int
	}{
		Day: int(time.Now().Weekday()),
	}
	err := c.Render(http.StatusOK, "index.gohtml", data)
	if err != nil {
		r.logger.Warn("Rendering failed", zap.Error(err))
		return err
	}
	return nil
}

type Template struct {
	templates *template.Template
}

func (t *Template) Render(w io.Writer, name string, data interface{}, c echo.Context) error {
	return t.templates.ExecuteTemplate(w, name, data)
}
