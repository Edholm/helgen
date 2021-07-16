APP_NAME      := helgen
BINARY_NAME   := app
BUILD_DIR     := ./build
SCRIPTS_DIR   := ./scripts
TEMPLATE_DIR  := ./web/template
TEMPLATE_NAME := template.jpg
STATIC_DIR    := ./web/static

.PHONY: all
all: \
	go-mod-tidy \
	gen-images \
	go-test \
	go-build

go-build: gen-images
	$(info [$@] building "${APP_NAME}"...)
	@rm -rf ${BUILD_DIR}/${APP_NAME}/
	@mkdir -p ${BUILD_DIR}/${APP_NAME}/
	@go build -o ${BUILD_DIR}/${APP_NAME}/${BINARY_NAME} ./cmd/${APP_NAME}/main.go

go-mod-tidy:
	$(info [$@] tidying up module...)
	@go mod tidy

go-test:
	$(info [$@] running the tests...)
	@go test -race ./...

gen-images:
	$(info [$@] generating images...)
	@${SCRIPTS_DIR}/generate-images.sh ${TEMPLATE_DIR}/${TEMPLATE_NAME} ${STATIC_DIR}

run-stack: go-build
	$(info [$@] running "${APP_NAME}"...)
	@cd ${BUILD_DIR}/${APP_NAME} && ./${BINARY_NAME}