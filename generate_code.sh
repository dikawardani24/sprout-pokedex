#!/bin/bash

set -e

ROOT_DIR="/home/dika/Documents/Projects/Private/sprout-pokedex"
cd "$ROOT_DIR"

PACKAGES=(
    "app_core/ai_gemini"
    "app_core/api"
    "app_core/app_preference"
    "app_core/core"
    "app_core/database"
    "features/feature_chat"
    "features/feature_chat_history"
    "features/feature_detail"
    "features/feature_home"
    "features/feature_set_ai_api_key"
    "."
)

echo "Starting build_runner across all packages..."

for PKG in "${PACKAGES[@]}"; do
    echo ""
    echo "=== Running in $PKG ==="
    
    if [ "$PKG" = "." ]; then
        PKG_NAME="root"
    else
        PKG_NAME="$PKG"
    fi
    
    if [ "$PKG" != "." ] && [ ! -d "$PKG" ]; then
        echo "⚠️  Skipping $PKG_NAME (directory not found)"
        continue
    fi
    
    if [ ! -f "$PKG/pubspec.yaml" ]; then
        echo "⚠️  Skipping $PKG_NAME (no pubspec.yaml)"
        continue
    fi
    
    if (cd "$PKG" && flutter pub run build_runner build --delete-conflicting-outputs); then
        echo "✅ $PKG_NAME: Success"
    else
        echo "❌ $PKG_NAME: Failed"
    fi
done

echo ""
echo "✅ Build process completed!"