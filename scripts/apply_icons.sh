#!/bin/bash

# Script to apply launcher icons for all Crack the Code segments
# Each segment gets its own unique icon

set -e

echo "🚀 Applying launcher icons for all Crack the Code segments..."
echo ""

# Array of segments
segments=("junior" "middle" "senior" "preboard")

# Generate icons for each segment
for segment in "${segments[@]}"
do
    echo "📱 Applying icons for $segment segment..."
    dart run flutter_launcher_icons -f flutter_launcher_icons-$segment.yaml
    echo "   ✅ $segment icons applied successfully!"
    echo ""
done

echo "✨ All icons have been applied successfully!"
echo ""
echo "🎯 Summary:"
echo "  - Junior (grades 4-7): Bright blue & orange with playful book icon"
echo "  - Middle (grades 7-9): Teal & green with lightbulb icon"
echo "  - Preboard (grade 10): Orange & red with trophy icon"
echo "  - Senior (grades 11-12): Deep purple with graduation cap icon"
echo ""
echo "📝 Next steps:"
echo "  1. Build the app for your desired flavor"
echo "  2. The unique icon will automatically appear"
echo ""
