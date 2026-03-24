#!/bin/bash
# Script to fix withOpacity deprecation warnings

echo "🔧 Fixing withOpacity deprecation warnings..."

# Find all Dart files with withOpacity and replace with withValues(alpha:)
find lib -name "*.dart" -type f -exec sed -i '' 's/\.withOpacity(\([^)]*\))/\.withValues(alpha: \1)/g' {} \;

echo "✅ Fixed withOpacity in all lib files"
echo ""
echo "📊 Running flutter analyze to verify..."
flutter analyze | grep -E "withOpacity|error" || echo "✅ No more withOpacity warnings!"
