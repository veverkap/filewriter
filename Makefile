NAME ?= $(shell basename "$(CURDIR)")
GIT_COMMIT ?= $(shell git rev-parse --short HEAD)
BUILD = $(BUILD_NUMBER)
BUILD_CNT = $(BUILD_COUNTER)
ARTIFACT_URL = $(DOCKER_URL)
ARTIFACT_ORG = $(DOCKER_ORG)
ARTIFACT_USER = $(DOCKER_USER)
ARTIFACT_PASS = $(DOCKER_PASS)
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
	GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o "bin/$(NAME)" -ldflags $(EFFECTIVE_LD_FLAGS) .

.PHONY: bin
bin: bin/$(NAME) ## Build application binary

.PHONY:pkg
pkg: pkg/$(NAME).tar.gz ## Build application 'serviceball'

bin/$(NAME): $(SOURCE_FILES)
	CGO_ENABLED=0 go build -o "bin/$(NAME)" -ldflags $(EFFECTIVE_LD_FLAGS) .

pkg/$(NAME).tar.gz: bin/$(NAME)
	mkdir -p pkg/
	tar -czf pkg/$(NAME).tar.gz --xform='s,bin/,,' --xform='s,_build/,,' $(PKG_DIRS)

.PHONY: clean
clean: ## Clean temporary data
	rm -r $(CURDIR)/bin
	rm -r $(CURDIR)/pkg

.PHONY: modules
modules: ## Download and verify modules
	go mod download && go mod verify

.PHONY: docker
docker:
	docker build -t veverkap/filewriter:${GIT_COMMIT} .
	docker push veverkap/filewriter:${GIT_COMMIT}
	docker push veverkap/filewriter:latest
