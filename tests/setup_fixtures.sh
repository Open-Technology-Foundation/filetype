#!/usr/bin/env bash
# setup_fixtures.sh - Generate all test fixture files
# This creates ~100+ test files with various extensions, shebangs, and content

set -euo pipefail

cd "$(dirname "$0")"
FIXTURES_DIR="fixtures"

echo "Setting up test fixtures..."

# Clean old fixtures
rm -rf "${FIXTURES_DIR}"
mkdir -p "${FIXTURES_DIR}"/{extensions,shebangs,binary,edge_cases,cpp,filenames}

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

# Modern web
create_extension_file "jsx" "const App = () => <div/>;"
create_extension_file "vue" "<template><div/></template>"
create_extension_file "svelte" "<script>let name = 'world';</script>"
create_extension_file "graphql" "type Query { hello: String }"
create_extension_file "gql" "query { hello }"

# Modern compiled languages
create_extension_file "kt" "fun main() { println(\"test\") }"
create_extension_file "kts" "println(\"script\")"
create_extension_file "dart" "void main() { print('test'); }"
create_extension_file "zig" "const std = @import(\"std\");"
create_extension_file "nim" "echo \"Hello\""

# Config/IaC
create_extension_file "toml" "[package]"
create_extension_file "nix" "{ pkgs ? import <nixpkgs> {} }:"
create_extension_file "tf" "resource \"aws_instance\" \"test\" {}"
create_extension_file "tfvars" "instance_type = \"t2.micro\""

# Build systems
create_extension_file "gradle" "apply plugin: 'java'"

# Data formats
create_extension_file "proto" "syntax = \"proto3\";"
create_extension_file "csv" "name,age,city"
create_extension_file "tsv" "name\tage\tcity"
create_extension_file "jsonl" '{"event":"test"}'
create_extension_file "jsonc" '{ /* comment */ "test": true }'

# Binary
printf '\x00asm\x01\x00\x00\x00' > "${FIXTURES_DIR}/extensions/test.wasm"
((FILES_CREATED+=1))

# Plain text
create_extension_file "txt" "Plain text file"
create_extension_file "text" "Plain text file"

# ========================================
# 1b. SPECIAL FILENAME TESTS
# ========================================

# Dockerfile variants
echo "FROM ubuntu:24.04" > "${FIXTURES_DIR}/filenames/Dockerfile"
echo "FROM ubuntu:24.04" > "${FIXTURES_DIR}/filenames/Dockerfile.dev"
echo "FROM ubuntu:24.04" > "${FIXTURES_DIR}/filenames/Dockerfile.prod"
((FILES_CREATED+=3))

# Makefile variants
echo "all:" > "${FIXTURES_DIR}/filenames/Makefile"
echo "all:" > "${FIXTURES_DIR}/filenames/GNUmakefile"
((FILES_CREATED+=2))

# Other build/config filenames
echo "pipeline {}" > "${FIXTURES_DIR}/filenames/Jenkinsfile"
echo "Vagrant.configure('2')" > "${FIXTURES_DIR}/filenames/Vagrantfile"
echo "task :default" > "${FIXTURES_DIR}/filenames/Rakefile"
echo "source 'https://rubygems.org'" > "${FIXTURES_DIR}/filenames/Gemfile"
echo "cmake_minimum_required(VERSION 3.10)" > "${FIXTURES_DIR}/filenames/CMakeLists.txt"
((FILES_CREATED+=5))

# Dotfiles
echo "DB_HOST=localhost" > "${FIXTURES_DIR}/filenames/.env"
echo "DB_HOST=localhost" > "${FIXTURES_DIR}/filenames/.env.local"
echo "DB_HOST=localhost" > "${FIXTURES_DIR}/filenames/.env.production"
((FILES_CREATED+=3))

# Shell dotfiles
echo "# Bash config" > "${FIXTURES_DIR}/filenames/.bashrc"
echo "# Bash profile" > "${FIXTURES_DIR}/filenames/.bash_profile"
echo "# Bash aliases" > "${FIXTURES_DIR}/filenames/.bash_aliases"
echo "# Profile" > "${FIXTURES_DIR}/filenames/.profile"
((FILES_CREATED+=4))

# Zsh dotfiles
echo "# Zsh config" > "${FIXTURES_DIR}/filenames/.zshrc"
echo "# Zsh profile" > "${FIXTURES_DIR}/filenames/.zprofile"
echo "# Zsh env" > "${FIXTURES_DIR}/filenames/.zshenv"
((FILES_CREATED+=3))

# Git dotfiles
echo "[user]" > "${FIXTURES_DIR}/filenames/.gitconfig"
echo "*.pyc" > "${FIXTURES_DIR}/filenames/.gitignore"
echo "*.txt text" > "${FIXTURES_DIR}/filenames/.gitattributes"
((FILES_CREATED+=3))

# Other dotfiles
echo "root = true" > "${FIXTURES_DIR}/filenames/.editorconfig"
echo "node_modules" > "${FIXTURES_DIR}/filenames/.dockerignore"
((FILES_CREATED+=2))

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

# Zsh
create_shebang_file "zsh1" "#!/bin/zsh"
create_shebang_file "zsh2" "#!/usr/bin/env zsh"

# Modern runtimes
create_shebang_file "deno" "#!/usr/bin/env deno"
create_shebang_file "bun" "#!/usr/bin/env bun"
create_shebang_file "tsnode" "#!/usr/bin/env ts-node"

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

# PE32 binary signature
printf 'MZ\x90\x00' > "${FIXTURES_DIR}/binary/pe32_test"
((FILES_CREATED+=1))

# Gzip compressed file
printf '\x1f\x8b\x08\x00' > "${FIXTURES_DIR}/binary/gzip_test.gz"
((FILES_CREATED+=1))

# WebAssembly binary
printf '\x00asm\x01\x00\x00\x00' > "${FIXTURES_DIR}/binary/test.wasm"
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
