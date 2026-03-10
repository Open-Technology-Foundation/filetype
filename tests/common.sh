#!/usr/bin/env bash
# common.sh - Shared test utilities for filetype test suite

# Test counters
declare -g PASS_COUNT=0
declare -g FAIL_COUNT=0
declare -g SKIP_COUNT=0

# Color codes
if [[ -t 1 ]]; then
  declare -g RED='\033[0;31m'
  declare -g GREEN='\033[0;32m'
  declare -g YELLOW='\033[1;33m'
  declare -g NC='\033[0m'
else
  declare -g RED='' GREEN='' YELLOW='' NC=''
fi

# Paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FILETYPE_BASH="${SCRIPT_DIR}/../filetype"

# Assert functions
assert_equals() {
  local expected="$1"
  local actual="$2"
  local description="$3"

  if [[ "$expected" == "$actual" ]]; then
    echo -e "${GREEN}PASS${NC}: $description"
    ((PASS_COUNT+=1))
    return 0
  else
    echo -e "${RED}FAIL${NC}: $description"
    echo "  Expected: '$expected'"
    echo "  Got:      '$actual'"
    ((FAIL_COUNT+=1))
    return 1
  fi
}

assert_contains() {
  local haystack="$1"
  local needle="$2"
  local description="$3"

  if [[ "$haystack" == *"$needle"* ]]; then
    echo -e "${GREEN}PASS${NC}: $description"
    ((PASS_COUNT+=1))
    return 0
  else
    echo -e "${RED}FAIL${NC}: $description"
    echo "  Expected to contain: '$needle'"
    echo "  Got:                 '$haystack'"
    ((FAIL_COUNT+=1))
    return 1
  fi
}

assert_exit_code() {
  local expected_code="$1"
  local actual_code="$2"
  local description="$3"

  if [[ "$expected_code" -eq "$actual_code" ]]; then
    echo -e "${GREEN}PASS${NC}: $description"
    ((PASS_COUNT+=1))
    return 0
  else
    echo -e "${RED}FAIL${NC}: $description"
    echo "  Expected exit code: $expected_code"
    echo "  Got exit code:      $actual_code"
    ((FAIL_COUNT+=1))
    return 1
  fi
}

assert_not_equals() {
  local not_expected="$1"
  local actual="$2"
  local description="$3"

  if [[ "$not_expected" != "$actual" ]]; then
    echo -e "${GREEN}PASS${NC}: $description"
    ((PASS_COUNT+=1))
    return 0
  else
    echo -e "${RED}FAIL${NC}: $description"
    echo "  Should not equal: '$not_expected'"
    echo "  But got:          '$actual'"
    ((FAIL_COUNT+=1))
    return 1
  fi
}

assert_not_contains() {
  local haystack="$1"
  local needle="$2"
  local description="$3"

  if [[ "$haystack" != *"$needle"* ]]; then
    echo -e "${GREEN}PASS${NC}: $description"
    ((PASS_COUNT+=1))
    return 0
  else
    echo -e "${RED}FAIL${NC}: $description"
    echo "  Should not contain: '$needle'"
    echo "  But got:            '$haystack'"
    ((FAIL_COUNT+=1))
    return 1
  fi
}

skip_test() {
  local reason="$1"
  echo -e "${YELLOW}SKIP${NC}: $reason"
  ((SKIP_COUNT+=1))
}

# Print test section header
print_section() {
  local title="$1"
  echo ""
  echo "========================================  "
  echo "  $title"
  echo "========================================"
}

# Print test summary
print_summary() {
  local total=$((PASS_COUNT + FAIL_COUNT + SKIP_COUNT))
  echo ""
  echo "========================================"
  echo "  TEST SUMMARY"
  echo "========================================"
  echo "Total:  $total"
  echo -e "${GREEN}Passed: $PASS_COUNT${NC}"
  if [[ $FAIL_COUNT -gt 0 ]]; then
    echo -e "${RED}Failed: $FAIL_COUNT${NC}"
  else
    echo "Failed: $FAIL_COUNT"
  fi
  if [[ $SKIP_COUNT -gt 0 ]]; then
    echo -e "${YELLOW}Skipped: $SKIP_COUNT${NC}"
  fi
  echo "========================================"

  if [[ $FAIL_COUNT -gt 0 ]]; then
    return 1
  else
    return 0
  fi
}

# Run filetype bash version
run_filetype_bash() {
  "$FILETYPE_BASH" "$@"
}


# Export functions for use in sub-scripts
export -f assert_equals
export -f assert_contains
export -f assert_not_contains
export -f assert_exit_code
export -f assert_not_equals
export -f skip_test
export -f print_section
export -f print_summary
export -f run_filetype_bash

#fin
