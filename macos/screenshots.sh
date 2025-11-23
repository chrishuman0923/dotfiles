#!/bin/bash
# Screenshots configuration script
# Called by bootstrap.sh

echo "Configuring Screenshots..."

# Create Screenshots directory if it doesn't exist
mkdir -p ~/Screenshots

# Set screenshot location
defaults write com.apple.screencapture location -string "${HOME}/Screenshots"

# Set screenshot format to PNG
defaults write com.apple.screencapture type -string "png"

# Disable shadow in screenshots
defaults write com.apple.screencapture disable-shadow -bool true

# Restart SystemUIServer to apply changes
killall SystemUIServer

echo "Screenshots configured."
