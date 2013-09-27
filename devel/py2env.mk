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
PACKAGES = devel.pybundle

REQUIREMENT =				\
	pyreadline==2.0			\
	ipython==1.1.0			\
	nose==1.3.0				\
	logilab-common==0.60.0	\
	logilab-astng==0.24.3	\
	pylint==1.0.0


#------------------------------------------------------------------------------
.PHONY: devel bundle
devel: $(VIRTUALENV_DIR).devel
bundle: $(PACKAGES)
$(VIRTUALENV_DIR).devel: $(PACKAGES)
	$(PIP) install $(PACKAGES) >$(LOGS)pip-install-devel.log 2>&1
	$(PIP) freeze
	/bin/touch $@
$(PACKAGES): $(PYTHON)
	$(PIP) bundle $@ $(REQUIREMENT) >$(LOGS)pip-bundle-devel.log 2>&1
$(PYTHON):
	$(RM) -r $(VIRTUALENV_DIR)
	$(PYTHON_ORIG) -m virtualenv --clear --no-site-packages $(VIRTUALENV_DIR) >$(LOGS)venv.log 2>&1
	cd /tmp; $(PYTHON) $(CURRENT_MAKEFILE_DIR)distribute_setup.py >$(LOGS)distribute_setup.log 2>&1
	$(EASYINSTALL) pip >$(LOGS)easy_install-pip.log 2>&1
	$(PYTHON) -V


#------------------------------------------------------------------------------
.PHONY: shell
shell: devel
	$(PYTHON) -um IPython

#------------------------------------------------------------------------------
.PHONY: clean clean-devel
clean:
	$(RM) -r __pycache__/
	$(RM) *.log *.pyc
clean-devel: clean
	$(RM) -r $(VIRTUALENV_DIR)
	$(RM) $(PACKAGES)

