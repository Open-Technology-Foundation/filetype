# Filetype Utility - Comprehensive Test Suite

## Overview

This directory contains a comprehensive test suite for the `filetype` utility with **~1000+ test assertions** covering all permutations of file types, editors, and edge cases.

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
├── test_bash.sh           # Bash version: ~240 assertions
├── test_python.py         # Python version: ~240 assertions
├── test_parity.sh         # Verify bash/Python parity: ~100 assertions
├── test_library_mode.sh   # Test bash library sourcing: ~30 assertions
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

### 4. EDITOR Environment Variable Tests (~15 tests)
- No EDITOR → defaults to joe
- `EDITOR=vim/vi/nvim/neovim` → vim mappings
- `EDITOR=emacs/emacs-nox` → emacs mappings
- `EDITOR=code/code-insiders` → vscode mappings
- `EDITOR=unknown` → fallback to joe

### 5. Edge Cases (~20 tests)
- Dotfiles: `.bashrc`, `.vimrc`, `.gitignore`
- Multiple extensions: `archive.tar.gz`, `script.min.js`
- Non-existent files
- Empty files
- Files with spaces in names
- Binary detection
- C++ file detection (`.cpp`, `.cc`, `.cxx`, `.hpp`)
- Bash vs sh detection in vim

### 6. Batch Mode Tests (~5 tests)
- Single file → no prefix
- Multiple files → `filename: syntax` format

### 7. Error Handling Tests (~5 tests)
- No files specified
- Invalid `-e` option
- Unknown options
- Help (`-h`/`--help`) exits successfully

### 8. Library Mode Tests (~30 tests, bash only)
- Direct function calls: `filetype()`, `map_to_editor()`, `detect_editor_from_env()`
- Tests bash script when sourced as library

### 9. Parity Tests (~100 tests)
- Verifies bash and Python produce **identical** output
- Tests all extensions, shebangs, editors, and edge cases
- Ensures implementations stay in sync

## Running Individual Test Suites

```bash
# Run individual test suites
./test_bash.sh              # Bash implementation tests
./test_python.py            # Python implementation tests
./test_parity.sh            # Parity verification
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

Running: Python Implementation Tests
✓ Python Implementation Tests PASSED

Running: Parity Tests (Bash vs Python)
✓ Parity Tests (Bash vs Python) PASSED

Running: Library Mode Tests (Bash)
✓ Library Mode Tests (Bash) PASSED

======================================================================
  FINAL TEST SUMMARY
======================================================================

Test Suites Run:    4
Suites Passed:      4
Suites Failed:      0

Time: 8s
======================================================================

All test suites passed! ✓
```

## Test Statistics

- **Total Fixtures**: 139 test files
- **Total Test Assertions**: ~610
- **Test Suites**: 4
- **File Types Covered**: 46 syntax types
- **File Extensions Tested**: 80+
- **Shebang Variants**: 30+
- **Editors Tested**: 5 (joe, nano, vim, emacs, vscode)
- **EDITOR Variants**: 13 (vim, vi, nvim, neovim, emacs, emacs-nox, code, code-insiders, nano, joe, unknown, etc.)

## CI/CD Integration

The test suite is designed for CI/CD:
- Exit code 0 on success, non-zero on failure
- Idempotent (can run multiple times)
- Self-contained (generates own fixtures)
- Fast execution (~6-10 seconds total)
- Summary reporting

## Test Framework

- **Bash tests**: Custom assertion framework in `common.sh`
- **Python tests**: pytest framework
- **Output**: Colored PASS/FAIL with TAP-style reporting
- **Summary**: Total/Pass/Fail counts with ASCII art

## Notes

- Some parity test differences are expected (help text formatting, error message wording)
- Binary detection requires `file` command
- EDITOR resolution uses `readlink -f` (GNU coreutils)
- All tests run relative to `tests/` directory

## Maintenance

To add new tests:
1. Add fixtures in `setup_fixtures.sh`
2. Add assertions to `test_bash.sh` and `test_python.py`
3. Add parity check to `test_parity.sh` if applicable
4. Run `./run_all_tests.sh` to verify

#fin
