#!/bin/bash
# Build and push WardenGUI to PyPI

set -e

# Change to script directory
cd "$(dirname "$0")"
echo "📂 Working in: $(pwd)"

# Get current version from pyproject.toml
CURRENT_VERSION=$(grep -oP 'version = "\K[^"]+' pyproject.toml)
echo "📌 Current version: $CURRENT_VERSION"

# Ask to bump version
read -p "🔢 Bump version? (y/N): " bump
if [[ "$bump" == "y" || "$bump" == "Y" ]]; then
    # Split version into parts
    IFS='.' read -r major minor patch <<< "$CURRENT_VERSION"
    
    # Increment patch version
    NEW_PATCH=$((patch + 1))
    NEW_VERSION="${major}.${minor}.${NEW_PATCH}"
    
    # Update pyproject.toml
    sed -i "s/version = \"$CURRENT_VERSION\"/version = \"$NEW_VERSION\"/" pyproject.toml
    echo "✅ Version bumped: $CURRENT_VERSION → $NEW_VERSION"
    
    # Update __init__.py
    sed -i "s/__version__ = \"$CURRENT_VERSION\"/__version__ = \"$NEW_VERSION\"/" src/wardengui/__init__.py 2>/dev/null || true
else
    NEW_VERSION=$CURRENT_VERSION
    echo "⏭️  Keeping version: $NEW_VERSION"
fi

echo ""
echo "📥 Installing build dependencies..."
python3 -m pip install --quiet --upgrade pip build twine --break-system-packages 2>/dev/null || \
    pip3 install --quiet --upgrade build twine 2>/dev/null || \
    echo "⚠️  Could not install deps, trying anyway..."

echo "🧹 Cleaning previous builds..."
rm -rf build/ dist/ *.egg-info/ src/*.egg-info/

echo "📦 Building package v$NEW_VERSION..."
python3 -m build

echo "🔍 Checking package..."
python3 -m twine check dist/* || echo "⚠️  Check warning (can be ignored)"

echo ""
read -p "🚀 Upload v$NEW_VERSION to PyPI? (y/N): " confirm
if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
    echo "📤 Uploading to PyPI..."
    python3 -m twine upload dist/*
    echo "✅ Done! Package v$NEW_VERSION published to PyPI."
    
    # Commit version bump
    read -p "📝 Commit version bump to git? (y/N): " gitcommit
    if [[ "$gitcommit" == "y" || "$gitcommit" == "Y" ]]; then
        git add pyproject.toml src/wardengui/__init__.py
        git commit -m "Bump version to $NEW_VERSION"
        git push
        echo "✅ Version bump committed and pushed."
    fi
else
    echo "⏭️  Skipped upload. Files are in dist/"
fi
