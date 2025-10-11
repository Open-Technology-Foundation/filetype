#!/usr/bin/env bash
# test_parity.sh - Verify bash and Python versions produce identical output
# This ensures both implementations are in sync

set -euo pipefail

cd "$(dirname "$0")"
source ./common.sh

FILETYPE_BASH="../filetype"
FILETYPE_PY="../filetype.py"

echo "======================================================================"
echo "  PARITY TEST: Bash vs Python Implementation"
echo "======================================================================"

# Test function that compares bash and Python output
test_parity() {
  local description="$1"
  shift
  local args=("$@")

  local bash_output
  local python_output
  local bash_exit=0
  local python_exit=0

  # Run bash version
  bash_output=$("$FILETYPE_BASH" "${args[@]}" 2>&1) || bash_exit=$?

  # Run Python version
  python_output=$(python3 "$FILETYPE_PY" "${args[@]}" 2>&1) || python_exit=$?

  # Compare exit codes
  if [[ $bash_exit -ne $python_exit ]]; then
    echo -e "${RED}FAIL${NC}: $description [exit codes differ]"
    echo "  Bash exit:   $bash_exit"
    echo "  Python exit: $python_exit"
    ((FAIL_COUNT+=1))
    return 1
  fi

  # Compare outputs
  if [[ "$bash_output" == "$python_output" ]]; then
    echo -e "${GREEN}PASS${NC}: $description"
    ((PASS_COUNT+=1))
    return 0
  else
    echo -e "${RED}FAIL${NC}: $description [outputs differ]"
    echo "  Bash:   '$bash_output'"
    echo "  Python: '$python_output'"
    ((FAIL_COUNT+=1))
    return 1
  fi
}

# Test function for error/help cases - only checks exit codes, not output
test_parity_exitcode_only() {
  local description="$1"
  shift
  local args=("$@")

  local bash_exit=0
  local python_exit=0

  # Run bash version
  "$FILETYPE_BASH" "${args[@]}" >/dev/null 2>&1 || bash_exit=$?

  # Run Python version
  python3 "$FILETYPE_PY" "${args[@]}" >/dev/null 2>&1 || python_exit=$?

  # Compare exit codes only
  if [[ $bash_exit -eq $python_exit ]]; then
    echo -e "${GREEN}PASS${NC}: $description [exit code: $bash_exit]"
    ((PASS_COUNT+=1))
    return 0
  else
    echo -e "${RED}FAIL${NC}: $description [exit codes differ]"
    echo "  Bash exit:   $bash_exit"
    echo "  Python exit: $python_exit"
    ((FAIL_COUNT+=1))
    return 1
  fi
}

# ========================================
# EXTENSION PARITY TESTS
# ========================================

print_section "Extension Parity Tests"

test_parity "test.sh" "fixtures/extensions/test.sh"
test_parity "test.py" "fixtures/extensions/test.py"
test_parity "test.cpp" "fixtures/extensions/test.cpp"
test_parity "test.js" "fixtures/extensions/test.js"
test_parity "test.md" "fixtures/extensions/test.md"
test_parity "test.xml" "fixtures/extensions/test.xml"
test_parity "test.diff" "fixtures/extensions/test.diff"
test_parity "test.java" "fixtures/extensions/test.java"
test_parity "test.rs" "fixtures/extensions/test.rs"
test_parity "test.yaml" "fixtures/extensions/test.yaml"
test_parity "test.sql" "fixtures/extensions/test.sql"
test_parity "test.rb" "fixtures/extensions/test.rb"
test_parity "test.go" "fixtures/extensions/test.go"
test_parity "test.swift" "fixtures/extensions/test.swift"
test_parity "test.scala" "fixtures/extensions/test.scala"

# ========================================
# SHEBANG PARITY TESTS
# ========================================

print_section "Shebang Parity Tests"

test_parity "bash shebang" "fixtures/shebangs/bash1"
test_parity "sh shebang" "fixtures/shebangs/sh1"
test_parity "python shebang" "fixtures/shebangs/python1"
test_parity "perl shebang" "fixtures/shebangs/perl1"
test_parity "ruby shebang" "fixtures/shebangs/ruby1"
test_parity "php shebang" "fixtures/shebangs/php1"
test_parity "node shebang" "fixtures/shebangs/node1"
test_parity "awk shebang" "fixtures/shebangs/awk1"

# ========================================
# EDITOR MAPPING PARITY TESTS
# ========================================

print_section "Editor Mapping Parity: joe"

test_parity "joe: test.sh" "-e" "joe" "fixtures/extensions/test.sh"
test_parity "joe: test.py" "-e" "joe" "fixtures/extensions/test.py"
test_parity "joe: test.cpp" "-e" "joe" "fixtures/extensions/test.cpp"
test_parity "joe: test.js" "-e" "joe" "fixtures/extensions/test.js"

print_section "Editor Mapping Parity: nano"

test_parity "nano: test.sh" "-e" "nano" "fixtures/extensions/test.sh"
test_parity "nano: test.py" "-e" "nano" "fixtures/extensions/test.py"
test_parity "nano: test.js (→javascript)" "-e" "nano" "fixtures/extensions/test.js"
test_parity "nano: test.md (→markdown)" "-e" "nano" "fixtures/extensions/test.md"
test_parity "nano: test.diff (→patch)" "-e" "nano" "fixtures/extensions/test.diff"

print_section "Editor Mapping Parity: vim"

test_parity "vim: test.sh" "-e" "vim" "fixtures/extensions/test.sh"
test_parity "vim: has_ext.sh (bash shebang)" "-e" "vim" "fixtures/edge_cases/has_ext.sh"
test_parity "vim: test.py" "-e" "vim" "fixtures/extensions/test.py"
test_parity "vim: test.c" "-e" "vim" "fixtures/extensions/test.c"
test_parity "vim: test.cpp (→cpp)" "-e" "vim" "fixtures/extensions/test.cpp"
test_parity "vim: test.cc (→cpp)" "-e" "vim" "fixtures/extensions/test.cc"
test_parity "vim: test.js (→javascript)" "-e" "vim" "fixtures/extensions/test.js"
test_parity "vim: test.md (→markdown)" "-e" "vim" "fixtures/extensions/test.md"

print_section "Editor Mapping Parity: emacs"

test_parity "emacs: test.sh (→sh-mode)" "-e" "emacs" "fixtures/extensions/test.sh"
test_parity "emacs: test.py (→python-mode)" "-e" "emacs" "fixtures/extensions/test.py"
test_parity "emacs: test.c (→c-mode)" "-e" "emacs" "fixtures/extensions/test.c"
test_parity "emacs: test.cpp (→c++-mode)" "-e" "emacs" "fixtures/extensions/test.cpp"
test_parity "emacs: test.cc (→c++-mode)" "-e" "emacs" "fixtures/extensions/test.cc"
test_parity "emacs: test.js (→javascript-mode)" "-e" "emacs" "fixtures/extensions/test.js"
test_parity "emacs: test.md (→markdown-mode)" "-e" "emacs" "fixtures/extensions/test.md"
test_parity "emacs: test.xml (→nxml-mode)" "-e" "emacs" "fixtures/extensions/test.xml"
test_parity "emacs: test.diff (→diff-mode)" "-e" "emacs" "fixtures/extensions/test.diff"
test_parity "emacs: test.txt (→text, no -mode)" "-e" "emacs" "fixtures/extensions/test.txt"
test_parity "emacs: binary (→binary, no -mode)" "-e" "emacs" "fixtures/binary/elf_test"

print_section "Editor Mapping Parity: vscode"

test_parity "vscode: test.sh (→shellscript)" "-e" "vscode" "fixtures/extensions/test.sh"
test_parity "vscode: test.csh (→shellscript)" "-e" "vscode" "fixtures/extensions/test.csh"
test_parity "vscode: test.py" "-e" "vscode" "fixtures/extensions/test.py"
test_parity "vscode: test.c" "-e" "vscode" "fixtures/extensions/test.c"
test_parity "vscode: test.cpp (→cpp)" "-e" "vscode" "fixtures/extensions/test.cpp"
test_parity "vscode: test.js (→javascript)" "-e" "vscode" "fixtures/extensions/test.js"
test_parity "vscode: test.md (→markdown)" "-e" "vscode" "fixtures/extensions/test.md"

# ========================================
# EDGE CASE PARITY TESTS
# ========================================

print_section "Edge Case Parity Tests"

test_parity "dotfile: .bashrc" "fixtures/edge_cases/.bashrc"
test_parity "dotfile: .vimrc" "fixtures/edge_cases/.vimrc"
test_parity "dotfile: .gitignore" "fixtures/edge_cases/.gitignore"
test_parity "dotfile with ext: .bash_history.txt" "fixtures/edge_cases/.bash_history.txt"
test_parity "multiple ext: archive.tar.gz" "fixtures/edge_cases/archive.tar.gz"
test_parity "multiple ext: script.min.js" "fixtures/edge_cases/script.min.js"
test_parity "nonexistent: nonexistent.py" "nonexistent.py"
test_parity "nonexistent: nonexistent.txt" "nonexistent.txt"
test_parity "nonexistent: nonexistent" "nonexistent"
test_parity "empty file: empty.py" "fixtures/edge_cases/empty.py"
test_parity "empty file: empty_no_ext" "fixtures/edge_cases/empty_no_ext"
test_parity "file with spaces.sh" "fixtures/edge_cases/file with spaces.sh"
test_parity "my file.py" "fixtures/edge_cases/my file.py"
test_parity "binary: elf_test" "fixtures/binary/elf_test"

# ========================================
# BATCH MODE PARITY TESTS
# ========================================

print_section "Batch Mode Parity Tests"

test_parity "batch: 2 files" "fixtures/extensions/test.py" "fixtures/extensions/test.js"
test_parity "batch: 3 files" "fixtures/extensions/test.py" "fixtures/extensions/test.js" "fixtures/extensions/test.sh"

# ========================================
# ERROR HANDLING PARITY TESTS
# ========================================

print_section "Error Handling Parity Tests (exit codes only)"

# These should all fail with same exit code (output messages may differ)
test_parity_exitcode_only "no files"
test_parity_exitcode_only "invalid -e" "-e" "invalid" "fixtures/extensions/test.py"
test_parity_exitcode_only "unknown option" "-x" "fixtures/extensions/test.py"

# Help should succeed with same exit code (output format may differ)
test_parity_exitcode_only "help: -h" "-h"
test_parity_exitcode_only "help: --help" "--help"

# ========================================
# SUMMARY
# ========================================

print_summary
exit_code=$?

exit $exit_code

#fin
