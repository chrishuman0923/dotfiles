#!/bin/bash
# Spotlight configuration script
# Rebinds Spotlight to option+space to free up cmd+space for Alfred

echo "Configuring Spotlight..."

# Rebind Spotlight shortcut from cmd+space to option+space
# Key 64 = Show Spotlight search
# Modifier 524288 = Option key
/usr/libexec/PlistBuddy ~/Library/Preferences/com.apple.symbolichotkeys.plist \
  -c "Delete :AppleSymbolicHotKeys:64" 2>/dev/null

/usr/libexec/PlistBuddy ~/Library/Preferences/com.apple.symbolichotkeys.plist \
  -c "Add :AppleSymbolicHotKeys:64:enabled bool true" \
  -c "Add :AppleSymbolicHotKeys:64:value:parameters array" \
  -c "Add :AppleSymbolicHotKeys:64:value:parameters: integer 32" \
  -c "Add :AppleSymbolicHotKeys:64:value:parameters: integer 49" \
  -c "Add :AppleSymbolicHotKeys:64:value:parameters: integer 524288" \
  -c "Add :AppleSymbolicHotKeys:64:value:type string standard"

echo "Spotlight rebound to option+space (cmd+space now free for Alfred)."
echo "Note: May require logout to take effect."
