NAME ?= $(shell basename "$(CURDIR)")
GIT_COMMIT ?= $(shell git rev-parse --short HEAD)
SOURCE_FILES = $(shell find $(CURDIR) -type f -name '*.go' | grep -v vendor/)
PKG_DIRS=bin/*

# Test all packages by default
TEST ?= ./...

EFFECTIVE_LD_FLAGS ?= "-X main.GitCommit=$(GIT_COMMIT) $(LD_FLAGS)"

ifeq ($(shell go env GOOS),darwin)
SEDOPTS = -i ''
else
SEDOPTS = -i
endif

.PHONY: linux
linux: ## Build a linux/amd64 version of the binary (mainly used for local development)
  GOOS=linux GOARCH=arm GOARM=7 CGO_ENABLED=0 go build -o "bin/$(NAME)" -ldflags $(EFFECTIVE_LD_FLAGS) .

.PHONY: bin
bin: bin/$(NAME) ## Build application binary

.PHONY:pkg
pkg: pkg/$(NAME).tar.gz ## Build application 'serviceball'

bin/$(NAME): $(SOURCE_FILES)
	GOOS=linux GOARCH=arm GOARM=7 CGO_ENABLED=0 go build -o "bin/$(NAME)" -ldflags $(EFFECTIVE_LD_FLAGS) .

.PHONY: clean
clean: ## Clean temporary data
	rm -r $(CURDIR)/bin

.PHONY: docker
docker:
	docker build -t veverkap/filewriter:${GIT_COMMIT} .
	docker push veverkap/filewriter:${GIT_COMMIT}
	docker push veverkap/filewriter
