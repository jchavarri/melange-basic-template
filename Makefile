project_name = melange-basic-template

DUNE = opam exec -- dune
MEL = opam exec -- mel

.DEFAULT_GOAL := help

.PHONY: help
help: ## Print this help message
	@echo "List of available make commands";
	@echo "";
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}';
	@echo "";

.PHONY: create-switch
create-switch:
	opam switch create . --deps-only --locked

.PHONY: init
init: create-switch install ## Configure everything to develop this repository in local
	yarn

.PHONY: install
install: ## Install development dependencies
	opam install . --deps-only --with-test
	opam pin add $(project_name).dev .
	opam lock .

.PHONY: build
build: ## Build the project
	$(MEL) build

.PHONY: start
start: ## Serve the application with a local HTTP server
	yarn server

.PHONY: clean
clean: ## Clean build artifacts and other generated files
	$(MEL) clean

.PHONY: format
format: ## Format the codebase with ocamlformat
	$(DUNE) build @fmt --auto-promote

.PHONY: format-check
format-check: ## Checks if format is correct
	$(DUNE) build @fmt

.PHONY: watch
watch: ## Watch for the filesystem and rebuild on every change
	$(MEL) build --watch
