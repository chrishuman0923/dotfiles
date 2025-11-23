#!/bin/bash
# System configuration script
# Called by bootstrap.sh

echo "Configuring System preferences..."

# Dark mode
defaults write -g AppleInterfaceStyle -string "Dark"

# Expand save panel by default
defaults write -g NSNavPanelExpandedStateForSaveMode -bool true
defaults write -g NSNavPanelExpandedStateForSaveMode2 -bool true

# Expand print panel by default
defaults write -g PMPrintingExpandedStateForPrint -bool true
defaults write -g PMPrintingExpandedStateForPrint2 -bool true

# Save to disk (not iCloud) by default
defaults write -g NSDocumentSaveNewDocumentsToCloud -bool false

# Disable "Are you sure you want to open this application?"
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Require password immediately after sleep or screen saver
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Disable automatic capitalization (also in keyboard.sh but system-wide here)
defaults write -g NSAutomaticCapitalizationEnabled -bool false

# Disable smart dashes
defaults write -g NSAutomaticDashSubstitutionEnabled -bool false

# Disable automatic period substitution
defaults write -g NSAutomaticPeriodSubstitutionEnabled -bool false

# Disable smart quotes
defaults write -g NSAutomaticQuoteSubstitutionEnabled -bool false

# Disable auto-correct
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false

echo "System configured."
echo "Note: Some changes may require logout to take effect."
