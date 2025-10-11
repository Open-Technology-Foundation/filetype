#!/usr/bin/env python3
"""
filetype - Determine file type and return editor-specific syntax name

Usage:
  filetype [options] <filename>           # Single file
  filetype [options] <file1> <file2> ...  # Batch mode

Options:
  -e, --editor EDITOR   Return syntax name for specified editor
                        Supported: joe, nano, vim, emacs, vscode
                        Default: Detects from $EDITOR environment variable,
                                 or 'joe' if not set
  -h, --help            Show this help message

Arguments:
  filename - Path to file to analyze (may or may not exist)

Output:
  Returns editor-specific syntax name for syntax highlighting.
  joe (default): sh, python, c, js, json, md, diff, etc.
  nano:          sh, python, c, javascript, json, markdown, patch, etc.
  vim:           sh/bash, python, c/cpp, javascript, json, markdown, diff, etc.
  emacs:         sh-mode, python-mode, c-mode, javascript-mode, json-mode, markdown-mode, etc.
  vscode:        shellscript, python, c/cpp, javascript, json, markdown, diff, etc.

Detection Order:
  1. Extension matching (.sh → sh, .py → python, etc.)
  2. Shebang line inspection (#!/bin/bash → sh, etc.)
  3. MIME type analysis via file(1) command
  4. Binary file detection (ELF, PE32, Mach-O, media files)
  5. Default to 'text' if all checks fail or file doesn't exist

Examples:
  filetype script.sh                  # Returns: sh (joe default)
  filetype -e nano app.js             # Returns: javascript
  filetype -e vim README.md           # Returns: markdown
  filetype -e emacs program.py        # Returns: python-mode
  filetype -e vscode file.sh          # Returns: shellscript
  filetype -e vim file1.sh file2.js   # Returns: file1.sh: bash\\nfile2.js: javascript
  filetype /bin/ls                    # Returns: binary

Shell Function Usage:
  edit() {
    local syntax=$(filetype "$1")
    joe -syntax "$syntax" "$1"
  }
  edit script.sh  # Automatically opens with correct syntax highlighting

Note: For launching editors with syntax highlighting, see the 'editcmd' tool.
"""

import argparse
import sys
import os

# Add script directory to Python path to find filetype_lib module
# This allows the script to work when installed via copy to /usr/local/bin
script_dir = os.path.dirname(os.path.realpath(__file__))
if script_dir not in sys.path:
    sys.path.insert(0, script_dir)

# Import from library
from filetype_lib import filetype, map_to_editor, detect_editor_from_env, FT_VERSION

def main():
  """Main entry point when run as a script"""
  parser = argparse.ArgumentParser(
    description='Determine file type and return editor-specific syntax name',
    add_help=False,
    exit_on_error=False  # Prevent argparse from exiting with code 2
  )
  parser.add_argument('-h', '--help', action='store_true', help='Show help message')
  parser.add_argument('-V', '--version', action='store_true', help='Show version information')
  parser.add_argument('-e', '--editor', default='', choices=['', 'joe', 'nano', 'vim', 'emacs', 'vscode'],
                      help='Return syntax name for specified editor (default: from $EDITOR or joe)')
  parser.add_argument('files', nargs='*', help='File(s) to analyze')

  try:
    args = parser.parse_args()

  except (argparse.ArgumentError, SystemExit) as e:
    # Match bash exit code 22 (EINVAL) for argument errors (instead of argparse default 2)
    if isinstance(e, SystemExit):
      # SystemExit from argparse validation errors - exit with code 22 instead of 2
      sys.exit(22)
    print(f"error: {e}", file=sys.stderr)
    sys.exit(22)

  if args.help:
    print(__doc__)
    sys.exit(0)

  if args.version:
    print(f"filetype {FT_VERSION}")
    sys.exit(0)

  # Match bash behavior: exit 1 if no files specified
  if not args.files:
    print("error: No files specified", file=sys.stderr)
    sys.exit(1)

  try:
    # Check if multiple files provided (batch mode)
    if len(args.files) > 1:
      for filename in args.files:
        syntax, detected_bash = filetype(filename, return_metadata=True)
        result = map_to_editor(syntax, args.editor, filename, detected_bash)
        print(f"{filename}: {result}")
    else:
      # Single file mode
      syntax, detected_bash = filetype(args.files[0], return_metadata=True)
      result = map_to_editor(syntax, args.editor, args.files[0], detected_bash)
      print(result)
  except Exception as e:
    print(f"error: {e}", file=sys.stderr)
    sys.exit(1)

if __name__ == '__main__':
  main()

#fin
