V_ENV = $(lastword $(subst /, ,$(PWD)))

all: init

init:
	pipenv install --dev
	ipython kernel install --user --name=$(V_ENV) --display-name=$(V_ENV)
