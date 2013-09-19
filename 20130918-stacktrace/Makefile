# -*- mode: makefile-gmake; coding: euc-jp-unix -*-
#==============================================================================

TARGET_ARCH ?= x86_64
SCONS = scons -Qj4 TARGET_ARCH=$(TARGET_ARCH)

.PHONY: build run clean
build:
	$(SCONS) $@
run: build
	$(SCONS) $@
clean:
	$(SCONS) -c

.PHONY: build-x86 build-x64 build-all
build-all: build-x86 build-x64
build-x86:
	$(MAKE) build TARGET_ARCH=x86
build-x64:
	$(MAKE) build TARGET_ARCH=x86_64

.PHONY: run-x86 run-x64 run-all
run-all: run-x86 run-x64
run-x86:
	$(MAKE) run TARGET_ARCH=x86
run-x64:
	$(MAKE) run TARGET_ARCH=x86_64

.PHONY: clean-x86 clean-x64 clean-all
clean-all: clean-x86 clean-x64
clean-x86:
	$(MAKE) clean TARGET_ARCH=x86
clean-x64:
	$(MAKE) clean TARGET_ARCH=x86_64

