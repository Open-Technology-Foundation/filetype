#!/usr/bin/env python3
"""
editcmd - Launch editor with correct syntax highlighting and line positioning

Usage:
  editcmd [options] <filename>

Options:
  -e, --editor EDITOR   Editor to use (joe, nano, vim, emacs, vscode)
                        Default: Detects from $EDITOR environment variable,
                                 or 'vim' if not set
  -l, --line-no NUM     Jump to line NUM
  -p, --print           Print command without executing
  --dry-run             Print command without executing (same as -p)
  -h, --help            Show this help message

Arguments:
  filename - Path to file to edit

Description:
  editcmd automatically detects file types and launches your editor with
  proper syntax highlighting. It can also position the cursor at a specific
  line number.

Examples:
  editcmd script.py              # Open with auto-detected syntax
  editcmd -l 42 script.py        # Jump to line 42
  editcmd -e nano script.py      # Use nano instead of default
  editcmd --dry-run script.py    # Show command without running
  editcmd -l 100 -e vim test.c   # Multiple options

Integration Examples:
  # Jump to error line from linter
  import subprocess
  result = subprocess.run(['pylint', 'script.py'], capture_output=True, text=True)
  # Extract line number and call editcmd

  # Open file at grep match
  import subprocess
  result = subprocess.run(['grep', '-n', 'TODO', 'script.py'], capture_output=True, text=True)
  # Parse line:content and open at that line
"""

import argparse
import subprocess
import sys
import os
import shlex

# Add script directory to Python path to find filetype_lib module
# This allows the script to work when installed via copy to /usr/local/bin
script_dir = os.path.dirname(os.path.realpath(__file__))
if script_dir not in sys.path:
    sys.path.insert(0, script_dir)

# Import from library
from filetype_lib import filetype, map_to_editor, build_editor_command, detect_editor_from_env, FT_VERSION

def main():
  """Main entry point when run as a script"""
  # Pre-process arguments to handle vim-style +NUM syntax before argparse
  processed_args = []
  for arg in sys.argv[1:]:
    if arg.startswith('+') and len(arg) > 1 and arg[1:].isdigit():
      # Convert +NUM to -l NUM
      processed_args.extend(['-l', arg[1:]])
    else:
      processed_args.append(arg)

  parser = argparse.ArgumentParser(
    description='Launch editor with correct syntax highlighting and line positioning',
    add_help=False,
    exit_on_error=False
  )
  parser.add_argument('-h', '--help', action='store_true', help='Show help message')
  parser.add_argument('-V', '--version', action='store_true', help='Show version information')
  parser.add_argument('-e', '--editor', default='', choices=['', 'joe', 'nano', 'vim', 'emacs', 'vscode'],
                      help='Editor to use (default: from $EDITOR or vim)')
  parser.add_argument('-l', '--line-no', type=int, default=0, dest='line_no',
                      help='Jump to line NUM')
  parser.add_argument('-p', '--print', '--dry-run', action='store_true', dest='dry_run',
                      help='Print command without executing')
  parser.add_argument('filename', nargs='*', help='File to edit')

  try:
    args = parser.parse_args(processed_args)
  except (argparse.ArgumentError, SystemExit) as e:
    if isinstance(e, SystemExit):
      sys.exit(22)
    print(f"error: {e}", file=sys.stderr)
    sys.exit(22)

  if args.help:
    print(__doc__)
    sys.exit(0)

  if args.version:
    print(f"editcmd {FT_VERSION}")
    sys.exit(0)

  # Check if filename specified
  if not args.filename:
    print("error: No file specified", file=sys.stderr)
    print("Usage: editcmd [options] <filename>", file=sys.stderr)
    print("Try 'editcmd --help' for more information.", file=sys.stderr)
    sys.exit(1)

  # Check for multiple filenames
  if len(args.filename) > 1:
    print("error: Multiple filenames not supported. Use one file at a time.", file=sys.stderr)
    sys.exit(1)

  # Extract single filename
  args.filename = args.filename[0]

  # Validate line number
  if args.line_no < 0:
    print("error: Line number must be non-negative", file=sys.stderr)
    sys.exit(1)

  # Determine editor
  editor = args.editor if args.editor else detect_editor_from_env()
  # Only default to vim if EDITOR environment variable is not set
  # (detect_editor_from_env returns 'joe' as fallback when EDITOR is unset)
  if editor == 'joe' and not args.editor and not os.environ.get('EDITOR'):
    editor = 'vim'

  try:
    # Detect file type
    syntax, detected_bash = filetype(args.filename, return_metadata=True)

    # Map to editor-specific syntax
    syntax = map_to_editor(syntax, editor, args.filename, detected_bash)

    # Build editor command
    cmd = build_editor_command(editor, syntax, args.filename, args.line_no)

    # Execute or print command
    if args.dry_run:
      print(cmd)
    else:
      # Execute command safely using shlex.split() instead of shell=True
      # The command is already safely constructed with shlex.quote() for filename quoting
      try:
        result = subprocess.run(shlex.split(cmd), shell=False)
        sys.exit(result.returncode)
      except FileNotFoundError as e:
        print(f"error: Editor command failed: {e}", file=sys.stderr)
        sys.exit(1)

  except ValueError as e:
    print(f"error: {e}", file=sys.stderr)
    sys.exit(1)
  except Exception as e:
    print(f"error: {e}", file=sys.stderr)
    sys.exit(1)

if __name__ == '__main__':
  main()

#fin
