#
# shiftfs-test Makefile
#

.PHONY: clean shiftfs-test

GO := go

SHIFTFS_TEST_BUILDROOT := build
SHIFTFS_TEST_BUILDDIR := $(SHIFTFS_TEST_BUILDROOT)/$(TARGET_ARCH)
SHIFTFS_TEST_TARGET := shiftfs-test
SHIFTFS_TEST_SRC := $(shell find . 2>&1 | grep -E '.*\.(c|h|go)$$')

# Set cross-compilation flags if applicable.
ifneq ($(SYS_ARCH),$(TARGET_ARCH))
	ifeq ($(TARGET_ARCH),armel)
		GO_XCOMPILE := GOOS=linux GOARCH=arm GOARM=6 CC=arm-linux-gnueabi-gcc
	else ifeq ($(TARGET_ARCH),armhf)
		GO_XCOMPILE := GOOS=linux GOARCH=arm GOARM=7 CC=arm-linux-gnueabihf-gcc
	else ifeq ($(TARGET_ARCH),arm64)
		GO_XCOMPILE = GOOS=linux GOARCH=arm64 CC=aarch64-linux-gnu-gcc
	else ifeq ($(TARGET_ARCH),amd64)
		GO_XCOMPILE = GOOS=linux GOARCH=amd64 CC=x86_64-linux-gnu-gcc
	endif
endif

.DEFAULT: shiftfs-test

shiftfs-test: $(SHIFTFS_TEST_BUILDDIR)/$(SHIFTFS_TEST_TARGET)

$(SHIFTFS_TEST_BUILDDIR)/$(SHIFTFS_TEST_TARGET): $(SHIFTFS_TEST_SRC)
	$(GO_XCOMPILE) $(GO) build -ldflags "-w -extldflags -static" -o $(SHIFTFS_TEST_BUILDDIR)/shiftfs-test

gomod-tidy:
	$(GO) mod tidy

lint:
	$(GO) vet $(allpackages)
	$(GO) fmt $(allpackages)

listpackages:
	@echo $(allpackages)

clean:
	rm -f $(SHIFTFS_TEST_BUILDDIR)/shiftfs-test

# memoize allpackages, so that it's executed only once and only if used
_allpackages = $(shell $(GO) list ./... | grep -v vendor)
allpackages = $(if $(__allpackages),,$(eval __allpackages := $$(_allpackages)))$(__allpackages)
