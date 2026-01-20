#!/bin/bash
# Build and push WardenGUI to PyPI

set -e

echo "🧹 Cleaning previous builds..."
rm -rf build/ dist/ *.egg-info/ src/*.egg-info/

echo "📦 Building package..."
python -m build

echo "🔍 Checking package..."
twine check dist/*

echo ""
read -p "🚀 Upload to PyPI? (y/N): " confirm
if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
    echo "📤 Uploading to PyPI..."
    twine upload dist/*
    echo "✅ Done! Package published to PyPI."
else
    echo "⏭️  Skipped upload. Files are in dist/"
fi
