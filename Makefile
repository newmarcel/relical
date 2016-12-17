IOS_VERSION = 10.2
IOS_DEVICES = iPhone 7 ($(IOS_VERSION))

NAME = Relical
SCHEME = $(NAME)
WORKSPACE = $(NAME).xcworkspace

BUILD_DIR = $(shell pwd)/build
LOG_DIR = $(BUILD_DIR)/Logs

init:
	$(info Installing command line build dependencies...)
	gem install --no-document --quiet fastlane

clean:
	rm -rf $(BUILD_DIR)

test: test-ios test-macos

test-macos:
	fastlane scan \
	--clean \
	--workspace "$(WORKSPACE)" \
	--scheme "$(SCHEME)-macOS" \
	--derived_data_path "$(BUILD_DIR)" \
	--buildlog_path "$(LOG_DIR)" \
	--output_directory "$(LOG_DIR)" \
	ONLY_ACTIVE_ARCH=NO \
	OBJROOT="$(BUILD_DIR)" \
	SYMROOT="$(BUILD_DIR)"

test-ios:
	fastlane scan \
	--clean \
	--workspace "$(WORKSPACE)" \
	--scheme "$(SCHEME)-iOS" \
	--devices "$(IOS_DEVICES)" \
	--derived_data_path "$(BUILD_DIR)" \
	--buildlog_path "$(LOG_DIR)" \
	--output_directory "$(LOG_DIR)" \
	ONLY_ACTIVE_ARCH=NO \
	OBJROOT="$(BUILD_DIR)" \
	SYMROOT="$(BUILD_DIR)"

framework:
	carthage build --no-skip-current
	carthage archive $(NAME)

.PHONY: init clean test test-ios test-mac framework
