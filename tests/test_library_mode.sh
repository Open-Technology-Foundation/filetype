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
# build_editor_command() Direct Tests
# ========================================

print_section "Library Mode: build_editor_command() Function"

# joe without line number
result=$(build_editor_command "joe" "python" "test.py" 0)
assert_contains "$result" "joe" "build_editor_command(joe, python) has joe"
assert_contains "$result" "-syntax python" "build_editor_command(joe, python) has syntax"

# joe with line number
result=$(build_editor_command "joe" "sh" "test.sh" 42)
assert_contains "$result" "+42" "build_editor_command(joe, sh, 42) has +42"

# vim
result=$(build_editor_command "vim" "python" "test.py" 0)
assert_contains "$result" "vim" "build_editor_command(vim, python) has vim"
assert_contains "$result" "set filetype=python" "build_editor_command(vim) has set filetype"

# nano
result=$(build_editor_command "nano" "python" "test.py" 10)
assert_contains "$result" "nano" "build_editor_command(nano, python) has nano"
assert_contains "$result" "--syntax=python" "build_editor_command(nano) has --syntax="
assert_contains "$result" "+10" "build_editor_command(nano, 10) has +10"

# emacs
result=$(build_editor_command "emacs" "python-mode" "test.py" 5)
assert_contains "$result" "emacs" "build_editor_command(emacs) has emacs"
assert_contains "$result" "+5" "build_editor_command(emacs, 5) has +5"

# vscode
result=$(build_editor_command "vscode" "python" "test.py" 0)
assert_contains "$result" "code" "build_editor_command(vscode) has code"

# Binary rejection
result=$(build_editor_command "vim" "binary" "file.o" 0 2>&1) && rc=$? || rc=$?
assert_exit_code 1 "$rc" "build_editor_command rejects binary"
assert_contains "$result" "Cannot edit binary" "build_editor_command binary error message"

# Directory rejection
result=$(build_editor_command "vim" "directory" "/tmp" 0 2>&1) && rc=$? || rc=$?
assert_exit_code 1 "$rc" "build_editor_command rejects directory"

# ========================================
# Directory Detection via filetype()
# ========================================

print_section "Library Mode: Directory and Special Cases"

result=$(filetype "fixtures/edge_cases/test_directory")
assert_equals "directory" "$result" "filetype(directory) → directory"

result=$(filetype ".")
assert_equals "directory" "$result" "filetype(.) → directory"

# ========================================
# filetype-lib.sh Backward Compatibility
# ========================================

print_section "Library Mode: filetype-lib.sh Backward Compatibility"

# Source filetype-lib.sh in a subshell to verify it works
result=$(
  source "../filetype-lib.sh"
  filetype "fixtures/extensions/test.py"
)
assert_equals "python" "$result" "filetype-lib.sh: filetype() works"

result=$(
  source "../filetype-lib.sh"
  echo "$FILETYPE_VERSION"
)
assert_contains "$result" "1.0.0" "filetype-lib.sh: FILETYPE_VERSION exported"

result=$(
  source "../filetype-lib.sh"
  EDITOR_TYPE=nano
  export EDITOR_TYPE
  map_to_editor "js" "test.js"
)
assert_equals "javascript" "$result" "filetype-lib.sh: map_to_editor() works"

result=$(
  source "../filetype-lib.sh"
  detect_editor_from_env
)
assert_equals "joe" "$result" "filetype-lib.sh: detect_editor_from_env() works"

# ========================================
# detect_editor_from_env() Extended
# ========================================

print_section "Library Mode: detect_editor_from_env() Extended"

# Full path editors
EDITOR='/usr/bin/vim'
export EDITOR
result=$(detect_editor_from_env)
assert_equals "vim" "$result" "detect_editor_from_env(/usr/bin/vim) → vim"

# jstar variant
EDITOR='jstar'
export EDITOR
result=$(detect_editor_from_env)
assert_equals "joe" "$result" "detect_editor_from_env(jstar) → joe"

# emacs-nox variant
EDITOR='emacs-nox'
export EDITOR
result=$(detect_editor_from_env)
assert_equals "emacs" "$result" "detect_editor_from_env(emacs-nox) → emacs"

# neovim variant
EDITOR='neovim'
export EDITOR
result=$(detect_editor_from_env)
assert_equals "vim" "$result" "detect_editor_from_env(neovim) → vim"

# ========================================
# map_to_editor() Extended
# ========================================

print_section "Library Mode: map_to_editor() Extended"

# emacs: text passthrough (no -mode suffix)
EDITOR_TYPE='emacs'
export EDITOR_TYPE
result=$(map_to_editor "text" "test.txt")
assert_equals "text" "$result" "map_to_editor(text, emacs) → text (no -mode)"

# emacs: directory passthrough
result=$(map_to_editor "directory" "/tmp")
assert_equals "directory" "$result" "map_to_editor(directory, emacs) → directory (no -mode)"

# nano: diff → patch
EDITOR_TYPE='nano'
export EDITOR_TYPE
result=$(map_to_editor "diff" "test.diff")
assert_equals "patch" "$result" "map_to_editor(diff, nano) → patch"

# vim: c for .h file (not cpp)
EDITOR_TYPE='vim'
export EDITOR_TYPE
result=$(map_to_editor "c" "test.h")
assert_equals "c" "$result" "map_to_editor(c, vim, test.h) → c (not cpp)"

# vim: c for .hpp → cpp (hpp is in vim cpp list)
result=$(map_to_editor "c" "test.hpp")
assert_equals "cpp" "$result" "map_to_editor(c, vim, test.hpp) → cpp"

# vscode: c for .hpp → cpp
EDITOR_TYPE='vscode'
export EDITOR_TYPE
result=$(map_to_editor "c" "test.hpp")
assert_equals "cpp" "$result" "map_to_editor(c, vscode, test.hpp) → cpp"

# ========================================
# SUMMARY
# ========================================

print_summary
exit_code=$?

exit $exit_code

#fin
