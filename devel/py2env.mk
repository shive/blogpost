# -*- mode: makefile-gmake; coding: euc-jp-unix -*-
#==============================================================================

CURRENT_MAKEFILE := $(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST))
CURRENT_MAKEFILE := $(shell cygpath -ma $(CURRENT_MAKEFILE))
CURRENT_MAKEFILE_DIR := $(dir $(CURRENT_MAKEFILE))
PATH := $(shell cygpath -ua $(CURRENT_MAKEFILE_DIR)):$(PATH)

LOGS := $(PWD)/

PYTHON_ORIG = /c/Python27/python
VIRTUALENV_DIR = .vep/
PYTHON = $(abspath $(VIRTUALENV_DIR)Scripts/python)
EASYINSTALL = $(PYTHON) -m easy_install
PIP = $(PYTHON) -m pip

REQUIREMENT = \
	pyreadline==2.0			\
	ipython==1.1.0			\
	nose==1.3.0				\
	logilab-common==0.60.0	\
	logilab-astng==0.24.3	\
	pylint==1.0.0


#------------------------------------------------------------------------------
.PHONY: devel
devel: $(VIRTUALENV_DIR).devel
$(VIRTUALENV_DIR).devel:
	$(PYTHON_ORIG) -m virtualenv --clear --no-site-packages $(VIRTUALENV_DIR) >$(LOGS)venv.log 2>&1
	cd /tmp; $(PYTHON) $(CURRENT_MAKEFILE_DIR)distribute_setup.py >$(LOGS)distribute_setup.log 2>&1
	$(EASYINSTALL) pip >$(LOGS)easy_install-pip.log 2>&1
	$(PIP) install $(REQUIREMENT) >$(LOGS)pip-install-devel.log 2>&1
	$(PYTHON) -V
	$(PIP) freeze
	/bin/touch $@

#------------------------------------------------------------------------------
.PHONY: ipython
ipython: devel
	$(PYTHON) -um IPython

#------------------------------------------------------------------------------
.PHONY: clean
clean:
	$(RM) -r __pycache__/
	$(RM) *.log 

