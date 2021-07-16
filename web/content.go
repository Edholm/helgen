package web

import "embed"

// Content holds our static web server content, like templates, images, and such.
//go:embed static template/index.gohtml
var Content embed.FS //nolint:gochecknoglobals
