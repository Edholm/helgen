BINARY_NAME   := app
BUILD_DIR     := ./build
RESOURCES_DIR := ./resources
TEMPLATE_NAME := template.jpg

.PHONY: all
all: \
	go-mod-tidy \
	gen-images \
	go-test \
	go-build

go-build: gen-images
	$(info [$@] building the app...)
	@go build -o ${BUILD_DIR}/${BINARY_NAME} ./...

go-mod-tidy:
	$(info [$@] tidying up module...)
	@go mod tidy

go-test:
	$(info [$@] running the tests...)
	@go test -race ./...

gen-images:
	$(info [$@] generating images...)
	@cd ${RESOURCES_DIR} && ./generate-images.sh ${TEMPLATE_NAME}

run-stack: go-build
	$(info [$@] running the app...)
	@${BUILD_DIR}/${BINARY_NAME}