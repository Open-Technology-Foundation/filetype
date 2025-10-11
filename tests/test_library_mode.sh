#!/usr/bin/env bash
# test_library_mode.sh - Test bash filetype when sourced as library
# Tests that functions work correctly when script is sourced rather than executed

set -euo pipefail

cd "$(dirname "$0")"
source ./common.sh

FILETYPE_BASH="../filetype"

echo "======================================================================"
echo "  LIBRARY MODE TEST: Bash sourcing"
echo "======================================================================"

# Source the filetype script to load its functions
source "$FILETYPE_BASH"

print_section "Library Mode: Direct Function Calls"

# Test filetype() function directly
result=$(filetype "fixtures/extensions/test.py")
assert_equals "python" "$result" "filetype('test.py') → python"

result=$(filetype "fixtures/extensions/test.sh")
assert_equals "sh" "$result" "filetype('test.sh') → sh"

result=$(filetype "fixtures/extensions/test.cpp")
assert_equals "c" "$result" "filetype('test.cpp') → c"

result=$(filetype "fixtures/extensions/test.js")
assert_equals "js" "$result" "filetype('test.js') → js"

result=$(filetype "fixtures/extensions/test.md")
assert_equals "md" "$result" "filetype('test.md') → md"

result=$(filetype "fixtures/shebangs/bash1")
assert_equals "sh" "$result" "filetype(bash shebang) → sh"

result=$(filetype "nonexistent.py")
assert_equals "python" "$result" "filetype('nonexistent.py') → python"

result=$(filetype "fixtures/binary/elf_test")
assert_equals "binary" "$result" "filetype(binary) → binary"

print_section "Library Mode: map_to_editor() Function"

# Test map_to_editor() function directly
EDITOR_TYPE='joe'
export EDITOR_TYPE

result=$(filetype "fixtures/extensions/test.js")
result=$(map_to_editor "$result" "fixtures/extensions/test.js")
assert_equals "js" "$result" "map_to_editor(js, joe) → js"

EDITOR_TYPE='nano'
export EDITOR_TYPE

result=$(filetype "fixtures/extensions/test.js")
result=$(map_to_editor "$result" "fixtures/extensions/test.js")
assert_equals "javascript" "$result" "map_to_editor(js, nano) → javascript"

EDITOR_TYPE='vim'
export EDITOR_TYPE

result=$(filetype "fixtures/extensions/test.js")
result=$(map_to_editor "$result" "fixtures/extensions/test.js")
assert_equals "javascript" "$result" "map_to_editor(js, vim) → javascript"

result=$(filetype "fixtures/extensions/test.cpp")
result=$(map_to_editor "$result" "fixtures/extensions/test.cpp")
assert_equals "cpp" "$result" "map_to_editor(c, vim, test.cpp) → cpp"

EDITOR_TYPE='emacs'
export EDITOR_TYPE

result=$(filetype "fixtures/extensions/test.py")
result=$(map_to_editor "$result" "fixtures/extensions/test.py")
assert_equals "python-mode" "$result" "map_to_editor(python, emacs) → python-mode"

result=$(filetype "fixtures/extensions/test.xml")
result=$(map_to_editor "$result" "fixtures/extensions/test.xml")
assert_equals "nxml-mode" "$result" "map_to_editor(xml, emacs) → nxml-mode"

EDITOR_TYPE='vscode'
export EDITOR_TYPE

result=$(filetype "fixtures/extensions/test.sh")
result=$(map_to_editor "$result" "fixtures/extensions/test.sh")
assert_equals "shellscript" "$result" "map_to_editor(sh, vscode) → shellscript"

print_section "Library Mode: detect_editor_from_env() Function"

# Test detect_editor_from_env() function
unset EDITOR || true
result=$(detect_editor_from_env)
assert_equals "joe" "$result" "detect_editor_from_env(no EDITOR) → joe"

EDITOR='vim'
export EDITOR
result=$(detect_editor_from_env)
assert_equals "vim" "$result" "detect_editor_from_env(EDITOR=vim) → vim"

EDITOR='nvim'
export EDITOR
result=$(detect_editor_from_env)
assert_equals "vim" "$result" "detect_editor_from_env(EDITOR=nvim) → vim"

EDITOR='emacs'
export EDITOR
result=$(detect_editor_from_env)
assert_equals "emacs" "$result" "detect_editor_from_env(EDITOR=emacs) → emacs"

EDITOR='code'
export EDITOR
result=$(detect_editor_from_env)
assert_equals "vscode" "$result" "detect_editor_from_env(EDITOR=code) → vscode"

EDITOR='unknown'
export EDITOR
result=$(detect_editor_from_env)
assert_equals "joe" "$result" "detect_editor_from_env(EDITOR=unknown) → joe (fallback)"

# ========================================
# SUMMARY
# ========================================

print_summary
exit_code=$?

exit $exit_code

#fin
