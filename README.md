# filetype & editcmd

A dual-tool, dual-implementation suite for file type detection and smart editor launching.

## Overview

This project provides two complementary tools:

- **`filetype`** - Detects file types and returns syntax names for editors
- **`editcmd`** - Launches editors with automatic syntax highlighting and line positioning

Both tools are available as Bash scripts and Python modules with identical functionality, sharing a common core library for zero code duplication.

## Features

- **Dual Implementation**: Choose between Bash script or Python module with identical behavior
- **Multiple Detection Methods**:
  - File extension analysis
  - Shebang line parsing for executable scripts
  - MIME type detection
  - Binary file signature checking
  - Content-based fallback analysis
- **Editor Integration**: Generate ready-to-use editor launch commands with syntax highlighting
- **Line Positioning**: Jump directly to specific line numbers when opening files in editors
- **Library Mode**: Source as Bash function or import as Python module
- **Safe Binary Handling**: Prevents accidental editing of binary files
- **Zero External Dependencies**: Only uses standard system utilities

## Supported File Types

Returns one of the following type identifiers:
- `bash` / `sh` - Bash/shell scripts
- `py` / `python` - Python files
- `php` - PHP files
- `c` - C/C++ source files
- `text` - Plain text files
- `binary` - Binary/non-text files

## Architecture

The project uses a **shared library architecture** to eliminate code duplication:

```
filetype/
├── filetype-lib.sh       # Bash core library (all detection logic)
├── filetype_lib.py       # Python core library (all detection logic)
├── filetype              # Bash CLI wrapper (detection only)
├── filetype.py           # Python CLI wrapper (detection only)
├── editcmd               # Bash CLI wrapper (editor launcher)
└── editcmd.py            # Python CLI wrapper (editor launcher)
```

Both `filetype` and `editcmd` import from the same core libraries, ensuring:
- ✅ Zero code duplication
- ✅ Consistent behavior across tools
- ✅ Single source of truth for detection logic
- ✅ Easy maintenance and testing

## Installation

The module includes a `.symlink` file for easy installation. The symlink target name is `filetype`.

### Manual Installation

```bash
# Add to PATH or create symlinks
ln -s /path/to/filetype /usr/local/bin/filetype
ln -s /path/to/filetype.py /usr/local/bin/filetype.py
ln -s /path/to/editcmd /usr/local/bin/editcmd
ln -s /path/to/editcmd.py /usr/local/bin/editcmd.py

# Or add directory to PATH
export PATH="/path/to/filetype:$PATH"
```

## Usage

### Quick Start

```bash
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

# Preview command (dry-run)
editcmd --dry-run script.py     # Shows: vim -c 'set filetype=python' script.py

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
| **Dry-run mode** | N/A | ✅ Yes (`--dry-run`) |
| **Batch mode** | ✅ Multiple files | ❌ One file at a time |
| **Executes editor** | ❌ No | ✅ Yes |

### Library Mode

#### Bash Library

```bash
# Source the script
source /path/to/filetype

# Use the function
result=$(filetype somefile.sh)
echo "$result"  # Output: bash

# In your scripts
if [[ $(filetype "$file") == "binary" ]]; then
  echo "Cannot edit binary file"
  exit 1
fi
```

#### Python Library

```python
# Import the module
from filetype import filetype

# Detect file type
result = filetype('somefile.py')
print(result)  # Output: python

# With metadata
result, detected = filetype('script.sh', return_metadata=True)
print(f"Type: {result}, Detected as: {detected}")

# Use in your code
if filetype('myfile') == 'binary':
    raise ValueError("Cannot process binary file")
```

## Command-Line Options

### filetype Options

```
filetype [options] <file> [<file2> ...]

Options:
  -e, --editor EDITOR   Return syntax name for specific editor
  -h, --help            Show help message

Supported editors: joe, nano, vim, emacs, vscode
```

### editcmd Options

```
editcmd [options] <file>

Options:
  -e, --editor EDITOR   Editor to use (default: $EDITOR or vim)
  -l, --line-no NUM     Jump to line NUM
  +NUM                  Jump to line NUM (vim-style shorthand)
  --dry-run             Show command without executing
  -h, --help            Show help message

Supported editors: joe, nano, vim, emacs, vscode
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

## Detection Logic

The detection follows this order:

1. **Extension-based detection** - Checks common file extensions (.sh, .py, .php, .c, .txt)
2. **Shebang parsing** - Reads first line for `#!/path/to/interpreter`
3. **MIME type analysis** - Uses `file -b --mime-type` command
4. **Binary detection** - Checks file signatures (ELF, PE32, Mach-O, etc.)
5. **Default fallback** - Returns 'text' for unrecognized files

**Important**: Binary files are detected before text/* MIME patterns to prevent data corruption from accidental editing attempts.

## Examples

### Basic Detection

```bash
# Detect by extension
$ filetype script.sh
bash

# Detect by shebang
$ filetype script
bash

# Binary file
$ filetype /bin/ls
binary
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

# Dry-run to see command
$ editcmd --dry-run test.py
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
script1.sh: bash
script2.sh: bash
test.py: python
main.py: python

# Detect syntax for all Python files with specific editor
$ filetype -e vim *.py
test.py: python
main.py: python
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
  local func="$1" file="$2"
  local line=$(grep -n "def $func" "$file" | cut -d: -f1)
  editcmd -l "$line" "$file"
}

# Edit file at class definition
edit_class() {
  local class="$1" file="$2"
  local line=$(grep -n "class $class" "$file" | cut -d: -f1)
  editcmd -l "$line" "$file"
}

# Quick edit with vim
alias v='editcmd -e vim'
alias n='editcmd -e nano'
alias e='editcmd -e emacs'
```

### Dry-Run Mode

Test commands before executing:

```bash
# Preview what will be executed
$ editcmd --dry-run -l 42 script.py
vim +42 -c 'set filetype=python' script.py

# Use in scripts to build command strings
cmd=$(editcmd --dry-run -e nano +50 app.js)
echo "Would execute: $cmd"

# Validate before execution
if editcmd --dry-run script.py | grep -q "Cannot edit"; then
  echo "File is binary or invalid"
else
  editcmd script.py
fi
```

## Library Usage

Both tools can be used as libraries in your scripts.

### Bash Library

```bash
#!/bin/bash
# Source the core library
source /path/to/filetype-lib.sh

# Use detection functions
for file in "$@"; do
  type=$(filetype "$file")

  if [[ $type == "binary" ]]; then
    echo "Skipping binary: $file"
    continue
  fi

  echo "Processing $type file: $file"
  # ... your processing logic
done

# Build editor commands programmatically
syntax=$(filetype "script.py")
syntax=$(map_to_editor "$syntax" "script.py")
cmd=$(build_editor_command "vim" "$syntax" "script.py" 42)
echo "Would run: $cmd"
```

### Python Library

```python
#!/usr/bin/env python3
# Import from core library
from filetype_lib import filetype, build_editor_command, map_to_editor
import sys

def process_file(filename):
    # Detect file type
    file_type, is_bash = filetype(filename, return_metadata=True)

    if file_type == 'binary':
        print(f"Skipping binary: {filename}", file=sys.stderr)
        return

    print(f"Processing {file_type} file: {filename}")
    # ... your processing logic

def build_edit_command(filename, line=0, editor='vim'):
    # Build editor command programmatically
    syntax, is_bash = filetype(filename, return_metadata=True)
    syntax = map_to_editor(syntax, editor, filename, is_bash)
    cmd = build_editor_command(editor, syntax, filename, line)
    return cmd

if __name__ == '__main__':
    for filename in sys.argv[1:]:
        process_file(filename)
```

## Testing

The project includes a comprehensive test suite with 340+ tests covering both implementations.

### Running Tests

```bash
# Run all tests
cd tests
./run_all_tests.sh

# Run specific test suite
./test_bash.sh           # Bash implementation tests
./test_python.py         # Python implementation tests (requires pytest)
./test_parity.sh         # Cross-implementation parity tests
./test_library_mode.sh   # Library mode tests
```

### Test Environment Setup

For Python tests, a virtual environment is used:

```bash
cd tests
python3 -m venv .venv
.venv/bin/pip install pytest
.venv/bin/python test_python.py
```

The test suite includes:
- Extension detection tests
- Shebang parsing tests
- MIME type detection tests
- Binary file detection tests
- Edge cases (filenames with spaces, special characters)
- Error handling tests
- Cross-implementation parity tests

## Error Handling

Both implementations use consistent exit codes:

- `0` - Success
- `1` - Error (missing file, binary file, failed operations)
- `22` - Invalid arguments (invalid option, invalid editor name)

Binary files are explicitly rejected by `editcmd` to prevent data corruption.

## Bash Completion

Bash tab-completion is available via `.bash_completion`:

```bash
source /path/to/filetype/.bash_completion

# Now you can tab-complete
filetype -e <TAB>        # Shows: joe nano vim emacs vscode
editcmd -e <TAB>         # Shows: joe nano vim emacs vscode
```

## Requirements

### Bash Implementation
- Bash 4.0 or later
- `file` command (usually pre-installed)

### Python Implementation
- Python 3.6 or later
- No external dependencies for library/CLI usage
- `pytest` for running tests (optional, test-only)

## Project Structure

```
filetype/
├── filetype-lib.sh          # Bash core library (~400 lines)
├── filetype_lib.py          # Python core library (~530 lines)
├── filetype                 # Bash detection CLI (~120 lines)
├── filetype.py              # Python detection CLI (~110 lines)
├── editcmd                  # Bash launcher CLI (~115 lines)
├── editcmd.py               # Python launcher CLI (~120 lines)
├── README.md                # This file
├── CLAUDE.md                # Development/AI assistant guidance
├── .bash_completion         # Bash completion support
└── tests/                   # Test suite (340+ tests)
    ├── test_bash.sh
    ├── test_python.py
    ├── test_parity.sh
    └── test_library_mode.sh
```

**Key Design Principles:**
- All detection logic lives in `*-lib.*` files
- CLI wrappers are thin (~100 lines each)
- Zero code duplication between bash and Python
- Both languages share identical detection algorithms

## Contributing

When modifying detection logic:

1. **Edit Libraries First**: All changes go in `filetype-lib.sh` and `filetype_lib.py`
2. **Maintain Parity**: Keep bash and Python detection identical
3. **Test Thoroughly**: Run full test suite to ensure consistency
4. **Binary Safety**: Never allow binary files to be misidentified as text
5. **Exit Codes**: Maintain consistent exit codes across implementations
6. **Update Both Tools**: If adding features, update both `filetype` and `editcmd` if applicable

## License

This is a utility library for file type detection and editor integration.

## Version

Current version: 1.0.0

#fin
