#!/usr/bin/env bash
# test_editcmd.sh - Comprehensive test suite for editcmd (bash and python)
# Tests version flags, print flags, EDITOR handling, line positioning, and error cases

set -euo pipefail

cd "$(dirname "$0")"
source ./common.sh

EDITCMD="../editcmd"
EDITCMD_PY="../editcmd.py"

echo "======================================================================"
echo "  EDITCMD COMPREHENSIVE TEST SUITE"
echo "======================================================================"

# ========================================
# 1. VERSION FLAG TESTS
# ========================================

print_section "Version Flag Tests"

# Bash version
result=$($EDITCMD -V)
assert_contains "$result" "editcmd" "Bash: -V outputs 'editcmd'"
assert_contains "$result" "1.0.0" "Bash: -V outputs version number"

result=$($EDITCMD --version)
assert_contains "$result" "editcmd" "Bash: --version outputs 'editcmd'"
assert_contains "$result" "1.0.0" "Bash: --version outputs version number"

# Python version
result=$($EDITCMD_PY -V)
assert_contains "$result" "editcmd" "Python: -V outputs 'editcmd'"
assert_contains "$result" "1.0.0" "Python: -V outputs version number"

result=$($EDITCMD_PY --version)
assert_contains "$result" "editcmd" "Python: --version outputs 'editcmd'"
assert_contains "$result" "1.0.0" "Python: --version outputs version number"

# Version exits successfully
$EDITCMD -V >/dev/null && exit_code=$? || exit_code=$?
assert_exit_code 0 "$exit_code" "Bash: -V exits with 0"

$EDITCMD_PY --version >/dev/null && exit_code=$? || exit_code=$?
assert_exit_code 0 "$exit_code" "Python: --version exits with 0"

# ========================================
# 2. PRINT FLAG TESTS
# ========================================

print_section "Print Flag Tests (-p, --print, --dry-run)"

# Test -p flag (bash)
result=$($EDITCMD -p fixtures/extensions/test.py)
assert_contains "$result" "test.py" "Bash: -p includes filename"
assert_not_contains "$result" "error" "Bash: -p no error"

# Test --print flag (bash)
result=$($EDITCMD --print fixtures/extensions/test.py)
assert_contains "$result" "test.py" "Bash: --print includes filename"
assert_not_contains "$result" "error" "Bash: --print no error"

# Test --dry-run flag (bash)
result=$($EDITCMD --dry-run fixtures/extensions/test.py)
assert_contains "$result" "test.py" "Bash: --dry-run includes filename"
assert_not_contains "$result" "error" "Bash: --dry-run no error"

# Test -p flag (python)
result=$($EDITCMD_PY -p fixtures/extensions/test.py)
assert_contains "$result" "test.py" "Python: -p includes filename"
assert_not_contains "$result" "error" "Python: -p no error"

# Test --print flag (python)
result=$($EDITCMD_PY --print fixtures/extensions/test.py)
assert_contains "$result" "test.py" "Python: --print includes filename"
assert_not_contains "$result" "error" "Python: --print no error"

# Test --dry-run flag (python)
result=$($EDITCMD_PY --dry-run fixtures/extensions/test.py)
assert_contains "$result" "test.py" "Python: --dry-run includes filename"
assert_not_contains "$result" "error" "Python: --dry-run no error"

# ========================================
# 3. EDITOR ENVIRONMENT VARIABLE TESTS
# ========================================

print_section "EDITOR Environment Variable Handling"

# No EDITOR set - should default to vim (bash)
result=$(unset EDITOR; $EDITCMD -p fixtures/extensions/test.py)
assert_contains "$result" "vim" "Bash: No EDITOR defaults to vim"

# No EDITOR set - should default to vim (python)
result=$(unset EDITOR; $EDITCMD_PY -p fixtures/extensions/test.py)
assert_contains "$result" "vim" "Python: No EDITOR defaults to vim"

# EDITOR=joe - should use joe (bash)
result=$(EDITOR=/usr/bin/joe $EDITCMD -p fixtures/extensions/test.py)
assert_contains "$result" "joe" "Bash: EDITOR=joe uses joe"
assert_not_contains "$result" "vim" "Bash: EDITOR=joe does not use vim"

# EDITOR=joe - should use joe (python)
result=$(EDITOR=/usr/bin/joe $EDITCMD_PY -p fixtures/extensions/test.py)
assert_contains "$result" "joe" "Python: EDITOR=joe uses joe"
assert_not_contains "$result" "vim" "Python: EDITOR=joe does not use vim"

# EDITOR=nano - should use nano (bash)
result=$(EDITOR=nano $EDITCMD -p fixtures/extensions/test.py)
assert_contains "$result" "nano" "Bash: EDITOR=nano uses nano"

# EDITOR=nano - should use nano (python)
result=$(EDITOR=nano $EDITCMD_PY -p fixtures/extensions/test.py)
assert_contains "$result" "nano" "Python: EDITOR=nano uses nano"

# EDITOR=vim - should use vim (bash)
result=$(EDITOR=vim $EDITCMD -p fixtures/extensions/test.py)
assert_contains "$result" "vim" "Bash: EDITOR=vim uses vim"

# EDITOR=vim - should use vim (python)
result=$(EDITOR=vim $EDITCMD_PY -p fixtures/extensions/test.py)
assert_contains "$result" "vim" "Python: EDITOR=vim uses vim"

# EDITOR=emacs - should use emacs (bash)
result=$(EDITOR=emacs $EDITCMD -p fixtures/extensions/test.py)
assert_contains "$result" "emacs" "Bash: EDITOR=emacs uses emacs"

# EDITOR=emacs - should use emacs (python)
result=$(EDITOR=emacs $EDITCMD_PY -p fixtures/extensions/test.py)
assert_contains "$result" "emacs" "Python: EDITOR=emacs uses emacs"

# -e flag overrides EDITOR (bash)
result=$(EDITOR=vim $EDITCMD -p -e nano fixtures/extensions/test.py)
assert_contains "$result" "nano" "Bash: -e nano overrides EDITOR=vim"
assert_not_contains "$result" "vim" "Bash: -e nano does not use vim"

# -e flag overrides EDITOR (python)
result=$(EDITOR=vim $EDITCMD_PY -p -e nano fixtures/extensions/test.py)
assert_contains "$result" "nano" "Python: -e nano overrides EDITOR=vim"
assert_not_contains "$result" "vim" "Python: -e nano does not use vim"

# ========================================
# 4. LINE POSITIONING TESTS
# ========================================

print_section "Line Positioning (-l and +NUM)"

# -l flag (bash)
result=$($EDITCMD -p -l 42 fixtures/extensions/test.py)
assert_contains "$result" "+42" "Bash: -l 42 includes +42"
assert_contains "$result" "test.py" "Bash: -l 42 includes filename"

# -l flag (python)
result=$($EDITCMD_PY -p -l 42 fixtures/extensions/test.py)
assert_contains "$result" "+42" "Python: -l 42 includes +42"
assert_contains "$result" "test.py" "Python: -l 42 includes filename"

# +NUM shorthand (bash)
result=$($EDITCMD -p +100 fixtures/extensions/test.py)
assert_contains "$result" "+100" "Bash: +100 includes +100"
assert_contains "$result" "test.py" "Bash: +100 includes filename"

# +NUM shorthand (python)
result=$($EDITCMD_PY -p +100 fixtures/extensions/test.py)
assert_contains "$result" "+100" "Python: +100 includes +100"
assert_contains "$result" "test.py" "Python: +100 includes filename"

# Line 0 (no line positioning) (bash)
result=$($EDITCMD -p -l 0 fixtures/extensions/test.py)
assert_not_contains "$result" "+0" "Bash: -l 0 does not include +0"

# Line 0 (no line positioning) (python)
result=$($EDITCMD_PY -p -l 0 fixtures/extensions/test.py)
assert_not_contains "$result" "+0" "Python: -l 0 does not include +0"

# Negative line number should error (bash)
$EDITCMD -p -l -5 fixtures/extensions/test.py 2>/dev/null && exit_code=$? || exit_code=$?
assert_exit_code 1 "$exit_code" "Bash: negative line number exits 1"

# Negative line number should error (python)
$EDITCMD_PY -p -l -5 fixtures/extensions/test.py 2>/dev/null && exit_code=$? || exit_code=$?
assert_exit_code 1 "$exit_code" "Python: negative line number exits 1"

# ========================================
# 5. EDITOR SELECTION TESTS
# ========================================

print_section "Editor Selection (-e flag)"

# joe editor (bash)
result=$($EDITCMD -p -e joe fixtures/extensions/test.py)
assert_contains "$result" "joe" "Bash: -e joe uses joe"
assert_contains "$result" "-syntax" "Bash: -e joe includes -syntax"

# joe editor (python)
result=$($EDITCMD_PY -p -e joe fixtures/extensions/test.py)
assert_contains "$result" "joe" "Python: -e joe uses joe"
assert_contains "$result" "-syntax" "Python: -e joe includes -syntax"

# nano editor (bash)
result=$($EDITCMD -p -e nano fixtures/extensions/test.py)
assert_contains "$result" "nano" "Bash: -e nano uses nano"
assert_contains "$result" "--syntax=" "Bash: -e nano includes --syntax="

# nano editor (python)
result=$($EDITCMD_PY -p -e nano fixtures/extensions/test.py)
assert_contains "$result" "nano" "Python: -e nano uses nano"
assert_contains "$result" "--syntax=" "Python: -e nano includes --syntax="

# vim editor (bash)
result=$($EDITCMD -p -e vim fixtures/extensions/test.py)
assert_contains "$result" "vim" "Bash: -e vim uses vim"
assert_contains "$result" "set filetype=" "Bash: -e vim includes set filetype="

# vim editor (python)
result=$($EDITCMD_PY -p -e vim fixtures/extensions/test.py)
assert_contains "$result" "vim" "Python: -e vim uses vim"
assert_contains "$result" "set filetype=" "Python: -e vim includes set filetype="

# emacs editor (bash)
result=$($EDITCMD -p -e emacs fixtures/extensions/test.py)
assert_contains "$result" "emacs" "Bash: -e emacs uses emacs"

# emacs editor (python)
result=$($EDITCMD_PY -p -e emacs fixtures/extensions/test.py)
assert_contains "$result" "emacs" "Python: -e emacs uses emacs"

# vscode editor (bash)
result=$($EDITCMD -p -e vscode fixtures/extensions/test.py)
assert_contains "$result" "code" "Bash: -e vscode uses code"

# vscode editor (python)
result=$($EDITCMD_PY -p -e vscode fixtures/extensions/test.py)
assert_contains "$result" "code" "Python: -e vscode uses code"

# Invalid editor (bash)
$EDITCMD -e invalid fixtures/extensions/test.py 2>/dev/null && exit_code=$? || exit_code=$?
assert_exit_code 22 "$exit_code" "Bash: invalid editor exits 22"

# Invalid editor (python)
$EDITCMD_PY -e invalid fixtures/extensions/test.py 2>/dev/null && exit_code=$? || exit_code=$?
assert_exit_code 22 "$exit_code" "Python: invalid editor exits 22"

# ========================================
# 6. SYNTAX DETECTION INTEGRATION
# ========================================

print_section "Syntax Detection Integration"

# Shell script (bash)
result=$($EDITCMD -p fixtures/extensions/test.sh)
assert_contains "$result" "test.sh" "Bash: detects .sh file"
assert_contains "$result" "sh" "Bash: .sh gets sh syntax"

# Shell script (python)
result=$($EDITCMD_PY -p fixtures/extensions/test.sh)
assert_contains "$result" "test.sh" "Python: detects .sh file"
assert_contains "$result" "sh" "Python: .sh gets sh syntax"

# Python script (bash)
result=$($EDITCMD -p fixtures/extensions/test.py)
assert_contains "$result" "test.py" "Bash: detects .py file"
assert_contains "$result" "python" "Bash: .py gets python syntax"

# Python script (python)
result=$($EDITCMD_PY -p fixtures/extensions/test.py)
assert_contains "$result" "test.py" "Python: detects .py file"
assert_contains "$result" "python" "Python: .py gets python syntax"

# C source (bash)
result=$($EDITCMD -p -e vim fixtures/extensions/test.c)
assert_contains "$result" "test.c" "Bash: detects .c file"
assert_contains "$result" "c" "Bash: .c gets c syntax (vim)"

# C++ source (bash)
result=$($EDITCMD -p -e vim fixtures/extensions/test.cpp)
assert_contains "$result" "test.cpp" "Bash: detects .cpp file"
assert_contains "$result" "cpp" "Bash: .cpp gets cpp syntax (vim)"

# JavaScript (bash)
result=$($EDITCMD -p -e nano fixtures/extensions/test.js)
assert_contains "$result" "test.js" "Bash: detects .js file"
assert_contains "$result" "javascript" "Bash: .js gets javascript syntax (nano)"

# Markdown (bash)
result=$($EDITCMD -p -e vim fixtures/extensions/test.md)
assert_contains "$result" "test.md" "Bash: detects .md file"
assert_contains "$result" "markdown" "Bash: .md gets markdown syntax (vim)"

# Bash script with shebang (bash)
result=$($EDITCMD -p -e vim fixtures/edge_cases/has_ext.sh)
assert_contains "$result" "has_ext.sh" "Bash: detects bash shebang"
assert_contains "$result" "bash" "Bash: bash shebang → bash syntax (vim)"

# ========================================
# 7. ERROR HANDLING TESTS
# ========================================

print_section "Error Handling"

# No file specified (bash)
$EDITCMD 2>/dev/null && exit_code=$? || exit_code=$?
assert_exit_code 1 "$exit_code" "Bash: no file → exit 1"

# No file specified (python)
$EDITCMD_PY 2>/dev/null && exit_code=$? || exit_code=$?
assert_exit_code 1 "$exit_code" "Python: no file → exit 1"

# Binary file rejection (bash)
$EDITCMD fixtures/binary/elf_test 2>/dev/null && exit_code=$? || exit_code=$?
assert_exit_code 1 "$exit_code" "Bash: binary file → exit 1"

# Binary file rejection (python)
$EDITCMD_PY fixtures/binary/elf_test 2>/dev/null && exit_code=$? || exit_code=$?
assert_exit_code 1 "$exit_code" "Python: binary file → exit 1"

# Multiple filenames not supported (bash)
$EDITCMD fixtures/extensions/test.py fixtures/extensions/test.sh 2>/dev/null && exit_code=$? || exit_code=$?
assert_exit_code 1 "$exit_code" "Bash: multiple files → exit 1"

# Multiple filenames not supported (python)
$EDITCMD_PY fixtures/extensions/test.py fixtures/extensions/test.sh 2>/dev/null && exit_code=$? || exit_code=$?
assert_exit_code 1 "$exit_code" "Python: multiple files → exit 1"

# Unknown option (bash)
$EDITCMD -x fixtures/extensions/test.py 2>/dev/null && exit_code=$? || exit_code=$?
assert_exit_code 22 "$exit_code" "Bash: unknown option → exit 22"

# Unknown option (python)
$EDITCMD_PY -x fixtures/extensions/test.py 2>/dev/null && exit_code=$? || exit_code=$?
assert_exit_code 22 "$exit_code" "Python: unknown option → exit 22"

# Help exits successfully (bash)
$EDITCMD --help >/dev/null && exit_code=$? || exit_code=$?
assert_exit_code 0 "$exit_code" "Bash: --help → exit 0"

# Help exits successfully (python)
$EDITCMD_PY --help >/dev/null && exit_code=$? || exit_code=$?
assert_exit_code 0 "$exit_code" "Python: --help → exit 0"

# ========================================
# 8. COMBINED OPTIONS TESTS
# ========================================

print_section "Combined Options"

# -e + -l combined (bash)
result=$($EDITCMD -p -e vim -l 50 fixtures/extensions/test.py)
assert_contains "$result" "vim" "Bash: -e vim -l 50 includes vim"
assert_contains "$result" "+50" "Bash: -e vim -l 50 includes +50"
assert_contains "$result" "test.py" "Bash: -e vim -l 50 includes filename"

# -e + -l combined (python)
result=$($EDITCMD_PY -p -e vim -l 50 fixtures/extensions/test.py)
assert_contains "$result" "vim" "Python: -e vim -l 50 includes vim"
assert_contains "$result" "+50" "Python: -e vim -l 50 includes +50"
assert_contains "$result" "test.py" "Python: -e vim -l 50 includes filename"

# -e + +NUM combined (bash)
result=$($EDITCMD -p -e nano +25 fixtures/extensions/test.py)
assert_contains "$result" "nano" "Bash: -e nano +25 includes nano"
assert_contains "$result" "+25" "Bash: -e nano +25 includes +25"
assert_contains "$result" "test.py" "Bash: -e nano +25 includes filename"

# -e + +NUM combined (python)
result=$($EDITCMD_PY -p -e nano +25 fixtures/extensions/test.py)
assert_contains "$result" "nano" "Python: -e nano +25 includes nano"
assert_contains "$result" "+25" "Python: -e nano +25 includes +25"
assert_contains "$result" "test.py" "Python: -e nano +25 includes filename"

# Short option aggregation -pe (bash)
result=$($EDITCMD -pe vim fixtures/extensions/test.py)
assert_contains "$result" "vim" "Bash: -pe vim aggregation works"
assert_contains "$result" "test.py" "Bash: -pe vim includes filename"

# Short option aggregation -pV (bash)
result=$($EDITCMD -pV 2>&1 | head -1)
assert_contains "$result" "editcmd" "Bash: -pV aggregation shows version"

# ========================================
# 9. FILENAME WITH SPACES TESTS
# ========================================

print_section "Filenames with Spaces"

# Bash: filename with spaces
result=$($EDITCMD -p 'fixtures/edge_cases/file with spaces.sh')
# Check for partial filename (will match any escaping/quoting form)
assert_contains "$result" "spaces.sh" "Bash: handles spaces in filename"
assert_not_contains "$result" "error" "Bash: no error for spaces"

# Python: filename with spaces
result=$($EDITCMD_PY -p 'fixtures/edge_cases/file with spaces.sh')
# Check for partial filename (will match any escaping/quoting form)
assert_contains "$result" "spaces.sh" "Python: handles spaces in filename"
assert_not_contains "$result" "error" "Python: no error for spaces"

# ========================================
# 10. NON-EXISTENT FILE TESTS
# ========================================

print_section "Non-existent Files"

# Non-existent file with extension (bash)
result=$($EDITCMD -p nonexistent.py)
assert_contains "$result" "nonexistent.py" "Bash: handles non-existent .py"
assert_contains "$result" "python" "Bash: non-existent .py → python syntax"

# Non-existent file with extension (python)
result=$($EDITCMD_PY -p nonexistent.py)
assert_contains "$result" "nonexistent.py" "Python: handles non-existent .py"
assert_contains "$result" "python" "Python: non-existent .py → python syntax"

# Non-existent file without extension (bash)
result=$($EDITCMD -p nonexistent_file)
assert_contains "$result" "nonexistent_file" "Bash: handles non-existent no-ext"

# Non-existent file without extension (python)
result=$($EDITCMD_PY -p nonexistent_file)
assert_contains "$result" "nonexistent_file" "Python: handles non-existent no-ext"

# ========================================
# SUMMARY
# ========================================

print_summary
exit_code=$?

exit $exit_code

#fin
