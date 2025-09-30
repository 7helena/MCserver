#!/bin/bash
set -e

# Get required dependencies
echo "Installing dependencies..."
sudo apt-get update
sudo apt-get install -y zip unzip curl git

# Install SDKMAN
if [ ! -d "$HOME/.sdkman" ]; then
    echo "Installing SDKMAN..."
    curl -s "https://get.sdkman.io" | bash
fi

# Source SDKMAN immediately for this script
source "$HOME/.sdkman/bin/sdkman-init.sh"

# Add SDKMAN init to bashrc if not already there
if ! grep -q 'sdkman-init.sh' "$HOME/.bashrc"; then
    echo 'source "$HOME/.sdkman/bin/sdkman-init.sh"' >> "$HOME/.bashrc"
fi

# Install Java 21
echo "Installing Java 21 (Temurin)..."
sdk install java 21.0.2-tem

echo "✅ Setup complete! Restart your shell or run: source ~/.bashrc"