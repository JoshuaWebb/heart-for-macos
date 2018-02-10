#!/usr/bin/env bash

# TODO: grab from the project file/during the build somehow?
APP_NAME="Heart"
FINAL_DMG_NAME="$APP_NAME.dmg"

BUILD_DIR="./build"
ARCHIVE_PATH="$BUILD_DIR/build.xcarchive"
INTERMEDIATE_DMG_PATH="$BUILD_DIR/dmg"

rm -rf "$BUILD_DIR"

mkdir -p $INTERMEDIATE_DMG_PATH || exit $?

xcodebuild -scheme "Deployment" -archivePath "$ARCHIVE_PATH" clean build archive
EXIT_CODE=$?
if [[ $EXIT_CODE -ne 0 ]]; then
	echo "Failed to build app: $EXIT_CODE"
	exit $EXIT_CODE
fi

# Copy built application into the dmg
xcodebuild -exportArchive -exportFormat app \
	-archivePath "$ARCHIVE_PATH" \
	-exportPath "$INTERMEDIATE_DMG_PATH/$APP_NAME"
EXIT_CODE=$?
if [[ $EXIT_CODE -ne 0 ]]; then
	echo "Failed to extract app from archive: $EXIT_CODE"
	exit $EXIT_CODE
fi

# Add a link for easy "install"
ln -s /Applications "$INTERMEDIATE_DMG_PATH/Applications"

hdiutil create -volname "${APP_NAME}" -srcfolder $INTERMEDIATE_DMG_PATH -ov -format UDZO "$BUILD_DIR/$FINAL_DMG_NAME"
