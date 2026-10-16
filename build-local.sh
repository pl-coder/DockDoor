#!/bin/zsh
# pl-coder: build DockDoor from audited source, signed with our own team, and
# install to /Applications. The bundle id differs from upstream's so macOS keeps
# our Accessibility / Screen Recording grants separate from any upstream copy.
set -euo pipefail
cd "${0:A:h}"

xcodebuild -project DockDoor.xcodeproj -scheme DockDoor -configuration Release \
  -derivedDataPath build \
  DEVELOPMENT_TEAM=6W9Z36WZNX CODE_SIGN_STYLE=Automatic \
  PRODUCT_BUNDLE_IDENTIFIER=com.plcoder.DockDoor \
  -allowProvisioningUpdates build > build.log 2>&1 \
  || { grep -E 'error:' build.log | head -20; exit 1; }

APP=build/Build/Products/Release/DockDoor.app
codesign --verify --deep --strict "$APP"
pkill -x DockDoor 2>/dev/null || true
rm -rf /Applications/DockDoor.app
ditto "$APP" /Applications/DockDoor.app
open /Applications/DockDoor.app
echo "installed $(defaults read /Applications/DockDoor.app/Contents/Info CFBundleShortVersionString)"
