.DEFAULT_GOAL := build
.PHONY: dependencies install test build clean
VENV_BIN = ./venv/bin
PIP = $(VENV_BIN)/pip
PYTHON = $(VENV_BIN)/python
PYTEST = $(VENV_BIN)/pytest
PYLINT = $(VENV_BIN)/pylint
COVERAGE = $(VENV_BIN)/coverage

venv:
	@python -m venv venv

dependencies: venv
	@$(PIP) install -r requirements.txt
	@$(PIP) install -r requirements-test.txt

install: dependencies
	@$(PIP) install -U pip
	@$(PIP) install -e .[test]

build: test
	@$(PYTHON) -m build

lint:
	@$(PYLINT) middel/

test: install lint
	@$(COVERAGE) run -m pytest test/
	@$(COVERAGE) report
	@$(COVERAGE) html

clean:
	@rm -rf dist middel.egg-info

purge: clean
	@rm -rf ./venv

scratch: purge build