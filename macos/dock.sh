#!/bin/bash
# Dock configuration script
# Called by bootstrap.sh

echo "Configuring Dock..."

# Clear all apps from Dock (Finder and Trash remain - they're built-in)
defaults write com.apple.dock persistent-apps -array

# Clear the "others" section (Downloads folder, etc.)
defaults write com.apple.dock persistent-others -array

# Add System Settings back to Dock
defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/System/Applications/System Settings.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'

# Set Dock to auto-hide
defaults write com.apple.dock autohide -bool true

# Remove auto-hide delay
defaults write com.apple.dock autohide-delay -float 0

# Faster auto-hide animation
defaults write com.apple.dock autohide-time-modifier -float 0.3

# Set Dock icon size to minimum (16 is smallest)
defaults write com.apple.dock tilesize -int 16

# Position Dock on bottom
defaults write com.apple.dock orientation -string "bottom"

# Enable magnification on hover
defaults write com.apple.dock magnification -bool true

# Set magnification size
defaults write com.apple.dock largesize -int 80

# Set minimize effect to genie
defaults write com.apple.dock mineffect -string "genie"

# Don't show recent apps in Dock
defaults write com.apple.dock show-recents -bool false

# Restart Dock to apply changes
killall Dock

echo "Dock configured."
