ENVIRONMENT?=dev
GIT_REPO?=$(shell git remote get-url origin)
GIT_REPO_NAME?=$(shell git remote get-url origin|awk -F '[/.]' '{print $$(NF-1)}')

REPO_ROOT?=$(shell git rev-parse --show-toplevel)
CHART_NAME?=$(notdir $(shell pwd))

ifeq ($(strip $(PARALLEL_LEVEL)),)
	PARALLEL_LEVEL := $(shell nproc --all)
	MAKEFLAGS += -j${PARALLEL_LEVEL}
endif

# Set L to + for debug
export L=@

# Default bash flags
ifeq ($(L),+)
	export BASH_FLAGS=-x
endif
export SHELL := /bin/bash $(BASH_FLAGS)

# Handle sed flags issue for macos
export OSV=$(shell uname|awk '{ print $$1 }')

ifeq ($(strip $(OSV)),Darwin)
	export SED_I_FLAG=-i ''
else
	export SED_I_FLAG=-i
endif

# Disable bad '-' value for L
# We dont want to ignore errors for all commands in targets
# To ignore errors, modify the Makefiles
ifeq ($(L),-)
	export L=+
endif

.PHONY: default
default:
	$(L)echo "ERR: Make target name is expected as argument"
	${L}echo "------"
	$(L)echo "Targets:"
	${L}grep '^[^#[:space:]].*:' ${REPO_ROOT}/Makefile ${REPO_ROOT}/*.mk 2>/dev/null \
		| grep -v -e "\.PHONY\|export .*=.*\|default:" \
		| sed 's/\(.*\):\(.*\):\(.*\)/  \2/g'
	${L}echo "------"

# Include shared resources
include ${REPO_ROOT}/Makefile.*.mk
