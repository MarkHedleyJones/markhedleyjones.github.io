BASE_IMAGE ?= debian:buster-slim
IMAGE_NAME := $(shell basename $(CURDIR))
IMAGE_TAG  := latest
USER_GID   := 1000
USER_UID   := 1000
WORKDIR    := /workspace

.PHONY: development
development: pre-build build-development-image post-build

.PHONY: production
production: pre-build build-production-image post-build

# A development build does not include the workspace
.PHONY: build-development-image
build-development-image:
	docker build \
		--target development-image \
		--build-arg BASE_IMAGE=$(BASE_IMAGE) \
		--build-arg USER_GID=$(USER_GID) \
		--build-arg USER_UID=$(USER_UID) \
		--build-arg WORKDIR=$(WORKDIR) \
		--tag $(IMAGE_NAME):$(IMAGE_TAG) \
		.
	@echo "This file enables development features for this repository" > .docker-bbq
	@echo "Development image built - the following features will been enabled:"
	@echo " - Automatic workspace mounting"
	@echo " - Privileged container mode"
	@echo "WARNING: Running privileged containers can be dangerous!"
	@echo "         Only run development images if you trust them"

# A production build includes the workspace in the final image
.PHONY: build-production-image
build-production-image:
	docker build \
		--target production-image \
		--build-arg BASE_IMAGE=$(BASE_IMAGE) \
		--build-arg USER_GID=$(USER_GID) \
		--build-arg USER_UID=$(USER_UID) \
		--build-arg WORKDIR=$(WORKDIR) \
		--tag $(IMAGE_NAME):$(IMAGE_TAG) \
		.
	@rm -f .docker-bbq
	@echo "Production image built - automatic workspace mounting disabled for $(IMAGE_NAME)"

# Preparatory stage before building the target image
.PHONY: pre-build
pre-build:
	# Cleaning the packagelist ...
	@mkdir -p build/tmp
	@cat build/packagelist | sort --unique | sed '/^\s*$$/d' > build/tmp/packagelist
	@cp build/tmp/packagelist build/packagelist
	# Detecting Python requirements ...
	@mkdir -p build/tmp/pip
	@reqs="$(shell ls build | grep "pip[2-3]\?-requirements.txt" | cut -d '-' -f 1 | sed 's/pip/python/')" \
		&& if [ ! -z "$$reqs" ] ; then cd build && cp pip*-requirements.txt tmp/pip && for py in $$reqs ; do \
		printf "$${py}-pip\n$${py}-wheel\n$${py}-setuptools\n" >> tmp/packagelist ; done ; fi
	# Fetching any remote resources ...
	@mkdir -p build/resources
	@if [ -f build/urilist ] ; then cat build/urilist | while read uri ; do echo "Downloading $$uri ..." \
		&& wget --quiet --no-clobber --directory-prefix build/resources/ $$uri ; done ; fi

# Post-build clean-up stage
.PHONY: post-build
post-build:
	@rm -rf build/tmp
