#!/bin/bash
# WardenGUI Installer
# Usage: curl -sSL https://raw.githubusercontent.com/Genaker/WardenGUI/main/install.sh | bash

set -e

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║               🐳 WARDENGUI INSTALLER                         ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""

# Detect Python
if command -v python3 &> /dev/null; then
    PYTHON=python3
elif command -v python &> /dev/null; then
    PYTHON=python
else
    echo "❌ Python not found. Please install Python 3.8+ first."
    exit 1
fi

echo "✓ Found Python: $($PYTHON --version)"

# Check Python version
PY_VERSION=$($PYTHON -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")')
echo "✓ Python version: $PY_VERSION"

# Install wardengui
echo ""
echo "📦 Installing wardengui..."

# Try different installation methods
if $PYTHON -m pip install --user wardengui 2>/dev/null; then
    echo "✓ Installed with --user flag"
elif $PYTHON -m pip install --break-system-packages wardengui 2>/dev/null; then
    echo "✓ Installed with --break-system-packages"
elif pip3 install --user wardengui 2>/dev/null; then
    echo "✓ Installed with pip3 --user"
elif pip3 install --break-system-packages wardengui 2>/dev/null; then
    echo "✓ Installed with pip3 --break-system-packages"
else
    echo "⚠️  Standard install failed, trying with sudo..."
    sudo $PYTHON -m pip install wardengui || sudo pip3 install wardengui
fi

# Add ~/.local/bin to PATH if needed
LOCAL_BIN="$HOME/.local/bin"
if [[ -d "$LOCAL_BIN" ]] && [[ ":$PATH:" != *":$LOCAL_BIN:"* ]]; then
    echo ""
    echo "📝 Adding $LOCAL_BIN to PATH..."
    
    # Detect shell config file
    if [[ -f "$HOME/.zshrc" ]]; then
        SHELL_RC="$HOME/.zshrc"
    elif [[ -f "$HOME/.bashrc" ]]; then
        SHELL_RC="$HOME/.bashrc"
    else
        SHELL_RC="$HOME/.profile"
    fi
    
    # Add to PATH if not already there
    if ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' "$SHELL_RC" 2>/dev/null; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$SHELL_RC"
        echo "✓ Added to $SHELL_RC"
    fi
    
    export PATH="$LOCAL_BIN:$PATH"
fi

echo ""
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║               ✅ INSTALLATION COMPLETE!                      ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""
echo "Run wardengui with:"
echo ""
echo "  wardengui"
echo ""
echo "Or if command not found:"
echo ""
echo "  ~/.local/bin/wardengui"
echo "  python3 -m wardengui"
echo ""
echo "You may need to restart your terminal or run:"
echo "  source ~/.bashrc"
echo ""
