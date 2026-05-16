#!/usr/bin/env bash
#
# Build an unsigned Nemonic.app and package it into a DMG for local/dev distribution.
#
# Usage:
#   scripts/build-dev-dmg.sh [version]
#
# The resulting DMG lands in build/dist/Nemonic-<version>-dev.dmg.
# Nothing here is signed or notarized — Gatekeeper will require a right-click → Open
# on first launch (or `xattr -dr com.apple.quarantine /Applications/Nemonic.app`).

set -euo pipefail

cd "$(dirname "$0")/.."

SCHEME="Nemonic"
CONFIG="Release"
APP_NAME="Nemonic"
VERSION="${1:-$(date +%Y.%m.%d)}"

BUILD_DIR="build"
DERIVED="$BUILD_DIR/DerivedData"
EXPORT_DIR="$BUILD_DIR/export"
STAGE_DIR="$BUILD_DIR/dmg-stage"
DIST_DIR="$BUILD_DIR/dist"
DMG_PATH="$DIST_DIR/${APP_NAME}-${VERSION}-dev.dmg"

rm -rf "$EXPORT_DIR" "$STAGE_DIR"
mkdir -p "$DERIVED" "$EXPORT_DIR" "$STAGE_DIR" "$DIST_DIR"

echo "==> Building $APP_NAME ($CONFIG, unsigned) — version $VERSION"
xcodebuild \
  -project "${APP_NAME}.xcodeproj" \
  -scheme "$SCHEME" \
  -configuration "$CONFIG" \
  -derivedDataPath "$DERIVED" \
  -destination "generic/platform=macOS" \
  CODE_SIGN_IDENTITY="-" \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGNING_ALLOWED=NO \
  MARKETING_VERSION="$VERSION" \
  build \
  | xcbeautify 2>/dev/null || true

APP_BUILT="$DERIVED/Build/Products/${CONFIG}/${APP_NAME}.app"
if [[ ! -d "$APP_BUILT" ]]; then
  echo "error: build did not produce $APP_BUILT" >&2
  exit 1
fi

echo "==> Ad-hoc signing for local launch"
codesign --force --deep --sign - "$APP_BUILT"

echo "==> Staging DMG contents"
cp -R "$APP_BUILT" "$STAGE_DIR/"
ln -s /Applications "$STAGE_DIR/Applications"

echo "==> Creating $DMG_PATH"
rm -f "$DMG_PATH"
hdiutil create \
  -volname "${APP_NAME} ${VERSION}" \
  -srcfolder "$STAGE_DIR" \
  -ov \
  -format UDZO \
  "$DMG_PATH" >/dev/null

echo "==> Done: $DMG_PATH"
du -h "$DMG_PATH"
