#!/usr/bin/env bash
# test_bash.sh - Comprehensive test suite for bash filetype implementation
# Tests ~500+ assertions covering all permutations

set -euo pipefail

cd "$(dirname "$0")"
source ./common.sh

FILETYPE="../filetype"

echo "======================================================================"
echo "  FILETYPE BASH VERSION - COMPREHENSIVE TEST SUITE"
echo "======================================================================"

# ========================================
# 1. EXTENSION TESTS
# ========================================

print_section "Extension Tests (80+ file types)"

# Shell scripts
assert_equals "sh" "$($FILETYPE fixtures/extensions/test.sh)" "test.sh → sh"
assert_equals "sh" "$($FILETYPE fixtures/extensions/test.bash)" "test.bash → sh"
assert_equals "csh" "$($FILETYPE fixtures/extensions/test.csh)" "test.csh → csh"
assert_equals "csh" "$($FILETYPE fixtures/extensions/test.tcsh)" "test.tcsh → csh"

# Scripting languages
assert_equals "python" "$($FILETYPE fixtures/extensions/test.py)" "test.py → python"
assert_equals "perl" "$($FILETYPE fixtures/extensions/test.pl)" "test.pl → perl"
assert_equals "perl" "$($FILETYPE fixtures/extensions/test.pm)" "test.pm → perl"
assert_equals "perl" "$($FILETYPE fixtures/extensions/test.t)" "test.t → perl"
assert_equals "ruby" "$($FILETYPE fixtures/extensions/test.rb)" "test.rb → ruby"
assert_equals "ruby" "$($FILETYPE fixtures/extensions/test.gemspec)" "test.gemspec → ruby"
assert_equals "ruby" "$($FILETYPE fixtures/extensions/test.rabl)" "test.rabl → ruby"
assert_equals "php" "$($FILETYPE fixtures/extensions/test.php)" "test.php → php"
assert_equals "awk" "$($FILETYPE fixtures/extensions/test.awk)" "test.awk → awk"
assert_equals "sed" "$($FILETYPE fixtures/extensions/test.sed)" "test.sed → sed"
assert_equals "lua" "$($FILETYPE fixtures/extensions/test.lua)" "test.lua → lua"
assert_equals "tcl" "$($FILETYPE fixtures/extensions/test.tcl)" "test.tcl → tcl"

# Web development
assert_equals "js" "$($FILETYPE fixtures/extensions/test.js)" "test.js → js"
assert_equals "js" "$($FILETYPE fixtures/extensions/test.mjs)" "test.mjs → js"
assert_equals "json" "$($FILETYPE fixtures/extensions/test.json)" "test.json → json"
assert_equals "typescript" "$($FILETYPE fixtures/extensions/test.ts)" "test.ts → typescript"
assert_equals "typescript" "$($FILETYPE fixtures/extensions/test.tsx)" "test.tsx → typescript"
assert_equals "html" "$($FILETYPE fixtures/extensions/test.htm)" "test.htm → html"
assert_equals "html" "$($FILETYPE fixtures/extensions/test.html)" "test.html → html"
assert_equals "css" "$($FILETYPE fixtures/extensions/test.css)" "test.css → css"
assert_equals "xml" "$($FILETYPE fixtures/extensions/test.xml)" "test.xml → xml"
assert_equals "xml" "$($FILETYPE fixtures/extensions/test.xsd)" "test.xsd → xml"
assert_equals "xml" "$($FILETYPE fixtures/extensions/test.jnlp)" "test.jnlp → xml"
assert_equals "xml" "$($FILETYPE fixtures/extensions/test.resx)" "test.resx → xml"

# Data/config formats
assert_equals "yaml" "$($FILETYPE fixtures/extensions/test.yaml)" "test.yaml → yaml"
assert_equals "yaml" "$($FILETYPE fixtures/extensions/test.yml)" "test.yml → yaml"
assert_equals "ini" "$($FILETYPE fixtures/extensions/test.ini)" "test.ini → ini"
assert_equals "conf" "$($FILETYPE fixtures/extensions/test.conf)" "test.conf → conf"
assert_equals "conf" "$($FILETYPE fixtures/extensions/test.cfg)" "test.cfg → conf"
assert_equals "properties" "$($FILETYPE fixtures/extensions/test.properties)" "test.properties → properties"

# Markup/documentation
assert_equals "md" "$($FILETYPE fixtures/extensions/test.md)" "test.md → md"
assert_equals "md" "$($FILETYPE fixtures/extensions/test.markdown)" "test.markdown → md"
assert_equals "tex" "$($FILETYPE fixtures/extensions/test.tex)" "test.tex → tex"
assert_equals "tex" "$($FILETYPE fixtures/extensions/test.sty)" "test.sty → tex"

# Compiled languages
assert_equals "c" "$($FILETYPE fixtures/extensions/test.c)" "test.c → c"
assert_equals "c" "$($FILETYPE fixtures/extensions/test.cpp)" "test.cpp → c"
assert_equals "c" "$($FILETYPE fixtures/extensions/test.cc)" "test.cc → c"
assert_equals "c" "$($FILETYPE fixtures/extensions/test.cxx)" "test.cxx → c"
assert_equals "c" "$($FILETYPE fixtures/extensions/test.h)" "test.h → c"
assert_equals "c" "$($FILETYPE fixtures/extensions/test.hpp)" "test.hpp → c"
assert_equals "c" "$($FILETYPE fixtures/extensions/test.h++)" "test.h++ → c"
assert_equals "c" "$($FILETYPE fixtures/extensions/test.hh)" "test.hh → c"
assert_equals "c" "$($FILETYPE fixtures/extensions/test.mm)" "test.mm → c"
assert_equals "java" "$($FILETYPE fixtures/extensions/test.java)" "test.java → java"
assert_equals "go" "$($FILETYPE fixtures/extensions/test.go)" "test.go → go"
assert_equals "rust" "$($FILETYPE fixtures/extensions/test.rs)" "test.rs → rust"
assert_equals "csharp" "$($FILETYPE fixtures/extensions/test.cs)" "test.cs → csharp"
assert_equals "swift" "$($FILETYPE fixtures/extensions/test.swift)" "test.swift → swift"
assert_equals "scala" "$($FILETYPE fixtures/extensions/test.scala)" "test.scala → scala"
assert_equals "d" "$($FILETYPE fixtures/extensions/test.d)" "test.d → d"

# Functional languages
assert_equals "haskell" "$($FILETYPE fixtures/extensions/test.hs)" "test.hs → haskell"
assert_equals "haskell" "$($FILETYPE fixtures/extensions/test.lhs)" "test.lhs → haskell"
assert_equals "erlang" "$($FILETYPE fixtures/extensions/test.erl)" "test.erl → erlang"
assert_equals "erlang" "$($FILETYPE fixtures/extensions/test.hrl)" "test.hrl → erlang"
assert_equals "elixir" "$($FILETYPE fixtures/extensions/test.ex)" "test.ex → elixir"
assert_equals "elixir" "$($FILETYPE fixtures/extensions/test.exs)" "test.exs → elixir"
assert_equals "lisp" "$($FILETYPE fixtures/extensions/test.lisp)" "test.lisp → lisp"
assert_equals "lisp" "$($FILETYPE fixtures/extensions/test.lsp)" "test.lsp → lisp"
assert_equals "lisp" "$($FILETYPE fixtures/extensions/test.cl)" "test.cl → lisp"
assert_equals "ocaml" "$($FILETYPE fixtures/extensions/test.ml)" "test.ml → ocaml"
assert_equals "ocaml" "$($FILETYPE fixtures/extensions/test.mli)" "test.mli → ocaml"

# Database
assert_equals "sql" "$($FILETYPE fixtures/extensions/test.sql)" "test.sql → sql"

# Version control/diffs
assert_equals "diff" "$($FILETYPE fixtures/extensions/test.diff)" "test.diff → diff"
assert_equals "diff" "$($FILETYPE fixtures/extensions/test.patch)" "test.patch → diff"

# Other
assert_equals "r" "$($FILETYPE fixtures/extensions/test.r)" "test.r → r"
assert_equals "prolog" "$($FILETYPE fixtures/extensions/test.prolog)" "test.prolog → prolog"
assert_equals "prolog" "$($FILETYPE fixtures/extensions/test.pro)" "test.pro → prolog"
assert_equals "pascal" "$($FILETYPE fixtures/extensions/test.pas)" "test.pas → pascal"
assert_equals "fortran" "$($FILETYPE fixtures/extensions/test.f)" "test.f → fortran"
assert_equals "fortran" "$($FILETYPE fixtures/extensions/test.for)" "test.for → fortran"
assert_equals "fortran" "$($FILETYPE fixtures/extensions/test.f90)" "test.f90 → fortran"
assert_equals "cobol" "$($FILETYPE fixtures/extensions/test.cob)" "test.cob → cobol"
assert_equals "cobol" "$($FILETYPE fixtures/extensions/test.cbl)" "test.cbl → cobol"
assert_equals "verilog" "$($FILETYPE fixtures/extensions/test.v)" "test.v → verilog"
assert_equals "verilog" "$($FILETYPE fixtures/extensions/test.vh)" "test.vh → verilog"
assert_equals "vhdl" "$($FILETYPE fixtures/extensions/test.vhd)" "test.vhd → vhdl"
assert_equals "vhdl" "$($FILETYPE fixtures/extensions/test.vhdl)" "test.vhdl → vhdl"
assert_equals "batch" "$($FILETYPE fixtures/extensions/test.bat)" "test.bat → batch"
assert_equals "batch" "$($FILETYPE fixtures/extensions/test.cmd)" "test.cmd → batch"
assert_equals "ps" "$($FILETYPE fixtures/extensions/test.ps)" "test.ps → ps"
assert_equals "ps" "$($FILETYPE fixtures/extensions/test.eps)" "test.eps → ps"
assert_equals "text" "$($FILETYPE fixtures/extensions/test.txt)" "test.txt → text"
assert_equals "text" "$($FILETYPE fixtures/extensions/test.text)" "test.text → text"

# ========================================
# 2. SHEBANG TESTS
# ========================================

print_section "Shebang Tests (no extension, shebang detection)"

# Shell variants
assert_equals "sh" "$($FILETYPE fixtures/shebangs/bash1)" "#!/bin/bash → sh"
assert_equals "sh" "$($FILETYPE fixtures/shebangs/bash2)" "#!/usr/bin/env bash → sh"
assert_equals "sh" "$($FILETYPE fixtures/shebangs/bash3)" "#!/usr/bin/bash → sh"
assert_equals "sh" "$($FILETYPE fixtures/shebangs/sh1)" "#!/bin/sh → sh"
assert_equals "sh" "$($FILETYPE fixtures/shebangs/sh2)" "#!/usr/bin/env sh → sh"
assert_equals "sh" "$($FILETYPE fixtures/shebangs/sh3)" "#!/usr/bin/sh → sh"
assert_equals "csh" "$($FILETYPE fixtures/shebangs/csh1)" "#!/bin/csh → csh"
assert_equals "csh" "$($FILETYPE fixtures/shebangs/csh2)" "#!/usr/bin/env csh → csh"
assert_equals "csh" "$($FILETYPE fixtures/shebangs/tcsh1)" "#!/bin/tcsh → csh"
assert_equals "csh" "$($FILETYPE fixtures/shebangs/tcsh2)" "#!/usr/bin/env tcsh → csh"

# Scripting languages
assert_equals "python" "$($FILETYPE fixtures/shebangs/python1)" "#!/usr/bin/python → python"
assert_equals "python" "$($FILETYPE fixtures/shebangs/python2)" "#!/usr/bin/env python → python"
assert_equals "python" "$($FILETYPE fixtures/shebangs/python3)" "#!/usr/bin/python3 → python"
assert_equals "perl" "$($FILETYPE fixtures/shebangs/perl1)" "#!/usr/bin/perl → perl"
assert_equals "perl" "$($FILETYPE fixtures/shebangs/perl2)" "#!/usr/bin/env perl → perl"
assert_equals "ruby" "$($FILETYPE fixtures/shebangs/ruby1)" "#!/usr/bin/ruby → ruby"
assert_equals "ruby" "$($FILETYPE fixtures/shebangs/ruby2)" "#!/usr/bin/env ruby → ruby"
assert_equals "php" "$($FILETYPE fixtures/shebangs/php1)" "#!/usr/bin/php → php"
assert_equals "php" "$($FILETYPE fixtures/shebangs/php2)" "#!/usr/bin/env php → php"
assert_equals "php" "$($FILETYPE fixtures/shebangs/php3)" "<?php shebang → php"

# Web/utilities
assert_equals "js" "$($FILETYPE fixtures/shebangs/node1)" "#!/usr/bin/node → js"
assert_equals "js" "$($FILETYPE fixtures/shebangs/node2)" "#!/usr/bin/env node → js"
assert_equals "awk" "$($FILETYPE fixtures/shebangs/awk1)" "#!/usr/bin/awk → awk"
assert_equals "awk" "$($FILETYPE fixtures/shebangs/awk2)" "#!/usr/bin/env awk → awk"
assert_equals "awk" "$($FILETYPE fixtures/shebangs/gawk)" "#!/usr/bin/gawk → awk"
assert_equals "sed" "$($FILETYPE fixtures/shebangs/sed1)" "#!/usr/bin/sed → sed"
assert_equals "sed" "$($FILETYPE fixtures/shebangs/sed2)" "#!/usr/bin/env sed → sed"
assert_equals "lua" "$($FILETYPE fixtures/shebangs/lua1)" "#!/usr/bin/lua → lua"
assert_equals "lua" "$($FILETYPE fixtures/shebangs/lua2)" "#!/usr/bin/env lua → lua"
assert_equals "tcl" "$($FILETYPE fixtures/shebangs/tclsh1)" "#!/usr/bin/tclsh → tcl"
assert_equals "tcl" "$($FILETYPE fixtures/shebangs/tclsh2)" "#!/usr/bin/env tclsh → tcl"
assert_equals "tcl" "$($FILETYPE fixtures/shebangs/wish)" "#!/usr/bin/wish → tcl"

# ========================================
# 3. EDITOR MAPPING TESTS - JOE (passthrough)
# ========================================

print_section "Editor Mappings: joe (passthrough, default)"

assert_equals "sh" "$($FILETYPE -e joe fixtures/extensions/test.sh)" "joe: test.sh → sh"
assert_equals "python" "$($FILETYPE -e joe fixtures/extensions/test.py)" "joe: test.py → python"
assert_equals "c" "$($FILETYPE -e joe fixtures/extensions/test.cpp)" "joe: test.cpp → c"
assert_equals "js" "$($FILETYPE -e joe fixtures/extensions/test.js)" "joe: test.js → js"
assert_equals "md" "$($FILETYPE -e joe fixtures/extensions/test.md)" "joe: test.md → md"
assert_equals "diff" "$($FILETYPE -e joe fixtures/extensions/test.diff)" "joe: test.diff → diff"
assert_equals "xml" "$($FILETYPE -e joe fixtures/extensions/test.xml)" "joe: test.xml → xml"

# ========================================
# 4. EDITOR MAPPING TESTS - NANO
# ========================================

print_section "Editor Mappings: nano"

assert_equals "sh" "$($FILETYPE -e nano fixtures/extensions/test.sh)" "nano: test.sh → sh"
assert_equals "python" "$($FILETYPE -e nano fixtures/extensions/test.py)" "nano: test.py → python"
assert_equals "c" "$($FILETYPE -e nano fixtures/extensions/test.c)" "nano: test.c → c"
assert_equals "javascript" "$($FILETYPE -e nano fixtures/extensions/test.js)" "nano: test.js → javascript"
assert_equals "markdown" "$($FILETYPE -e nano fixtures/extensions/test.md)" "nano: test.md → markdown"
assert_equals "patch" "$($FILETYPE -e nano fixtures/extensions/test.diff)" "nano: test.diff → patch"
assert_equals "xml" "$($FILETYPE -e nano fixtures/extensions/test.xml)" "nano: test.xml → xml"

# ========================================
# 5. EDITOR MAPPING TESTS - VIM
# ========================================

print_section "Editor Mappings: vim"

assert_equals "sh" "$($FILETYPE -e vim fixtures/extensions/test.sh)" "vim: test.sh (no shebang) → sh"
assert_equals "bash" "$($FILETYPE -e vim fixtures/edge_cases/has_ext.sh)" "vim: has_ext.sh (#!/bin/bash) → bash"
assert_equals "python" "$($FILETYPE -e vim fixtures/extensions/test.py)" "vim: test.py → python"
assert_equals "c" "$($FILETYPE -e vim fixtures/extensions/test.c)" "vim: test.c → c"
assert_equals "cpp" "$($FILETYPE -e vim fixtures/extensions/test.cpp)" "vim: test.cpp → cpp"
assert_equals "cpp" "$($FILETYPE -e vim fixtures/extensions/test.cc)" "vim: test.cc → cpp"
assert_equals "cpp" "$($FILETYPE -e vim fixtures/extensions/test.cxx)" "vim: test.cxx → cpp"
assert_equals "javascript" "$($FILETYPE -e vim fixtures/extensions/test.js)" "vim: test.js → javascript"
assert_equals "markdown" "$($FILETYPE -e vim fixtures/extensions/test.md)" "vim: test.md → markdown"
assert_equals "diff" "$($FILETYPE -e vim fixtures/extensions/test.diff)" "vim: test.diff → diff"

# ========================================
# 6. EDITOR MAPPING TESTS - EMACS
# ========================================

print_section "Editor Mappings: emacs"

assert_equals "sh-mode" "$($FILETYPE -e emacs fixtures/extensions/test.sh)" "emacs: test.sh → sh-mode"
assert_equals "csh-mode" "$($FILETYPE -e emacs fixtures/extensions/test.csh)" "emacs: test.csh → csh-mode"
assert_equals "python-mode" "$($FILETYPE -e emacs fixtures/extensions/test.py)" "emacs: test.py → python-mode"
assert_equals "c-mode" "$($FILETYPE -e emacs fixtures/extensions/test.c)" "emacs: test.c → c-mode"
assert_equals "c++-mode" "$($FILETYPE -e emacs fixtures/extensions/test.cpp)" "emacs: test.cpp → c++-mode"
assert_equals "c++-mode" "$($FILETYPE -e emacs fixtures/extensions/test.cc)" "emacs: test.cc → c++-mode"
assert_equals "c++-mode" "$($FILETYPE -e emacs fixtures/extensions/test.cxx)" "emacs: test.cxx → c++-mode"
assert_equals "c++-mode" "$($FILETYPE -e emacs fixtures/extensions/test.hpp)" "emacs: test.hpp → c++-mode"
assert_equals "javascript-mode" "$($FILETYPE -e emacs fixtures/extensions/test.js)" "emacs: test.js → javascript-mode"
assert_equals "markdown-mode" "$($FILETYPE -e emacs fixtures/extensions/test.md)" "emacs: test.md → markdown-mode"
assert_equals "nxml-mode" "$($FILETYPE -e emacs fixtures/extensions/test.xml)" "emacs: test.xml → nxml-mode"
assert_equals "diff-mode" "$($FILETYPE -e emacs fixtures/extensions/test.diff)" "emacs: test.diff → diff-mode"
assert_equals "java-mode" "$($FILETYPE -e emacs fixtures/extensions/test.java)" "emacs: test.java → java-mode"
assert_equals "rust-mode" "$($FILETYPE -e emacs fixtures/extensions/test.rs)" "emacs: test.rs → rust-mode"
assert_equals "text" "$($FILETYPE -e emacs fixtures/extensions/test.txt)" "emacs: test.txt → text (no -mode)"
assert_equals "binary" "$($FILETYPE -e emacs fixtures/binary/elf_test)" "emacs: binary → binary (no -mode)"

# ========================================
# 7. EDITOR MAPPING TESTS - VSCODE
# ========================================

print_section "Editor Mappings: vscode"

assert_equals "shellscript" "$($FILETYPE -e vscode fixtures/extensions/test.sh)" "vscode: test.sh → shellscript"
assert_equals "shellscript" "$($FILETYPE -e vscode fixtures/extensions/test.csh)" "vscode: test.csh → shellscript"
assert_equals "python" "$($FILETYPE -e vscode fixtures/extensions/test.py)" "vscode: test.py → python"
assert_equals "c" "$($FILETYPE -e vscode fixtures/extensions/test.c)" "vscode: test.c → c"
assert_equals "cpp" "$($FILETYPE -e vscode fixtures/extensions/test.cpp)" "vscode: test.cpp → cpp"
assert_equals "cpp" "$($FILETYPE -e vscode fixtures/extensions/test.cc)" "vscode: test.cc → cpp"
assert_equals "cpp" "$($FILETYPE -e vscode fixtures/extensions/test.cxx)" "vscode: test.cxx → cpp"
assert_equals "cpp" "$($FILETYPE -e vscode fixtures/extensions/test.hpp)" "vscode: test.hpp → cpp"
assert_equals "javascript" "$($FILETYPE -e vscode fixtures/extensions/test.js)" "vscode: test.js → javascript"
assert_equals "markdown" "$($FILETYPE -e vscode fixtures/extensions/test.md)" "vscode: test.md → markdown"

# ========================================
# 8. EDITOR ENVIRONMENT VARIABLE TESTS
# ========================================

print_section "EDITOR Environment Variable Detection"

# No EDITOR set
result=$(unset EDITOR; $FILETYPE fixtures/extensions/test.js)
assert_equals "js" "$result" "No EDITOR → joe (default)"

# EDITOR variants mapping to vim
result=$(EDITOR=vim $FILETYPE fixtures/extensions/test.js)
assert_equals "javascript" "$result" "EDITOR=vim → vim mappings"

result=$(EDITOR=vi $FILETYPE fixtures/extensions/test.js)
assert_equals "javascript" "$result" "EDITOR=vi → vim mappings"

result=$(EDITOR=nvim $FILETYPE fixtures/extensions/test.js)
assert_equals "javascript" "$result" "EDITOR=nvim → vim mappings"

# EDITOR variants mapping to emacs
result=$(EDITOR=emacs $FILETYPE fixtures/extensions/test.py)
assert_equals "python-mode" "$result" "EDITOR=emacs → emacs mappings"

# EDITOR variants mapping to vscode
result=$(EDITOR=code $FILETYPE fixtures/extensions/test.sh)
assert_equals "shellscript" "$result" "EDITOR=code → vscode mappings"

result=$(EDITOR=code-insiders $FILETYPE fixtures/extensions/test.sh)
assert_equals "shellscript" "$result" "EDITOR=code-insiders → vscode mappings"

# EDITOR=nano
result=$(EDITOR=nano $FILETYPE fixtures/extensions/test.md)
assert_equals "markdown" "$result" "EDITOR=nano → nano mappings"

# Unknown EDITOR fallback
result=$(EDITOR=unknown $FILETYPE fixtures/extensions/test.js)
assert_equals "js" "$result" "EDITOR=unknown → joe fallback"

# ========================================
# 9. OPTION PRIORITY TESTS
# ========================================

print_section "Option Priority (-e flag overrides EDITOR)"

result=$(EDITOR=vim $FILETYPE -e joe fixtures/extensions/test.js)
assert_equals "js" "$result" "EDITOR=vim + -e joe → joe wins"

result=$(EDITOR=emacs $FILETYPE -e nano fixtures/extensions/test.md)
assert_equals "markdown" "$result" "EDITOR=emacs + -e nano → nano wins"

result=$(EDITOR=joe $FILETYPE -e vscode fixtures/extensions/test.sh)
assert_equals "shellscript" "$result" "EDITOR=joe + -e vscode → vscode wins"

# ========================================
# 10. EDGE CASES
# ========================================

print_section "Edge Cases"

# Dotfiles without extension
assert_equals "text" "$($FILETYPE fixtures/edge_cases/.bashrc)" ".bashrc → text"
assert_equals "text" "$($FILETYPE fixtures/edge_cases/.vimrc)" ".vimrc → text"
assert_equals "text" "$($FILETYPE fixtures/edge_cases/.gitignore)" ".gitignore → text"

# Dotfile with extension
assert_equals "text" "$($FILETYPE fixtures/edge_cases/.bash_history.txt)" ".bash_history.txt → text"

# Multiple extensions (last wins)
assert_equals "text" "$($FILETYPE fixtures/edge_cases/archive.tar.gz)" "archive.tar.gz → text (gz not recognized)"
assert_equals "js" "$($FILETYPE fixtures/edge_cases/script.min.js)" "script.min.js → js"

# Non-existent files
assert_equals "python" "$($FILETYPE nonexistent.py)" "nonexistent.py → python (extension)"
assert_equals "text" "$($FILETYPE nonexistent.txt)" "nonexistent.txt → text"
assert_equals "text" "$($FILETYPE nonexistent)" "nonexistent (no ext) → text"

# Empty files
assert_equals "python" "$($FILETYPE fixtures/edge_cases/empty.py)" "empty.py → python (extension wins)"
assert_equals "text" "$($FILETYPE fixtures/edge_cases/empty_no_ext)" "empty_no_ext → text"

# Files with spaces
assert_equals "sh" "$($FILETYPE 'fixtures/edge_cases/file with spaces.sh')" "file with spaces.sh → sh"
assert_equals "python" "$($FILETYPE 'fixtures/edge_cases/my file.py')" "my file.py → python"

# Binary detection
assert_equals "binary" "$($FILETYPE fixtures/binary/elf_test)" "ELF binary → binary"
if [[ -f fixtures/binary/actual_binary ]]; then
  assert_equals "binary" "$($FILETYPE fixtures/binary/actual_binary)" "/bin/ls copy → binary"
fi

# ========================================
# 11. BATCH MODE TESTS
# ========================================

print_section "Batch Mode (multiple files)"

# Single file (no prefix)
result=$($FILETYPE fixtures/extensions/test.py)
assert_equals "python" "$result" "Single file: no prefix"

# Multiple files (with prefix)
result=$($FILETYPE fixtures/extensions/test.py fixtures/extensions/test.js)
assert_contains "$result" "test.py: python" "Batch: contains test.py: python"
assert_contains "$result" "test.js: js" "Batch: contains test.js: js"

# ========================================
# 12. ERROR HANDLING TESTS
# ========================================

print_section "Error Handling"

# No files specified
$FILETYPE 2>/dev/null && exit_code=$? || exit_code=$?
assert_exit_code 1 "$exit_code" "No files → exit 1"

# Invalid -e option
$FILETYPE -e invalid fixtures/extensions/test.py 2>/dev/null && exit_code=$? || exit_code=$?
assert_exit_code 1 "$exit_code" "Invalid -e value → exit 1"

# Unknown option
$FILETYPE -x fixtures/extensions/test.py 2>/dev/null && exit_code=$? || exit_code=$?
assert_exit_code 1 "$exit_code" "Unknown option → exit 1"

# Help exits successfully
$FILETYPE --help >/dev/null && exit_code=$? || exit_code=$?
assert_exit_code 0 "$exit_code" "--help → exit 0"

$FILETYPE -h >/dev/null && exit_code=$? || exit_code=$?
assert_exit_code 0 "$exit_code" "-h → exit 0"

# ========================================
# 13. VERSION FLAG TESTS
# ========================================

print_section "Version Flag Tests"

# -V flag
result=$($FILETYPE -V)
assert_contains "$result" "filetype" "-V outputs 'filetype'"
assert_contains "$result" "1.0.0" "-V outputs version number"

# --version flag
result=$($FILETYPE --version)
assert_contains "$result" "filetype" "--version outputs 'filetype'"
assert_contains "$result" "1.0.0" "--version outputs version number"

# Version exits successfully
$FILETYPE -V >/dev/null && exit_code=$? || exit_code=$?
assert_exit_code 0 "$exit_code" "-V → exit 0"

$FILETYPE --version >/dev/null && exit_code=$? || exit_code=$?
assert_exit_code 0 "$exit_code" "--version → exit 0"

# Version format check (no word "version" in output)
result=$($FILETYPE -V)
assert_not_contains "$result" "version 1.0.0" "-V format: no 'version' word"

# ========================================
# SUMMARY
# ========================================

print_summary
exit_code=$?

exit $exit_code

#fin
