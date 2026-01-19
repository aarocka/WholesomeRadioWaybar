#!/bin/bash
# Installation script for Wholesome Radio Waybar plugin

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_DIR="$HOME/.config/waybar/scripts"
CONFIG_DIR="$HOME/.config/waybar"

echo "Installing Wholesome Radio Waybar plugin..."

# Create directories if they don't exist
mkdir -p "$INSTALL_DIR"
mkdir -p "$CONFIG_DIR"

# Copy the main script
echo "Copying script to $INSTALL_DIR..."
cp "$SCRIPT_DIR/wholesome_radio.sh" "$INSTALL_DIR/"
chmod +x "$INSTALL_DIR/wholesome_radio.sh"

# Copy example configs if they don't already exist
if [ ! -f "$CONFIG_DIR/config" ]; then
    echo "No existing Waybar config found. You can use waybar-config-example.json as a reference."
else
    echo "Waybar config already exists. Please manually add the custom module configuration."
    echo "See waybar-config-example.json for reference."
fi

if [ ! -f "$CONFIG_DIR/style.css" ]; then
    echo "No existing Waybar style found. You can use waybar-style-example.css as a reference."
else
    echo "Waybar style.css already exists. Please manually add the custom module styles."
    echo "See waybar-style-example.css for reference."
fi

echo ""
echo "Installation complete!"
echo ""
echo "Next steps:"
echo "1. Make sure VLC, curl, and jq are installed:"
echo "   sudo pacman -S vlc curl jq  (or equivalent for your distro)"
echo "2. Add the custom module to your Waybar config (see waybar-config-example.json)"
echo "3. Add the styles to your Waybar style.css (see waybar-style-example.css)"
echo "4. Restart Waybar to see the changes"
echo ""
echo "Script location: $INSTALL_DIR/wholesome_radio.sh"
echo ""
