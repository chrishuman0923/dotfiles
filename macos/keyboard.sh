#!/bin/bash
# Keyboard configuration script
# Called by bootstrap.sh

echo "Configuring Keyboard..."

# Fast key repeat rate (lower = faster, default is 2)
defaults write NSGlobalDomain KeyRepeat -int 2

# Short delay before key repeat starts (lower = shorter, default is 15)
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Disable press-and-hold for accents in favor of key repeat
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Enable full keyboard access for all controls (tab through all UI elements)
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Disable auto-capitalization
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# Disable smart dashes
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Disable smart quotes
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# Disable automatic period substitution (double space = period)
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

echo "Keyboard configured. Some changes may require logout to take effect."
