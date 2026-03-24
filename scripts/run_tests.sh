#!/bin/bash
# Crack the Code Test Runner Script
# Usage: ./scripts/run_tests.sh [--coverage] [--ci]

set -e

COVERAGE=false
CI_MODE=false
MIN_COVERAGE=30  # Minimum coverage percentage required

# Parse arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --coverage) COVERAGE=true ;;
        --ci) CI_MODE=true ;;
        --min-coverage) MIN_COVERAGE="$2"; shift ;;
        *) echo "Unknown parameter: $1"; exit 1 ;;
    esac
    shift
done

echo "=========================================="
echo "Crack the Code Test Runner"
echo "=========================================="
echo "Coverage: $COVERAGE"
echo "CI Mode: $CI_MODE"
echo ""

# Run Flutter tests
if [ "$COVERAGE" = true ]; then
    echo "Running tests with coverage..."
    flutter test --coverage --reporter compact

    # Check if lcov is installed for coverage report generation
    if command -v lcov &> /dev/null; then
        echo ""
        echo "Generating coverage report..."

        # Remove generated files from coverage
        lcov --remove coverage/lcov.info \
            '*.g.dart' \
            '*.freezed.dart' \
            '*/generated/*' \
            '*/mocks/*' \
            '*/test/*' \
            -o coverage/lcov.info --ignore-errors unused

        # Generate HTML report if not in CI mode
        if [ "$CI_MODE" = false ]; then
            genhtml coverage/lcov.info -o coverage/html --ignore-errors unmapped
            echo ""
            echo "Coverage HTML report generated at: coverage/html/index.html"
        fi

        # Extract coverage percentage
        COVERAGE_PCT=$(lcov --summary coverage/lcov.info 2>&1 | grep "lines" | awk '{print $2}' | sed 's/%//')

        echo ""
        echo "=========================================="
        echo "Coverage Summary: ${COVERAGE_PCT}%"
        echo "=========================================="

        # Check minimum coverage in CI mode
        if [ "$CI_MODE" = true ]; then
            if (( $(echo "$COVERAGE_PCT < $MIN_COVERAGE" | bc -l) )); then
                echo "ERROR: Coverage ${COVERAGE_PCT}% is below minimum ${MIN_COVERAGE}%"
                exit 1
            else
                echo "Coverage check passed!"
            fi
        fi
    else
        echo "Warning: lcov not installed. Install with: brew install lcov"
        echo "Raw coverage data saved to: coverage/lcov.info"
    fi
else
    echo "Running tests..."
    flutter test --reporter compact
fi

echo ""
echo "Tests completed!"
