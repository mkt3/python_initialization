V_ENV = $(lastword $(subst /, ,$(PWD)))

.PHONY: init jupyter init-jupyter

all: help

help: ## Usage
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

init: ## create project 
	sed -e 's/python-project-template/$(V_ENV)/g' ./pyproject.toml > ./pyproject.toml
	poetry install

init-jupyter: init ## create project with jupyterlab
	./.venv/bin/python -m ipykernel install --user --name=$(V_ENV) --display-name=$(V_ENV)
