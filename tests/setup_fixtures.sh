#!/usr/bin/env bash
# setup_fixtures.sh - Generate all test fixture files
# This creates ~100+ test files with various extensions, shebangs, and content

set -euo pipefail

cd "$(dirname "$0")"
FIXTURES_DIR="fixtures"

echo "Setting up test fixtures..."

# Clean old fixtures
rm -rf "${FIXTURES_DIR}"
mkdir -p "${FIXTURES_DIR}"/{extensions,shebangs,binary,edge_cases,cpp}

FILES_CREATED=0

# ========================================
# 1. EXTENSION TESTS - Create files with all supported extensions
# ========================================

create_extension_file() {
  local ext="$1"
  local content="${2:-# Test file}"
  local filename="${FIXTURES_DIR}/extensions/test.${ext}"
  echo "$content" > "$filename"
  ((FILES_CREATED+=1))
}

# Shell scripts
create_extension_file "sh" "#!/bin/sh"
create_extension_file "bash" "#!/bin/bash"
create_extension_file "csh" "#!/bin/csh"
create_extension_file "tcsh" "#!/bin/tcsh"

# Scripting languages
create_extension_file "py" "#!/usr/bin/env python3"
create_extension_file "pl" "#!/usr/bin/perl"
create_extension_file "pm" "package Test;"
create_extension_file "t" "#!/usr/bin/perl"
create_extension_file "rb" "#!/usr/bin/ruby"
create_extension_file "gemspec" "Gem::Specification.new"
create_extension_file "rabl" "# Rabl template"
create_extension_file "php" "<?php"
create_extension_file "awk" "#!/usr/bin/awk"
create_extension_file "sed" "#!/usr/bin/sed"
create_extension_file "lua" "#!/usr/bin/lua"
create_extension_file "tcl" "#!/usr/bin/tclsh"

# Web development
create_extension_file "js" "console.log('test');"
create_extension_file "mjs" "export default {};"
create_extension_file "json" '{"test": true}'
create_extension_file "ts" "const x: string = 'test';"
create_extension_file "tsx" "const x: JSX.Element = <div/>;"
create_extension_file "htm" "<html></html>"
create_extension_file "html" "<html></html>"
create_extension_file "css" "body { color: red; }"
create_extension_file "xml" '<?xml version="1.0"?><root/>'
create_extension_file "xsd" '<?xml version="1.0"?><schema/>'
create_extension_file "jnlp" '<?xml version="1.0"?><jnlp/>'
create_extension_file "resx" '<?xml version="1.0"?><root/>'

# Data/config formats
create_extension_file "yaml" "test: value"
create_extension_file "yml" "test: value"
create_extension_file "ini" "[section]"
create_extension_file "conf" "# Config"
create_extension_file "cfg" "# Config"
create_extension_file "properties" "test=value"

# Markup/documentation
create_extension_file "md" "# Test"
create_extension_file "markdown" "# Test"
create_extension_file "tex" "\\documentclass{article}"
create_extension_file "sty" "% Style file"

# Compiled languages
create_extension_file "c" "int main() { return 0; }"
create_extension_file "h" "#ifndef TEST_H"
create_extension_file "hh" "#ifndef TEST_HH"
create_extension_file "mm" "#import <Foundation/Foundation.h>"
create_extension_file "java" "public class Test {}"
create_extension_file "go" "package main"
create_extension_file "rs" "fn main() {}"
create_extension_file "cs" "class Test {}"
create_extension_file "swift" "import Foundation"
create_extension_file "scala" "object Test {}"
create_extension_file "d" "void main() {}"

# C++ extensions (in cpp subdirectory)
create_extension_file "cpp" "#include <iostream>"
create_extension_file "cc" "#include <iostream>"
create_extension_file "cxx" "#include <iostream>"
create_extension_file "hpp" "#ifndef TEST_HPP"
create_extension_file "h++" "#ifndef TEST_HPP"

# Functional languages
create_extension_file "hs" "main = putStrLn \"test\""
create_extension_file "lhs" "> main = putStrLn \"test\""
create_extension_file "erl" "-module(test)."
create_extension_file "hrl" "% Header file"
create_extension_file "ex" "defmodule Test do"
create_extension_file "exs" "# Elixir script"
create_extension_file "lisp" "(defun test ())"
create_extension_file "lsp" "(defun test ())"
create_extension_file "cl" "(defun test ())"
create_extension_file "ml" "let x = 1"
create_extension_file "mli" "(* Interface *)"

# Database
create_extension_file "sql" "SELECT * FROM test;"

# Version control/diffs
create_extension_file "diff" "--- a/file\n+++ b/file"
create_extension_file "patch" "--- a/file\n+++ b/file"

# Other
create_extension_file "r" "x <- 1"
create_extension_file "prolog" "test(X) :- true."
create_extension_file "pro" "test(X) :- true."
create_extension_file "pas" "program Test;"
create_extension_file "f" "      PROGRAM TEST"
create_extension_file "for" "      PROGRAM TEST"
create_extension_file "f90" "program test"
create_extension_file "cob" "       IDENTIFICATION DIVISION."
create_extension_file "cbl" "       IDENTIFICATION DIVISION."
create_extension_file "v" "module test;"
create_extension_file "vh" "// Verilog header"
create_extension_file "vhd" "entity test is"
create_extension_file "vhdl" "entity test is"
create_extension_file "bat" "@echo off"
create_extension_file "cmd" "@echo off"
create_extension_file "ps" "%!PS-Adobe"
create_extension_file "eps" "%!PS-Adobe-3.0 EPSF-3.0"

# Plain text
create_extension_file "txt" "Plain text file"
create_extension_file "text" "Plain text file"

# ========================================
# 2. SHEBANG TESTS - Files with no extension but various shebangs
# ========================================

create_shebang_file() {
  local name="$1"
  local shebang="$2"
  local filename="${FIXTURES_DIR}/shebangs/${name}"
  echo "$shebang" > "$filename"
  echo "# Content" >> "$filename"
  chmod +x "$filename"
  ((FILES_CREATED+=1))
}

# Shell variants
create_shebang_file "bash1" "#!/bin/bash"
create_shebang_file "bash2" "#!/usr/bin/env bash"
create_shebang_file "bash3" "#!/usr/bin/bash"
create_shebang_file "sh1" "#!/bin/sh"
create_shebang_file "sh2" "#!/usr/bin/env sh"
create_shebang_file "sh3" "#!/usr/bin/sh"
create_shebang_file "csh1" "#!/bin/csh"
create_shebang_file "csh2" "#!/usr/bin/env csh"
create_shebang_file "tcsh1" "#!/bin/tcsh"
create_shebang_file "tcsh2" "#!/usr/bin/env tcsh"

# Scripting languages
create_shebang_file "python1" "#!/usr/bin/python"
create_shebang_file "python2" "#!/usr/bin/env python"
create_shebang_file "python3" "#!/usr/bin/python3"
create_shebang_file "perl1" "#!/usr/bin/perl"
create_shebang_file "perl2" "#!/usr/bin/env perl"
create_shebang_file "ruby1" "#!/usr/bin/ruby"
create_shebang_file "ruby2" "#!/usr/bin/env ruby"
create_shebang_file "php1" "#!/usr/bin/php"
create_shebang_file "php2" "#!/usr/bin/env php"
create_shebang_file "php3" "<?php"

# Web/utilities
create_shebang_file "node1" "#!/usr/bin/node"
create_shebang_file "node2" "#!/usr/bin/env node"
create_shebang_file "awk1" "#!/usr/bin/awk"
create_shebang_file "awk2" "#!/usr/bin/env awk"
create_shebang_file "gawk" "#!/usr/bin/gawk"
create_shebang_file "sed1" "#!/usr/bin/sed"
create_shebang_file "sed2" "#!/usr/bin/env sed"
create_shebang_file "lua1" "#!/usr/bin/lua"
create_shebang_file "lua2" "#!/usr/bin/env lua"
create_shebang_file "tclsh1" "#!/usr/bin/tclsh"
create_shebang_file "tclsh2" "#!/usr/bin/env tclsh"
create_shebang_file "wish" "#!/usr/bin/wish"

# ========================================
# 3. BINARY FILES
# ========================================

# Create a simple ELF binary (using echo to create pseudo-binary)
printf '\x7fELF' > "${FIXTURES_DIR}/binary/elf_test"
((FILES_CREATED+=1))

# Copy actual binary
cp /bin/ls "${FIXTURES_DIR}/binary/actual_binary" 2>/dev/null || true
((FILES_CREATED+=1))

# Create empty binary marker
touch "${FIXTURES_DIR}/binary/binary_marker"
((FILES_CREATED+=1))

# Image binary (PNG signature)
printf '\x89PNG\r\n\x1a\n' > "${FIXTURES_DIR}/binary/fake_image.png"
((FILES_CREATED+=1))

# ========================================
# 4. EDGE CASES
# ========================================

# Dotfiles without extension
echo "# Bash config" > "${FIXTURES_DIR}/edge_cases/.bashrc"
echo "# Vim config" > "${FIXTURES_DIR}/edge_cases/.vimrc"
echo "*.pyc" > "${FIXTURES_DIR}/edge_cases/.gitignore"
((FILES_CREATED+=3))

# Dotfile with extension
echo "History entry" > "${FIXTURES_DIR}/edge_cases/.bash_history.txt"
((FILES_CREATED+=1))

# Multiple extensions
echo "Gzipped tar" > "${FIXTURES_DIR}/edge_cases/archive.tar.gz"
echo "console.log('min');" > "${FIXTURES_DIR}/edge_cases/script.min.js"
((FILES_CREATED+=2))

# Directory fixture (explicit test dir)
mkdir -p "${FIXTURES_DIR}/edge_cases/test_directory"
((FILES_CREATED+=1))

# Non-existent files (will be referenced but not created)
# These are tested by passing filenames that don't exist

# File with spaces
echo "#!/bin/bash" > "${FIXTURES_DIR}/edge_cases/file with spaces.sh"
echo "print('test')" > "${FIXTURES_DIR}/edge_cases/my file.py"
((FILES_CREATED+=2))

# Empty files
touch "${FIXTURES_DIR}/edge_cases/empty.py"
touch "${FIXTURES_DIR}/edge_cases/empty_no_ext"
((FILES_CREATED+=2))

# File with shebang but has extension
echo "#!/bin/bash" > "${FIXTURES_DIR}/edge_cases/has_ext.sh"
echo "#!/bin/sh" > "${FIXTURES_DIR}/edge_cases/has_ext_sh.sh"
((FILES_CREATED+=2))

# ========================================
# 5. C++ DETECTION TEST FILES (in cpp subdirectory)
# ========================================

# Already created in extensions, but also create in cpp/ for specific tests
echo "#include <iostream>" > "${FIXTURES_DIR}/cpp/test.cpp"
echo "#include <iostream>" > "${FIXTURES_DIR}/cpp/test.cc"
echo "#include <iostream>" > "${FIXTURES_DIR}/cpp/test.cxx"
echo "#ifndef TEST_HPP" > "${FIXTURES_DIR}/cpp/test.hpp"
echo "int main() {}" > "${FIXTURES_DIR}/cpp/test.c"  # Regular C file for comparison
((FILES_CREATED+=5))

echo "✓ Setup complete: $FILES_CREATED test fixture files created"

#fin
