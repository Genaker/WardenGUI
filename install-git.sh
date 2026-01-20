#!/bin/bash
# WardenGUI Git Installer - Install directly from GitHub
# Usage: curl -sSL https://raw.githubusercontent.com/Genaker/WardenGUI/main/install-git.sh | bash

set -e

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║           🐳 WARDENGUI GIT INSTALLER                         ║"
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

# Install directory
INSTALL_DIR="$HOME/.wardengui"

# Clone or update repository
echo ""
if [ -d "$INSTALL_DIR" ]; then
    echo "📥 Updating existing installation..."
    cd "$INSTALL_DIR"
    git pull
else
    echo "📥 Cloning WardenGUI from GitHub..."
    git clone https://github.com/Genaker/WardenGUI.git "$INSTALL_DIR"
    cd "$INSTALL_DIR"
fi

# Create wrapper script
LOCAL_BIN="$HOME/.local/bin"
mkdir -p "$LOCAL_BIN"

echo "📝 Creating launcher script..."
cat > "$LOCAL_BIN/wardengui" << 'EOF'
#!/bin/bash
INSTALL_DIR="$HOME/.wardengui"
cd "$INSTALL_DIR"
python3 -m wardengui "$@"
EOF

chmod +x "$LOCAL_BIN/wardengui"

# Create alias for warden-gui
ln -sf "$LOCAL_BIN/wardengui" "$LOCAL_BIN/warden-gui" 2>/dev/null || true

# Add to PATH if needed
if [[ ":$PATH:" != *":$LOCAL_BIN:"* ]]; then
    echo ""
    echo "📝 Adding $LOCAL_BIN to PATH..."
    
    if [[ -f "$HOME/.zshrc" ]]; then
        SHELL_RC="$HOME/.zshrc"
    elif [[ -f "$HOME/.bashrc" ]]; then
        SHELL_RC="$HOME/.bashrc"
    else
        SHELL_RC="$HOME/.profile"
    fi
    
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
echo "Installed to: $INSTALL_DIR"
echo ""
echo "Run wardengui with:"
echo ""
echo "  wardengui"
echo ""
echo "To update later:"
echo ""
echo "  cd ~/.wardengui && git pull"
echo ""
echo "You may need to restart your terminal or run:"
echo "  source ~/.bashrc"
echo ""
