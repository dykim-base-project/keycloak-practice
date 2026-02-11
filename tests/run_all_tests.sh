#!/bin/bash
# Master test runner for all Claude DevEx validation tests
# Runs all test suites and provides consolidated results

set -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Change to tests directory
cd "$(dirname "$0")"

echo "================================================"
echo "  Claude DevEx Comprehensive Test Suite"
echo "================================================"
echo ""

# Track overall results
TOTAL_SUITES=0
PASSED_SUITES=0
FAILED_SUITES=0

# Function to run a test suite
run_test_suite() {
    local suite_name="$1"
    local suite_script="$2"

    echo -e "${BLUE}Running: $suite_name${NC}"
    echo "-------------------------------------------"

    TOTAL_SUITES=$((TOTAL_SUITES + 1))

    if bash "$suite_script"; then
        PASSED_SUITES=$((PASSED_SUITES + 1))
        echo -e "${GREEN}✓ $suite_name PASSED${NC}"
    else
        FAILED_SUITES=$((FAILED_SUITES + 1))
        echo -e "${RED}✗ $suite_name FAILED${NC}"
    fi

    echo ""
    echo ""
}

# Run all test suites
run_test_suite "Basic Validation Tests" "validate_devex_files.sh"
run_test_suite "Edge Cases & Negative Tests" "edge_cases_and_negative_tests.sh"

# Print final summary
echo "================================================"
echo "  Final Test Summary"
echo "================================================"
echo ""
echo "Total test suites run: $TOTAL_SUITES"
echo -e "${GREEN}Passed: $PASSED_SUITES${NC}"

if [ $FAILED_SUITES -gt 0 ]; then
    echo -e "${RED}Failed: $FAILED_SUITES${NC}"
    echo ""
    echo -e "${RED}OVERALL RESULT: FAILED${NC}"
    exit 1
else
    echo "Failed: 0"
    echo ""
    echo -e "${GREEN}OVERALL RESULT: ALL TESTS PASSED${NC}"
    exit 0
fi