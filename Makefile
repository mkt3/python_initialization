V_ENV = $(lastword $(subst /, ,$(PWD)))

all: init

init:
	poetry install
	./.venv/bin/python -m ipykernel install --user --name=$(V_ENV) --display-name=$(V_ENV)
