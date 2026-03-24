#!/bin/bash

echo "🧪 Quiz Completion & Recommendations Testing Script"
echo "=================================================="
echo ""
echo "This script will monitor logs to debug why recommendations aren't generating."
echo ""

# Clear existing logs
echo "📋 Clearing logcat..."
adb logcat -c

echo "✅ Logs cleared"
echo ""
echo "=== INSTRUCTIONS ==="
echo "1. On your device, tap the purple 'TEST' button (bottom-right)"
echo "2. Tap 'Readiness Check' to test recommendations"
echo ""
echo "OR"
echo ""
echo "1. Navigate to any quiz in the app"
echo "2. Complete the quiz"
echo "3. View the results screen"
echo ""
echo "This script will capture and display all relevant logs."
echo ""
echo "Press Ctrl+C when done to stop monitoring."
echo ""
echo "=== MONITORING LOGS ==="
echo ""

# Monitor logs in real-time
adb logcat -s flutter:I flutter:W flutter:E | grep --line-buffered -E "QuizResults|Recommendations|Analyzing|weak|Weak|concept|Concept|📊|⚠️" | while read line; do
    echo "$line"
done
