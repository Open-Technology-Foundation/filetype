#!/usr/bin/env bash
# run_all_tests.sh - Master test runner for filetype comprehensive test suite
# Runs all test suites and provides summary

set -euo pipefail

cd "$(dirname "$0")"

# Color codes
if [[ -t 1 ]]; then
  RED='\033[0;31m'
  GREEN='\033[0;32m'
  BLUE='\033[0;34m'
  NC='\033[0m'
else
  RED='' GREEN='' BLUE='' NC=''
fi

# Track overall results
TOTAL_SUITES=0
PASSED_SUITES=0
FAILED_SUITES=0

START_TIME=$(date +%s)

echo "======================================================================"
echo "  FILETYPE - COMPREHENSIVE TEST SUITE"
echo "======================================================================"
echo ""

# Function to run a test suite
run_suite() {
  local name="$1"
  local command="$2"

  ((TOTAL_SUITES+=1))

  echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${BLUE}Running: $name${NC}"
  echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo ""

  if $command; then
    echo ""
    echo -e "${GREEN}✓ $name PASSED${NC}"
    ((PASSED_SUITES+=1))
    return 0
  else
    echo ""
    echo -e "${RED}✗ $name FAILED${NC}"
    ((FAILED_SUITES+=1))
    return 1
  fi
}

# ========================================
# 1. SETUP FIXTURES
# ========================================

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}Step 1: Setting up test fixtures${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

if ./setup_fixtures.sh; then
  echo -e "${GREEN}✓ Fixtures created successfully${NC}"
else
  echo -e "${RED}✗ Failed to create fixtures${NC}"
  exit 1
fi

echo ""

# ========================================
# 2. RUN TEST SUITES
# ========================================

run_suite "Bash Implementation Tests" "./test_bash.sh" || true
run_suite "Editcmd Tests (Bash)" "./test_editcmd.sh" || true
run_suite "Library Mode Tests (Bash)" "./test_library_mode.sh" || true

# ========================================
# 3. FINAL SUMMARY
# ========================================

END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))

echo ""
echo "======================================================================"
echo "  FINAL TEST SUMMARY"
echo "======================================================================"
echo ""
echo "Test Suites Run:    $TOTAL_SUITES"
echo -e "${GREEN}Suites Passed:      $PASSED_SUITES${NC}"

if [[ $FAILED_SUITES -gt 0 ]]; then
  echo -e "${RED}Suites Failed:      $FAILED_SUITES${NC}"
else
  echo "Suites Failed:      $FAILED_SUITES"
fi

echo ""
echo "Time: ${DURATION}s"
echo "======================================================================"

if [[ $FAILED_SUITES -eq 0 ]]; then
  echo -e "${GREEN}"
  echo "  ███████╗██╗   ██╗ ██████╗ ██████╗███████╗███████╗███████╗"
  echo "  ██╔════╝██║   ██║██╔════╝██╔════╝██╔════╝██╔════╝██╔════╝"
  echo "  ███████╗██║   ██║██║     ██║     █████╗  ███████╗███████╗"
  echo "  ╚════██║██║   ██║██║     ██║     ██╔══╝  ╚════██║╚════██║"
  echo "  ███████║╚██████╔╝╚██████╗╚██████╗███████╗███████║███████║"
  echo "  ╚══════╝ ╚═════╝  ╚═════╝ ╚═════╝╚══════╝╚══════╝╚══════╝"
  echo -e "${NC}"
  echo ""
  echo -e "${GREEN}All test suites passed! ✓${NC}"
  echo ""
  exit 0
else
  echo -e "${RED}"
  echo "  ███████╗ █████╗ ██╗██╗     ██╗   ██╗██████╗ ███████╗"
  echo "  ██╔════╝██╔══██╗██║██║     ██║   ██║██╔══██╗██╔════╝"
  echo "  █████╗  ███████║██║██║     ██║   ██║██████╔╝█████╗  "
  echo "  ██╔══╝  ██╔══██║██║██║     ██║   ██║██╔══██╗██╔══╝  "
  echo "  ██║     ██║  ██║██║███████╗╚██████╔╝██║  ██║███████╗"
  echo "  ╚═╝     ╚═╝  ╚═╝╚═╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝"
  echo -e "${NC}"
  echo ""
  echo -e "${RED}Some test suites failed. Please review the output above.${NC}"
  echo ""
  exit 1
fi

#fin
