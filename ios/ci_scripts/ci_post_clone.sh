#!/bin/sh

# @see: https://docs.flutter.dev/deployment/cd#post-clone-script
# @see: https://developer.apple.com/documentation/xcode/writing-custom-build-scripts

# Fail this script if any subcommand fails.
set -e

# The default execution directory of this script is the ci_scripts directory.
cd $CI_PRIMARY_REPOSITORY_PATH # change working directory to the root of your cloned repo.

# Install Flutter using git.
# TODO: version check
git clone https://github.com/flutter/flutter.git --depth 1 -b stable $HOME/flutter
export PATH="$PATH:$HOME/flutter/bin"

# Install Flutter artifacts for iOS (--ios), or macOS (--macos) platforms.
flutter precache --ios

# Install Flutter dependencies.
flutter pub get

# Install CocoaPods using Homebrew.
HOMEBREW_NO_AUTO_UPDATE=1 # disable homebrew's automatic updates.
brew install cocoapods

# Install CocoaPods dependencies.
cd ios && pod install # run `pod install` in the `ios` directory.

# Set the build number to the number of commits on the current branch.
# 一旦 pubspec でバージョンを管理するため、このスクリプトは不要
# BUILD_NUMBER=$(git rev-list --count HEAD)
# /usr/libexec/PlistBuddy -c "Set :CFBundleVersion $BUILD_NUMBER" "ios/Runner/Info.plist"

exit 0
