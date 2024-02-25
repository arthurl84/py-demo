MAKEFLAGS += --warn-undefined-variables
SHELL := /bin/zsh
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := all
.DELETE_ON_ERROR:
.SUFFIXES:

.DEFAULT_GOAL := help

PYEXECPATH ?= $(shell which python3.12 || which python3)
PYTHON ?= $(shell basename $(PYEXECPATH))
VENV := .venv
VENV_PYTHON := $(VENV)/bin/python
SOURCE_VENV := source $(VENV)/bin/avtivate;
PYEXEC := $(SOURCE_VENV) python

SVC_NAME := demo
SRC_DIR := corporate/org/$(SVC_NAME)
TEST_DIR := tests
SRC_EXECUTABLE := $(SVC_NAME).py

.PHONY: create-venv
create-venv:
	$(PYTHON) -m venv $(VENV)
	$(VENV_PYTHON) -m pip install --upgrade pip
	$(VENV_PYTHON) -m pip install -r requirements.txt
	$(VENV_PYTHON) -m pip install -r requirements-dev.txt

.PHONY: lint
lint:
	$(VENV_PYTHON) -m pylint $(SRC_EXECUTABLE) $(SRC_DIR) $(TEST_DIR) -d C -d R -d W

.PHONY: lint-format
lint-format:
	$(VENV_PYTHON) -m pylint $(SRC_EXECUTABLE) $(SRC_DIR) $(TEST_DIR) -d E -d F

.PHONY: test-unit
test-unit:
	#(VENV_PYTHON) -m pytest $(TEST_DIR)/unit

.PHONY: run-service
run-service:
	$(VENV_PYTHON) $(SRC_EXECUTABLE) -t $(SVC_NAME)dev -l $(SVC_NAME).log
