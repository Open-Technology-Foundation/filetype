# Filetype Utility - Comprehensive Test Suite

## Overview

This directory contains a comprehensive test suite for the `filetype` utility with **290+ test assertions** covering file types, editors, and edge cases.

## Quick Start

```bash
cd tests/
./run_all_tests.sh
```

## Test Structure

```
tests/
├── setup_fixtures.sh      # Generates 139 test files
├── fixtures/              # Auto-generated test data
│   ├── extensions/        # 80+ files with various extensions
│   ├── shebangs/          # 30+ files with shebang variants
│   ├── binary/            # Binary test files
│   ├── edge_cases/        # Dotfiles, spaces, etc.
│   └── cpp/               # C++ specific tests
├── test_bash.sh           # Bash filetype CLI: ~211 assertions
├── test_editcmd.sh        # Bash editcmd CLI: ~67 assertions
├── test_library_mode.sh   # Test bash library sourcing: ~21 assertions
├── common.sh              # Shared test utilities
└── run_all_tests.sh       # Master runner
```

## Test Coverage

### 1. Extension Tests (~80 tests)
Tests all supported file extensions:
- Shell: `.sh`, `.bash`, `.csh`, `.tcsh`
- Scripting: `.py`, `.pl`, `.rb`, `.php`, `.lua`, `.tcl`, etc.
- Web: `.js`, `.ts`, `.html`, `.css`, `.xml`, `.json`
- Compiled: `.c`, `.cpp`, `.java`, `.go`, `.rs`, `.swift`, `.scala`
- Functional: `.hs`, `.erl`, `.ex`, `.lisp`, `.ml`
- Data: `.yaml`, `.ini`, `.conf`, `.sql`
- Other: `.diff`, `.md`, `.tex`, `.r`, `.prolog`, etc.

### 2. Shebang Tests (~30 tests)
Tests shebang detection for files without extensions:
- `#!/bin/bash`, `#!/usr/bin/env bash`, `#!/usr/bin/bash`
- `#!/bin/sh`, `#!/usr/bin/env sh`
- Python, Perl, Ruby, PHP, Node, AWK, Sed, Lua, Tcl variants

### 3. Editor Mapping Tests (~75 tests)
Tests all 5 editors with key file types:
- **joe**: Passthrough (default behavior)
- **nano**: `js→javascript`, `md→markdown`, `diff→patch`
- **vim**: JS/MD mappings, bash detection, C++ detection
- **emacs**: `-mode` suffix pattern, special cases (`nxml-mode`, `c++-mode`)
- **vscode**: `sh→shellscript`, C++ detection

### 4. Editcmd Tests (~60 tests)
- Version flags, print/dry-run modes
- EDITOR environment variable handling
- Line positioning (-l and +NUM)
- All 5 editor selections
- Syntax detection integration
- Error handling and combined options
- Filenames with spaces, non-existent files

### 5. Edge Cases (~20 tests)
- Dotfiles: `.bashrc`, `.vimrc`, `.gitignore`
- Multiple extensions: `archive.tar.gz`, `script.min.js`
- Non-existent files, empty files
- Files with spaces in names
- Binary detection, C++ file detection

### 6. Library Mode Tests (~20 tests)
- Direct function calls: `filetype()`, `map_to_editor()`, `detect_editor_from_env()`
- Tests bash script when sourced as library

## Running Individual Test Suites

```bash
./test_bash.sh              # Bash implementation tests
./test_editcmd.sh           # Editcmd CLI tests
./test_library_mode.sh      # Library mode tests

# Setup fixtures manually
./setup_fixtures.sh
```

## Test Output

```
======================================================================
  FILETYPE - COMPREHENSIVE TEST SUITE
======================================================================

Step 1: Setting up test fixtures
✓ Setup complete: 139 test fixture files created
✓ Fixtures created successfully

Running: Bash Implementation Tests
✓ Bash Implementation Tests PASSED

Running: Editcmd Tests (Bash)
✓ Editcmd Tests (Bash) PASSED

Running: Library Mode Tests (Bash)
✓ Library Mode Tests (Bash) PASSED

======================================================================
  FINAL TEST SUMMARY
======================================================================

Test Suites Run:    3
Suites Passed:      3
Suites Failed:      0

Time: 3s
======================================================================

All test suites passed! ✓
```

## Test Statistics

- **Total Fixtures**: 139 test files
- **Total Test Assertions**: ~299
- **Test Suites**: 3
- **File Types Covered**: 47 syntax types
- **File Extensions Tested**: 80+
- **Shebang Variants**: 30+
- **Editors Tested**: 5 (joe, nano, vim, emacs, vscode)

## CI/CD Integration

The test suite is designed for CI/CD:
- Exit code 0 on success, non-zero on failure
- Idempotent (can run multiple times)
- Self-contained (generates own fixtures)
- Fast execution (~3-5 seconds total)
- Summary reporting

## Test Framework

- **Bash tests**: Custom assertion framework in `common.sh`
- **Output**: Colored PASS/FAIL with TAP-style reporting
- **Summary**: Total/Pass/Fail counts with ASCII art

## Maintenance

To add new tests:
1. Add fixtures in `setup_fixtures.sh`
2. Add assertions to `test_bash.sh`
3. Run `./run_all_tests.sh` to verify

#fin
