-include .github/local/Makefile.local
PROJECT ?= cix-drivers-dkms

.DEFAULT_GOAL := all
.PHONY: all
all: build

.PHONY: devcontainer_setup
devcontainer_setup:
	sudo dpkg --add-architecture arm64
	sudo apt-get update
	sudo apt-get build-dep . -y

#
# Test
#
.PHONY: test
test:

#
# Build
#
.PHONY: build
build: pre_build post_build

.PHONY: pre_build
pre_build:
	# Fix file permissions when created from template
	chmod +x debian/rules

.PHONY: post_build
post_build:

#
# Clean
#
.PHONY: distclean
distclean: clean

.PHONY: clean
clean: clean-deb

.PHONY: clean-deb
clean-deb:
	rm -rf debian/.debhelper debian/${PROJECT}*/ debian/tmp/ debian/debhelper-build-stamp debian/files debian/*.debhelper.log debian/*.*.debhelper debian/*.substvars

#
# Release
#
.PHONY: dch
dch: debian/changelog
	EDITOR=true gbp dch --ignore-branch --multimaint-merge --commit --git-log='--no-merges --perl-regexp --author ^((?!github-actions\[bot\]).*)$$' --release --dch-opt=--upstream

.PHONY: deb
deb: debian
	$(CUSTOM_DEBUILD_ENV) debuild --no-lintian --lintian-hook "lintian --fail-on error,warning --suppress-tags-from-file $(PWD)/debian/common-lintian-overrides -- %p_%v_*.changes" --no-sign -b

.PHONY: release
release:
	gh workflow run .github/workflows/new_version.yaml --ref $(shell git branch --show-current)
