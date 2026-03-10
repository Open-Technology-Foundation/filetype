#!/usr/bin/env bash
# test_editcmd.sh - Comprehensive test suite for editcmd (bash)
# Tests version flags, print flags, EDITOR handling, line positioning, and error cases

set -euo pipefail

cd "$(dirname "$0")"
source ./common.sh

EDITCMD="../editcmd"

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

# Version exits successfully
$EDITCMD -V >/dev/null && exit_code=$? || exit_code=$?
assert_exit_code 0 "$exit_code" "Bash: -V exits with 0"

# ========================================
# 2. PRINT FLAG TESTS
# ========================================

print_section "Print Flag Tests (-p, --print, --dry-run)"

# Test -p flag
result=$($EDITCMD -p fixtures/extensions/test.py)
assert_contains "$result" "test.py" "Bash: -p includes filename"
assert_not_contains "$result" "error" "Bash: -p no error"

# Test --print flag
result=$($EDITCMD --print fixtures/extensions/test.py)
assert_contains "$result" "test.py" "Bash: --print includes filename"
assert_not_contains "$result" "error" "Bash: --print no error"

# Test --dry-run flag
result=$($EDITCMD --dry-run fixtures/extensions/test.py)
assert_contains "$result" "test.py" "Bash: --dry-run includes filename"
assert_not_contains "$result" "error" "Bash: --dry-run no error"

# ========================================
# 3. EDITOR ENVIRONMENT VARIABLE TESTS
# ========================================

print_section "EDITOR Environment Variable Handling"

# No EDITOR set - should default to vim
result=$(unset EDITOR; $EDITCMD -p fixtures/extensions/test.py)
assert_contains "$result" "vim" "Bash: No EDITOR defaults to vim"

# EDITOR=joe - should use joe
result=$(EDITOR=/usr/bin/joe $EDITCMD -p fixtures/extensions/test.py)
assert_contains "$result" "joe" "Bash: EDITOR=joe uses joe"
assert_not_contains "$result" "vim" "Bash: EDITOR=joe does not use vim"

# EDITOR=nano - should use nano
result=$(EDITOR=nano $EDITCMD -p fixtures/extensions/test.py)
assert_contains "$result" "nano" "Bash: EDITOR=nano uses nano"

# EDITOR=vim - should use vim
result=$(EDITOR=vim $EDITCMD -p fixtures/extensions/test.py)
assert_contains "$result" "vim" "Bash: EDITOR=vim uses vim"

# EDITOR=emacs - should use emacs
result=$(EDITOR=emacs $EDITCMD -p fixtures/extensions/test.py)
assert_contains "$result" "emacs" "Bash: EDITOR=emacs uses emacs"

# -e flag overrides EDITOR
result=$(EDITOR=vim $EDITCMD -p -e nano fixtures/extensions/test.py)
assert_contains "$result" "nano" "Bash: -e nano overrides EDITOR=vim"
assert_not_contains "$result" "vim" "Bash: -e nano does not use vim"

# ========================================
# 4. LINE POSITIONING TESTS
# ========================================

print_section "Line Positioning (-l and +NUM)"

# -l flag
result=$($EDITCMD -p -l 42 fixtures/extensions/test.py)
assert_contains "$result" "+42" "Bash: -l 42 includes +42"
assert_contains "$result" "test.py" "Bash: -l 42 includes filename"

# +NUM shorthand
result=$($EDITCMD -p +100 fixtures/extensions/test.py)
assert_contains "$result" "+100" "Bash: +100 includes +100"
assert_contains "$result" "test.py" "Bash: +100 includes filename"

# Line 0 (no line positioning)
result=$($EDITCMD -p -l 0 fixtures/extensions/test.py)
assert_not_contains "$result" "+0" "Bash: -l 0 does not include +0"

# Negative line number should error
$EDITCMD -p -l -5 fixtures/extensions/test.py 2>/dev/null && exit_code=$? || exit_code=$?
assert_exit_code 1 "$exit_code" "Bash: negative line number exits 1"

# ========================================
# 5. EDITOR SELECTION TESTS
# ========================================

print_section "Editor Selection (-e flag)"

# joe editor
result=$($EDITCMD -p -e joe fixtures/extensions/test.py)
assert_contains "$result" "joe" "Bash: -e joe uses joe"
assert_contains "$result" "-syntax" "Bash: -e joe includes -syntax"

# nano editor
result=$($EDITCMD -p -e nano fixtures/extensions/test.py)
assert_contains "$result" "nano" "Bash: -e nano uses nano"
assert_contains "$result" "--syntax=" "Bash: -e nano includes --syntax="

# vim editor
result=$($EDITCMD -p -e vim fixtures/extensions/test.py)
assert_contains "$result" "vim" "Bash: -e vim uses vim"
assert_contains "$result" "set filetype=" "Bash: -e vim includes set filetype="

# emacs editor
result=$($EDITCMD -p -e emacs fixtures/extensions/test.py)
assert_contains "$result" "emacs" "Bash: -e emacs uses emacs"

# vscode editor
result=$($EDITCMD -p -e vscode fixtures/extensions/test.py)
assert_contains "$result" "code" "Bash: -e vscode uses code"

# Invalid editor
$EDITCMD -e invalid fixtures/extensions/test.py 2>/dev/null && exit_code=$? || exit_code=$?
assert_exit_code 22 "$exit_code" "Bash: invalid editor exits 22"

# ========================================
# 6. SYNTAX DETECTION INTEGRATION
# ========================================

print_section "Syntax Detection Integration"

# Shell script
result=$($EDITCMD -p fixtures/extensions/test.sh)
assert_contains "$result" "test.sh" "Bash: detects .sh file"
assert_contains "$result" "sh" "Bash: .sh gets sh syntax"

# Python script
result=$($EDITCMD -p fixtures/extensions/test.py)
assert_contains "$result" "test.py" "Bash: detects .py file"
assert_contains "$result" "python" "Bash: .py gets python syntax"

# C source
result=$($EDITCMD -p -e vim fixtures/extensions/test.c)
assert_contains "$result" "test.c" "Bash: detects .c file"
assert_contains "$result" "c" "Bash: .c gets c syntax (vim)"

# C++ source
result=$($EDITCMD -p -e vim fixtures/extensions/test.cpp)
assert_contains "$result" "test.cpp" "Bash: detects .cpp file"
assert_contains "$result" "cpp" "Bash: .cpp gets cpp syntax (vim)"

# JavaScript
result=$($EDITCMD -p -e nano fixtures/extensions/test.js)
assert_contains "$result" "test.js" "Bash: detects .js file"
assert_contains "$result" "javascript" "Bash: .js gets javascript syntax (nano)"

# Markdown
result=$($EDITCMD -p -e vim fixtures/extensions/test.md)
assert_contains "$result" "test.md" "Bash: detects .md file"
assert_contains "$result" "markdown" "Bash: .md gets markdown syntax (vim)"

# Bash script with shebang
result=$($EDITCMD -p -e vim fixtures/edge_cases/has_ext.sh)
assert_contains "$result" "has_ext.sh" "Bash: detects bash shebang"
assert_contains "$result" "bash" "Bash: bash shebang → bash syntax (vim)"

# ========================================
# 7. ERROR HANDLING TESTS
# ========================================

print_section "Error Handling"

# No file specified
$EDITCMD 2>/dev/null && exit_code=$? || exit_code=$?
assert_exit_code 1 "$exit_code" "Bash: no file → exit 1"

# Binary file rejection
$EDITCMD fixtures/binary/elf_test 2>/dev/null && exit_code=$? || exit_code=$?
assert_exit_code 1 "$exit_code" "Bash: binary file → exit 1"

# Multiple filenames not supported
$EDITCMD fixtures/extensions/test.py fixtures/extensions/test.sh 2>/dev/null && exit_code=$? || exit_code=$?
assert_exit_code 1 "$exit_code" "Bash: multiple files → exit 1"

# Missing argument for -e
$EDITCMD -e 2>/dev/null && exit_code=$? || exit_code=$?
assert_exit_code 22 "$exit_code" "Bash: missing -e argument → exit 22"

# Missing argument for -l
$EDITCMD -l 2>/dev/null && exit_code=$? || exit_code=$?
assert_exit_code 22 "$exit_code" "Bash: missing -l argument → exit 22"

# Unknown option
$EDITCMD -x fixtures/extensions/test.py 2>/dev/null && exit_code=$? || exit_code=$?
assert_exit_code 22 "$exit_code" "Bash: unknown option → exit 22"

# Help exits successfully
$EDITCMD --help >/dev/null && exit_code=$? || exit_code=$?
assert_exit_code 0 "$exit_code" "Bash: --help → exit 0"

# ========================================
# 8. COMBINED OPTIONS TESTS
# ========================================

print_section "Combined Options"

# -e + -l combined
result=$($EDITCMD -p -e vim -l 50 fixtures/extensions/test.py)
assert_contains "$result" "vim" "Bash: -e vim -l 50 includes vim"
assert_contains "$result" "+50" "Bash: -e vim -l 50 includes +50"
assert_contains "$result" "test.py" "Bash: -e vim -l 50 includes filename"

# -e + +NUM combined
result=$($EDITCMD -p -e nano +25 fixtures/extensions/test.py)
assert_contains "$result" "nano" "Bash: -e nano +25 includes nano"
assert_contains "$result" "+25" "Bash: -e nano +25 includes +25"
assert_contains "$result" "test.py" "Bash: -e nano +25 includes filename"

# Short option aggregation -pe
result=$($EDITCMD -pe vim fixtures/extensions/test.py)
assert_contains "$result" "vim" "Bash: -pe vim aggregation works"
assert_contains "$result" "test.py" "Bash: -pe vim includes filename"

# Short option aggregation -pV
result=$($EDITCMD -pV 2>&1 | head -1)
assert_contains "$result" "editcmd" "Bash: -pV aggregation shows version"

# ========================================
# 9. FILENAME WITH SPACES TESTS
# ========================================

print_section "Filenames with Spaces"

# Filename with spaces
result=$($EDITCMD -p 'fixtures/edge_cases/file with spaces.sh')
# Check for partial filename (will match any escaping/quoting form)
assert_contains "$result" "spaces.sh" "Bash: handles spaces in filename"
assert_not_contains "$result" "error" "Bash: no error for spaces"

# ========================================
# 10. NON-EXISTENT FILE TESTS
# ========================================

print_section "Non-existent Files"

# Non-existent file with extension
result=$($EDITCMD -p nonexistent.py)
assert_contains "$result" "nonexistent.py" "Bash: handles non-existent .py"
assert_contains "$result" "python" "Bash: non-existent .py → python syntax"

# Non-existent file without extension
result=$($EDITCMD -p nonexistent_file)
assert_contains "$result" "nonexistent_file" "Bash: handles non-existent no-ext"

# ========================================
# 11. ERROR MESSAGE CONTENT
# ========================================

print_section "Error Message Content (die() format)"

# Missing -e argument
msg=$($EDITCMD -e 2>&1) || true
assert_contains "$msg" "editcmd: error:" "Missing -e stderr has 'editcmd: error:' prefix"
assert_contains "$msg" "requires an argument" "Missing -e stderr mentions argument required"

# Missing -l argument
msg=$($EDITCMD -l 2>&1) || true
assert_contains "$msg" "editcmd: error:" "Missing -l stderr has prefix"

# No file specified
msg=$($EDITCMD 2>&1) || true
assert_contains "$msg" "No file specified" "No file error message correct"

# Invalid editor
msg=$($EDITCMD -e invalid file.py 2>&1) || true
assert_contains "$msg" "Invalid editor" "Invalid editor error message"

# Multiple filenames
msg=$($EDITCMD file1.py file2.py 2>&1) || true
assert_contains "$msg" "Multiple filenames" "Multiple files error message"

# ========================================
# 12. DIRECTORY REJECTION
# ========================================

print_section "Directory Rejection"

$EDITCMD -p fixtures/edge_cases/test_directory 2>/dev/null && exit_code=$? || exit_code=$?
assert_exit_code 1 "$exit_code" "Bash: directory file → exit 1"

msg=$($EDITCMD fixtures/edge_cases/test_directory 2>&1) || true
assert_contains "$msg" "Cannot edit directory" "Directory rejection error message"

# ========================================
# 13. +NUM EDGE CASES
# ========================================

print_section "+NUM Edge Cases"

# +0 produces no line positioning
result=$($EDITCMD -p +0 fixtures/extensions/test.py)
assert_not_contains "$result" "+0" "Bash: +0 does not include +0"

# +1 is valid
result=$($EDITCMD -p +1 fixtures/extensions/test.py)
assert_contains "$result" "+1" "Bash: +1 includes +1"

# Large line number
result=$($EDITCMD -p +99999 fixtures/extensions/test.py)
assert_contains "$result" "+99999" "Bash: +99999 works"

# ========================================
# 14. ALL EDITORS WITH LINE NUMBERS
# ========================================

print_section "All Editors with Line Numbers (build_editor_command integration)"

# joe with line number
result=$($EDITCMD -p -e joe -l 10 fixtures/extensions/test.py)
assert_contains "$result" "joe" "Bash: joe command generated"
assert_contains "$result" "+10" "Bash: joe +10 line positioning"

# nano with line number
result=$($EDITCMD -p -e nano -l 10 fixtures/extensions/test.py)
assert_contains "$result" "nano" "Bash: nano command generated"
assert_contains "$result" "+10" "Bash: nano +10 line positioning"

# emacs with line number
result=$($EDITCMD -p -e emacs -l 10 fixtures/extensions/test.py)
assert_contains "$result" "emacs" "Bash: emacs command generated"
assert_contains "$result" "+10" "Bash: emacs +10 line positioning"

# vscode with line number
result=$($EDITCMD -p -e vscode -l 10 fixtures/extensions/test.py)
assert_contains "$result" "code" "Bash: vscode command generated"
assert_contains "$result" "L10" "Bash: vscode L10 line positioning"

# ========================================
# 15. END-OF-OPTIONS IN EDITCMD
# ========================================

print_section "End-of-Options in editcmd"

# editcmd has no -- handler; -- matches -* catch-all → exit 22
$EDITCMD -p -- fixtures/extensions/test.py 2>/dev/null && exit_code=$? || exit_code=$?
assert_exit_code 22 "$exit_code" "Bash: -- is unknown option in editcmd → exit 22"

# ========================================
# SUMMARY
# ========================================

print_summary
exit_code=$?

exit $exit_code

#fin
