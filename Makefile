V_ENV = $(lastword $(subst /, ,$(PWD)))
V_ENV_U = $(subst -,_,$(V_ENV))
GIT_USER_NAME := $(shell git config user.name)
KEDRO_CONFIG_FILE = ./kedro_config.yml

.PHONY: init jupyter init-jupyter poetry kedro git

all: help

help: ## Usage
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

init: poetry kedro git; ## create project

init-jupyter: init jupyter; ## create project with jupyterlab

poetry: ## create .venv by poetry 
	sed -i -e 's/python-project-template/$(V_ENV)/g' ./pyproject.toml
	poetry install

jupyter: ## set jupyterlab kernel
	poetry add -D ipykernel
	./.venv/bin/python -m ipykernel install --user --name=$(V_ENV) --display-name=$(V_ENV)

kedro: ## kedro new 
	sed -i -e 's/python-project-template/$(V_ENV)/g' $(KEDRO_CONFIG_FILE)
	sed -i -e 's/python_project_template/$(V_ENV_U)/g' $(KEDRO_CONFIG_FILE)
	kedro new --config $(KEDRO_CONFIG_FILE)

git: ## recreate git repo
	rm -rf .git
	echo $(V_ENV) > README.md
	git init
	git add -A
	git commit -m "First commit"
	git branch -m master main
	git remote add origin git@github.com:$(GIT_USER_NAME)/$(V_ENV).git
	git push origin main
