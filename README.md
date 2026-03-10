# filetype & editcmd

[![GitHub](https://img.shields.io/badge/GitHub-Open--Technology--Foundation%2Ffiletype-blue?logo=github)](https://github.com/Open-Technology-Foundation/filetype)
[![License](https://img.shields.io/badge/License-Open%20Source-green.svg)](https://github.com/Open-Technology-Foundation/filetype)
[![Bash](https://img.shields.io/badge/Bash-5.2%2B-blue.svg)](https://www.gnu.org/software/bash/)

A dual-tool suite for file type detection and smart editor launching.

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Supported File Types](#supported-file-types)
- [Architecture](#architecture)
- [Installation](#installation)
- [Usage](#usage)
  - [Quick Start](#quick-start)
  - [filetype - File Type Detection](#filetype---file-type-detection)
  - [editcmd - Smart Editor Launcher](#editcmd---smart-editor-launcher)
  - [Tool Comparison](#tool-comparison)
  - [Library Mode](#library-mode)
- [Command-Line Options](#command-line-options)
- [Detection Logic](#detection-logic)
- [Examples](#examples)
- [Advanced Usage](#editcmd---advanced-usage)
- [Testing](#testing)
- [Error Handling](#error-handling)
- [Bash Completion](#bash-completion)
- [Requirements](#requirements)
- [Project Structure](#project-structure)
- [Contributing](#contributing)
- [License](#license)

## Overview

This project provides two complementary tools:

- **`filetype`** - Detects file types and returns syntax names for editors
- **`editcmd`** - Launches editors with automatic syntax highlighting and line positioning

Both tools are implemented in a single Bash script using busybox-style `$0` dispatch, with `editcmd` as a symlink to `filetype`.

## Features

- **Multiple Detection Methods**:
  - File extension analysis
  - Shebang line parsing for executable scripts
  - MIME type detection
  - Binary file signature checking
- **Editor Integration**: Generate ready-to-use editor launch commands with syntax highlighting
- **Line Positioning**: Jump directly to specific line numbers when opening files in editors
- **Library Mode**: Source as Bash functions in your scripts
- **Safe Binary Handling**: Prevents accidental editing of binary files
- **Zero External Dependencies**: Only uses standard system utilities

## Supported File Types

Detects 67+ file types and returns editor-appropriate syntax names. Common types include:

- **Shell scripts**: `sh`, `csh`, `zsh`
- **Programming languages**: `python`, `c`, `js`, `php`, `ruby`, `perl`, `java`, `go`, `rust`, `typescript`, `kotlin`, `dart`, `zig`, `nim`
- **Web**: `html`, `css`, `xml`, `json`, `jsx`, `vue`, `svelte`, `graphql`
- **Markup**: `md`, `tex`
- **Config**: `ini`, `conf`, `properties`, `toml`, `nix`, `terraform`
- **Data**: `csv`, `tsv`, `jsonl`, `jsonc`, `protobuf`, `yaml`
- **Special filenames**: `Dockerfile`, `Makefile`, `Jenkinsfile`, `.bashrc`, `.env`, `.gitignore`, etc.
- **Other**: `sql`, `diff`, `awk`, `sed`, `lua`, `text`, `binary`

The exact syntax name returned depends on the editor specified (via `-e` flag):
- **joe** (default): Base syntax names (`sh`, `python`, `c`, `js`, `json`, `md`)
- **nano**: Full names (`javascript` not `js`, `markdown` not `md`, `patch` not `diff`)
- **vim**: Language-specific (`bash` for bash scripts, `cpp` for C++, `markdown` not `md`)
- **emacs**: Mode names (`python-mode`, `c-mode`, `javascript-mode`, `markdown-mode`)
- **vscode**: VSCode identifiers (`shellscript` not `sh`, `cpp` for C++)
- **helix**: Auto-detect (tree-sitter based, no syntax flag needed)
- **micro**: Auto-detect (no syntax flag needed)
- **zed**: Auto-detect (tree-sitter based, uses `file:line` positioning)

## Architecture

The project uses a **shared library architecture** to eliminate code duplication:

```
filetype/
├── filetype              # Bash: core library + CLI + editcmd mode (busybox-style)
└── editcmd -> filetype   # Symlink: triggers editcmd CLI mode via $0 dispatch
```

`filetype` serves triple roles — sourceable library, detection CLI, and editor launcher CLI. When invoked as `editcmd` (via symlink), it dispatches to editor launcher mode using `${0##*/}` (busybox-style). This ensures:
- ✅ Zero code duplication
- ✅ Consistent behavior across tools
- ✅ Single source of truth for detection logic
- ✅ Easy maintenance and testing

## Installation

### One-Liner Install

```bash
git clone https://github.com/Open-Technology-Foundation/filetype.git && cd filetype && sudo make install
```

### Quick Install (Step-by-Step)

```bash
# Clone the repository
git clone https://github.com/Open-Technology-Foundation/filetype.git
cd filetype

# Install to /usr/local
sudo make install
```

This installs executables to `/usr/local/bin/`, manpages to `/usr/local/share/man/man1/`, and bash completion to `/etc/bash_completion.d/`.

### Manual Installation

If you prefer manual installation or need a custom location:

```bash
# Copy executable
sudo install -m 755 filetype /usr/local/bin/filetype

# Create editcmd symlink
sudo ln -sf filetype /usr/local/bin/editcmd
```

### Alternative: Add to PATH

```bash
# Add directory to PATH in your ~/.bashrc or ~/.bash_profile
export PATH="/path/to/filetype:$PATH"
```

## Usage

### Quick Start

```bash
# Check version
filetype -V                     # Returns: filetype 1.0.0
editcmd -V                      # Returns: editcmd 1.0.0

# Detect file type
filetype script.py              # Returns: python

# Launch editor with syntax highlighting
editcmd script.py               # Opens in your editor with Python syntax

# Jump to specific line
editcmd -l 42 script.py         # Opens at line 42
editcmd +42 script.py           # Vim-style shorthand
```

### filetype - File Type Detection

Use `filetype` when you need to **identify** file types:

```bash
# Basic detection
filetype script.sh              # Returns: sh
filetype app.py                 # Returns: python

# Detect for specific editor
filetype -e vim script.py       # Returns: python (vim format)
filetype -e emacs app.c         # Returns: c-mode (emacs format)

# Batch processing
filetype *.py *.sh              # Detects multiple files
```

### editcmd - Smart Editor Launcher

Use `editcmd` when you want to **open files** with proper syntax:

```bash
# Open file with auto-detected syntax
editcmd script.py               # Opens with Python highlighting

# Jump to specific line
editcmd -l 42 script.py         # Opens at line 42
editcmd +100 test.c             # Vim-style: open at line 100

# Use specific editor
editcmd -e nano script.py       # Force nano
editcmd -e vim +50 app.js       # Vim at line 50

# Preview command (print without executing)
editcmd -p script.py            # Shows: vim -c 'set filetype=python' script.py
editcmd --dry-run script.py     # Same as -p

# Multiple options
editcmd -e emacs -l 25 test.c   # Emacs at line 25
```

### Tool Comparison

| Feature | `filetype` | `editcmd` |
|---------|-----------|-----------|
| **Purpose** | Detect and report type | Launch editor |
| **Output** | Type string | Executed command |
| **Primary use** | Scripting, automation | Interactive editing |
| **Line positioning** | ❌ No | ✅ Yes (`-l` or `+NUM`) |
| **Print mode** | N/A | ✅ Yes (`-p`, `--print`, `--dry-run`) |
| **Batch mode** | ✅ Multiple files | ❌ One file at a time |
| **Executes editor** | ❌ No | ✅ Yes |

### Library Mode

```bash
# Source the script
source /path/to/filetype

# Use the function
result=$(filetype somefile.sh)
echo "$result"  # Output: sh

# In your scripts
if [[ $(filetype "$file") == 'binary' ]]; then
  echo 'Cannot edit binary file'
  exit 1
fi
```

## Command-Line Options

### filetype Options

```
filetype [options] <file> [<file2> ...]

Options:
  -e, --editor EDITOR   Return syntax name for specific editor
  --                    End of options (allows filenames starting with -)
  -V, --version         Show version information
  -h, --help            Show help message

Supported editors: joe, nano, vim, emacs, vscode, helix, micro, zed
```

### editcmd Options

```
editcmd [options] <file>

Options:
  -e, --editor EDITOR   Editor to use (default: $EDITOR or vim)
  -l, --line-no NUM     Jump to line NUM
  +NUM                  Jump to line NUM (vim-style shorthand)
  -p, --print           Print command without executing
  --dry-run             Print command without executing (same as -p)
  -V, --version         Show version information
  -h, --help            Show help message

Supported editors: joe, nano, vim, emacs, vscode, helix, micro, zed
```

### Supported Editors

`editcmd` generates native commands for each editor:

| Editor | Without line | With `-l 42` or `+42` |
|--------|-------------|-------------|
| joe | `joe -syntax TYPE FILE` | `joe +42 -syntax TYPE FILE` |
| nano | `nano --syntax=TYPE FILE` | `nano +42 --syntax=TYPE FILE` |
| vim (default) | `vim -c 'set filetype=TYPE' FILE` | `vim +42 -c 'set filetype=TYPE' FILE` |
| emacs | `emacs -eval '(TYPE)' FILE` | `emacs +42 -eval '(TYPE)' FILE` |
| vscode | `code --file-uri "...?language=TYPE"` | `code --file-uri "...?language=TYPE#L42"` |
| helix | `hx FILE` | `hx +42 FILE` |
| micro | `micro FILE` | `micro +42 FILE` |
| zed | `zed FILE` | `zed FILE:42` |

## Detection Logic

The detection follows this order:

1. **Special filename matching** - Recognizes files by name (`Dockerfile`, `Makefile`, `.bashrc`, `.env`, `.gitignore`, etc.)
2. **Extension-based detection** - Checks common file extensions (.sh, .py, .php, .c, .txt, .toml, .kt, etc.)
3. **Shebang parsing** - Reads first line for `#!/path/to/interpreter` (including zsh, deno, bun, ts-node)
4. **MIME type analysis** - Uses `file -b --mime-type` command
5. **Binary detection** - Checks file signatures (ELF, PE32, Mach-O, etc.)
6. **Default fallback** - Returns 'text' for unrecognized files

**Important**: Binary files are detected before text/* MIME patterns to prevent data corruption from accidental editing attempts.

## Examples

### Basic Detection

```bash
# Detect by extension
$ filetype script.sh
sh

# Detect by shebang (bash script without extension)
$ filetype script
sh

# Binary file
$ filetype /bin/ls
binary

# Different syntax for different editors
$ filetype -e vim script.sh
bash
$ filetype -e nano script.py
python
$ filetype -e emacs app.c
c-mode
```

### Editor Launching with editcmd

```bash
# Open file with default editor (vim)
$ editcmd test.py
# Launches: vim -c 'set filetype=python' test.py

# Open with specific editor
$ editcmd -e nano test.py
# Launches: nano --syntax=python test.py

# Handle spaces in filenames (automatic)
$ editcmd "my script.sh"
# Launches: vim -c 'set filetype=bash' 'my script.sh'

# Binary files produce error
$ editcmd /bin/ls
error: Cannot edit binary file '/bin/ls'

# Print command without executing
$ editcmd -p test.py
vim -c 'set filetype=python' test.py
```

### Line Positioning with editcmd

```bash
# Jump to line 42 (long form)
$ editcmd -l 42 test.py
# Launches: vim +42 -c 'set filetype=python' test.py

# Jump to line 100 (vim-style)
$ editcmd +100 script.sh
# Launches: vim +100 -c 'set filetype=bash' script.sh

# With specific editor
$ editcmd -e nano +75 app.js
# Launches: nano +75 --syntax=javascript app.js

# VSCode with line positioning
$ editcmd -e vscode -l 50 config.json
# Launches: code --file-uri "vscode-file://...?language=json#L50"
```

### Batch Processing

```bash
# Process multiple files
$ filetype *.sh *.py
script1.sh: sh
script2.sh: sh
test.py: python
main.py: python

# Detect syntax for all shell files with vim
$ filetype -e vim *.sh
script1.sh: bash
script2.sh: bash

# Detect syntax for Python files with emacs
$ filetype -e emacs *.py
test.py: python-mode
main.py: python-mode
```

## editcmd - Advanced Usage

### Integration with Development Workflows

#### Jump to Linter Errors

```bash
# Python with pylint
error_line=$(pylint script.py 2>&1 | grep -oP '^\w+.py:\K\d+' | head -1)
editcmd -l "$error_line" script.py

# JavaScript with ESLint
eslint app.js --format unix | head -1 | cut -d: -f2 | xargs -I{} editcmd -l {} app.js

# Generic: extract line number from error output
compiler_output | grep -oP 'line \K\d+' | head -1 | xargs -I{} editcmd -l {} source.c
```

#### Jump to Grep Matches

```bash
# Open first TODO
grep -n "TODO" *.py | head -1 | IFS=: read file line rest && editcmd -l "$line" "$file"

# Open all TODOs interactively
grep -n "TODO" *.py | while IFS=: read file line content; do
  echo "Found: $content"
  read -p "Open $file:$line? (y/n) " answer
  [[ $answer == "y" ]] && editcmd -l "$line" "$file"
done
```

#### Integration with Git

```bash
# Edit files with conflicts
git diff --name-only --diff-filter=U | xargs -I{} editcmd {}

# Edit files changed in last commit
git diff --name-only HEAD~1 | xargs -I{} editcmd {}

# Jump to line in git blame
git blame file.py | grep "bug" | cut -d' ' -f1 | \
  xargs -I{} git show {}:file.py | grep -n "bug" | cut -d: -f1 | \
  xargs -I{} editcmd -l {} file.py
```

#### Shell Functions

```bash
# Edit file at function definition
edit_function() {
  local -- func="$1" file="$2"
  local -- line
  line=$(grep -n "def $func" "$file" | cut -d: -f1)
  editcmd -l "$line" "$file"
}

# Edit file at class definition
edit_class() {
  local -- class="$1" file="$2"
  local -- line
  line=$(grep -n "class $class" "$file" | cut -d: -f1)
  editcmd -l "$line" "$file"
}

# Quick edit with vim
alias v='editcmd -e vim'
alias n='editcmd -e nano'
alias e='editcmd -e emacs'
```

### Print Mode (Dry-Run)

Test commands before executing using `-p`, `--print`, or `--dry-run`:

```bash
# Preview what will be executed
$ editcmd -p -l 42 script.py
vim +42 -c 'set filetype=python' script.py

# Same with --print or --dry-run
$ editcmd --print script.py
vim -c 'set filetype=python' script.py

# Use in scripts to build command strings
cmd=$(editcmd -p -e nano +50 app.js)
echo "Would execute: $cmd"

# Validate before execution
if editcmd -p script.py | grep -q "Cannot edit"; then
  echo "File is binary or invalid"
else
  editcmd script.py
fi
```

## Library Usage

The `filetype` script can be sourced as a library in your bash scripts:

```bash
#!/bin/bash
# Source the filetype script as a library
source /path/to/filetype

# Use detection functions
for file in "$@"; do
  type=$(filetype "$file")

  if [[ $type == 'binary' ]]; then
    echo "Skipping binary: $file"
    continue
  fi

  echo "Processing $type file: $file"
  # ... your processing logic
done

# Build editor commands programmatically
syntax=$(filetype 'script.py')
syntax=$(map_to_editor "$syntax" 'script.py')
cmd=$(build_editor_command 'vim' "$syntax" 'script.py' 42)
echo "Would run: $cmd"
```

## Testing

The project includes a comprehensive test suite with 450+ assertions.

### Running Tests

```bash
# Run all tests
cd tests
./run_all_tests.sh

# Run specific test suite
./test_bash.sh           # Bash implementation tests
./test_editcmd.sh        # Editcmd CLI tests
./test_library_mode.sh   # Library mode tests
```

The test suite includes:
- Extension detection tests (100+ file types)
- Special filename detection tests (Dockerfile, Makefile, dotfiles)
- Shebang parsing tests (including zsh, deno, bun, ts-node)
- MIME type detection tests
- Binary file detection tests
- Edge cases (filenames with spaces, special characters)
- Error handling tests
- Editor mapping tests (all 8 editors)
- Editcmd integration tests

## Error Handling

Consistent exit codes:

- `0` - Success
- `1` - Error (missing file, binary file, failed operations)
- `22` - Invalid arguments (invalid option, invalid editor name)

Binary files are explicitly rejected by `editcmd` to prevent data corruption.

## Bash Completion

Bash tab-completion is installed automatically by `make install` to `/etc/bash_completion.d/filetype`:

```bash
# Automatically available after installation in new shell sessions
filetype -e <TAB>        # Shows: joe nano vim emacs vscode helix micro zed
editcmd -e <TAB>         # Shows: joe nano vim emacs vscode helix micro zed

# Or source manually
source /path/to/filetype/.bash_completion
```

## Requirements

- Bash 5.2 or later
- `file` command (usually pre-installed)

## Project Structure

```
filetype/
├── filetype                 # Bash: core library + CLI + editcmd mode (~700 lines)
├── editcmd -> filetype      # Symlink: triggers editcmd CLI mode
├── .bash_completion         # Bash completion support (filetype + editcmd)
├── Makefile                 # Install/uninstall (sudo make install)
├── filetype.1               # Manpage (also covers editcmd)
├── INSTALL.md               # Installation guide
├── LICENSE                   # License file
├── README.md                # This file
└── tests/                   # Test suite (450+ assertions)
    ├── test_bash.sh
    ├── test_editcmd.sh
    └── test_library_mode.sh
```

**Key Design Principles:**
- `filetype` is library + CLI + editcmd (busybox-style `$0` dispatch)
- Single source of truth for all detection logic
- `editcmd` symlink triggers editor launcher mode via `${0##*/}`

## Contributing

Contributions are welcome! Please visit the [GitHub repository](https://github.com/Open-Technology-Foundation/filetype) to:
- Report issues
- Submit pull requests
- Suggest new features
- Improve documentation

### Development Guidelines

When modifying detection logic:

1. **Edit `filetype` First**: All detection logic lives in the `filetype` script
2. **Test Thoroughly**: Run full test suite (`cd tests && ./run_all_tests.sh`)
3. **Binary Safety**: Never allow binary files to be misidentified as text
4. **Exit Codes**: Maintain consistent exit codes (0, 1, 22)

### Reporting Issues

Please report bugs and feature requests on the [GitHub Issues](https://github.com/Open-Technology-Foundation/filetype/issues) page.

## License

See [LICENSE](LICENSE) for details.

#fin
