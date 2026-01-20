#!/bin/bash
# Build and push WardenGUI to PyPI

set -e

# Change to script directory
cd "$(dirname "$0")"
echo "📂 Working in: $(pwd)"

echo "📥 Installing build dependencies..."
python3 -m pip install --quiet --upgrade pip build twine 2>/dev/null || \
    pip3 install --quiet --upgrade build twine 2>/dev/null || \
    echo "⚠️  Could not install deps, trying anyway..."

echo "🧹 Cleaning previous builds..."
rm -rf build/ dist/ *.egg-info/ src/*.egg-info/

echo "📦 Building package..."
python3 -m build

echo "🔍 Checking package..."
python3 -m twine check dist/* || echo "⚠️  Check warning (can be ignored)"

echo ""
read -p "🚀 Upload to PyPI? (y/N): " confirm
if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
    echo "📤 Uploading to PyPI..."
    python3 -m twine upload dist/*
    echo "✅ Done! Package published to PyPI."
else
    echo "⏭️  Skipped upload. Files are in dist/"
fi
