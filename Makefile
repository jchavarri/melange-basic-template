project_name = melange-basic-template

DUNE = opam exec -- dune
MEL = opam exec -- mel
RESCRIPT = yarn rescript
TIME = time

.DEFAULT_GOAL := help

.PHONY: help
help: ## Print this help message
	@echo "List of available make commands";
	@echo "";
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}';
	@echo "";

.PHONY: create-switch
create-switch:
	opam switch create . 4.14.0 --deps-only --locked

.PHONY: init
init: create-switch install pins ## Configure everything to develop this repository in local
	yarn

.PHONY: pins
pins: ## Pin development dependencies
	opam pin add $(project_name).dev .

.PHONY: install
install: ## Install development dependencies
	opam install . --deps-only --with-test --locked
	opam lock .

.PHONY: build-dune
build-dune: ## Build the project with Dune and Melange using library stanzas
	cp dune-library dune && cp src/dune-library src/dune && cp lib1/dune-library lib1/dune && cp lib2/dune-library lib2/dune
	$(DUNE) build

.PHONY: clean-dune
clean-dune: ## Clean Dune build artifacts and other generated files
	$(DUNE) clean

.PHONY: build-melange
build-melange: ## Build the project with Melange
	rm -f dune && rm -f src/dune && rm -f lib1/dune && rm -f lib2/dune
	rm -rf lib && rm -rf src/lib && rm -rf lib1/lib && rm -rf lib2/lib
	$(MEL) build

.PHONY: clean-melange
clean-melange: ## Clean Melange build artifacts and other generated files
	$(MEL) clean

.PHONY: build-rescript
build-rescript: ## Build the project with ReScript
	$(RESCRIPT) build

.PHONY: clean-rescript
clean-rescript: ## Clean Rescript build artifacts and other generated files
	$(RESCRIPT) clean

.PHONY: clean
clean: clean-melange clean-rescript clean-dune ## Clean build artifacts and other generated files

.PHONY: start-benchmark
start-benchmark: clean ## Benchmark builds with three setups 
	$(TIME) $(MAKE) build-rescript
	$(MAKE) clean
	$(TIME) $(MAKE) build-melange
	$(MAKE) clean
	$(TIME) $(MAKE) build-dune

.PHONY: format
format: ## Format the codebase with ocamlformat
	$(DUNE) build @fmt --auto-promote

.PHONY: format-check
format-check: ## Checks if format is correct
	$(DUNE) build @fmt

.PHONY: watch
watch: ## Watch for the filesystem and rebuild on every change
	$(MEL) build --watch
