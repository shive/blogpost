# -*- mode: makefile-gmake; coding: euc-jp-unix -*-
#==============================================================================

CURRENT_MAKEFILE := $(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST))
CURRENT_MAKEFILE := $(shell cygpath -ma $(CURRENT_MAKEFILE))
CURRENT_MAKEFILE_DIR := $(dir $(CURRENT_MAKEFILE))
PATH := $(shell cygpath -ua $(CURRENT_MAKEFILE_DIR)):$(PATH)

LOGS := $(PWD)/

PYTHON3 = /c/Python33/python/
VENV_DIR = $(abspath .v3k)/
VENV_PYTHON3 = $(VENV_DIR)Scripts/python
VENV_EASYINSTALL = $(VENV_PYTHON3) -m easy_install
VENV_PIP = $(VENV_PYTHON3) -m pip


#------------------------------------------------------------------------------
.PHONY: setup
setup: .setup
.setup:
	$(PYTHON3) -m venv --clear $(VENV_DIR) >$(LOGS)venv.log 2>&1
	cd /tmp; \
	$(VENV_PYTHON3) $(CURRENT_MAKEFILE_DIR)distribute_setup.py >$(LOGS)distribute_setup.log 2>&1
	$(VENV_EASYINSTALL) pip >$(LOGS)easy_install-pip.log 2>&1
	$(VENV_PIP) install $(VENV_REQUIRE) >$(LOGS)pip-install.log 2>&1
	$(VENV_PIP) freeze
	/bin/touch $@

.PHONY: devel
devel: .devel
.devel: .setup
	$(VENV_PIP) install $(VENV_REQUIRE_DEVEL) >$(LOGS)pip-install-devel.log 2>&1
	$(VENV_PIP) freeze
	/bin/touch $@

#------------------------------------------------------------------------------
.PHONY: ipython
ipython: .devel
	$(VENV_PYTHON3) -um IPython

#------------------------------------------------------------------------------
.PHONY: clean
clean:
	$(RM) -r __pycache__/
	$(RM) *.log 

