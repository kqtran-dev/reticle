#!/bin/bash

mkdir -p reticle.app/Contents/MacOS
mkdir -p reticle.app/Contents/Resources
mkdir -p ~/Library/Application\ Support/reticle
cp config.json ~/Library/Application\ Support/reticle/
cp Info.plist reticle.app/Contents/
swiftc -o reticle.app/Contents/MacOS/reticle Sources/*.swift



