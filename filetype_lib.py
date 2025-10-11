#!/usr/bin/env python3
"""
filetype_lib - Core library for file type detection and editor command generation

This library provides functions for:
- Detecting file types based on extensions, shebangs, and MIME types
- Mapping syntax names to editor-specific formats
- Building editor launch commands with syntax highlighting and line positioning

Usage as library:
    from filetype_lib import filetype, build_editor_command

    file_type = filetype('script.py')
    cmd = build_editor_command('vim', 'python', 'script.py', 42)

Functions exported:
    - detect_editor_from_env()
    - map_to_editor()
    - build_editor_command()
    - filetype()
    - get_mime_type()
    - get_file_type()
    - check_shebang()
"""

import os
import subprocess
import sys
from pathlib import Path
from typing import Optional

# Version
FT_VERSION = "1.0.0"

# Editor syntax name mappings
EDITOR_MAPPINGS = {
    'nano': {
        'js': 'javascript',
        'md': 'markdown',
        'diff': 'patch',
    },
    'vim': {
        'js': 'javascript',
        'md': 'markdown',
    },
    'emacs': {
        'js': 'javascript-mode',
        'md': 'markdown-mode',
        'xml': 'nxml-mode',
        'diff': 'diff-mode',
    },
    'vscode': {
        'sh': 'shellscript',
        'csh': 'shellscript',
        'js': 'javascript',
        'md': 'markdown',
    }
}

def detect_editor_from_env() -> str:
    """Detect editor from EDITOR environment variable"""
    editor_path = os.environ.get('EDITOR', '')
    if not editor_path:
        return 'joe'

    # Resolve symlinks and get basename
    if os.path.exists(editor_path):
        editor_path = os.path.realpath(editor_path)
    editor_name = os.path.basename(editor_path)

    # Map common editor names to supported types
    editor_map = {
        'joe': 'joe',
        'nano': 'nano',
        'vim': 'vim',
        'vi': 'vim',
        'nvim': 'vim',
        'neovim': 'vim',
        'emacs': 'emacs',
        'emacs-nox': 'emacs',
        'code': 'vscode',
        'code-insiders': 'vscode',
    }

    return editor_map.get(editor_name, 'joe')  # Default fallback

def map_to_editor(syntax: str, editor: str = '', filename: str = '', detected_bash: bool = False) -> str:
    """Map internal syntax name to editor-specific name"""
    # Detect editor from environment if not specified
    if not editor:
        editor = detect_editor_from_env()

    if editor == 'joe':
        return syntax

    mappings = EDITOR_MAPPINGS.get(editor, {})

    # Special vim handling
    if editor == 'vim':
        if syntax == 'sh' and detected_bash:
            return 'bash'
        if syntax == 'c' and filename.endswith(('.cpp', '.cc', '.cxx', '.hpp', '.h++')):
            return 'cpp'

    # Special emacs handling
    if editor == 'emacs':
        # C++ files use c++-mode
        if syntax == 'c' and filename.endswith(('.cpp', '.cc', '.cxx', '.hpp', '.h++')):
            return 'c++-mode'
        # Most emacs modes follow <language>-mode pattern
        if syntax in ('text', 'binary', 'directory'):
            return syntax
        # Use mapping if exists, otherwise add -mode suffix
        result = mappings.get(syntax)
        if result:
            return result
        return f'{syntax}-mode'

    # Special vscode handling
    if editor == 'vscode':
        # C++ files use cpp
        if syntax == 'c' and filename.endswith(('.cpp', '.cc', '.cxx', '.hpp', '.h++')):
            return 'cpp'

    return mappings.get(syntax, syntax)

def build_editor_command(editor: str, syntax: str, filename: str, line_no: int = 0) -> str:
    """Build full editor launch command with syntax highlighting

    Args:
        editor: Editor type (joe, nano, vim, emacs, vscode)
        syntax: Editor-specific syntax name
        filename: File path to edit
        line_no: Line number to position cursor at (default: 0, meaning not specified)

    Returns:
        Full command string to launch editor with syntax

    Raises:
        ValueError: If trying to edit a binary file
    """
    import shlex
    import os

    # Handle binary files and directories - don't generate edit commands
    if syntax == "binary":
        raise ValueError(f"Cannot edit binary file '{filename}'")

    if syntax == "directory":
        raise ValueError(f"Cannot edit directory '{filename}'")

    # Use shlex.quote for safe shell quoting
    quoted_file = shlex.quote(filename)

    if editor == 'joe':
        if line_no > 0:
            return f"joe +{line_no} -syntax {syntax} {quoted_file}"
        else:
            return f"joe -syntax {syntax} {quoted_file}"
    elif editor == 'nano':
        if line_no > 0:
            return f"nano +{line_no} --syntax={syntax} {quoted_file}"
        else:
            return f"nano --syntax={syntax} {quoted_file}"
    elif editor == 'vim':
        if line_no > 0:
            return f"vim +{line_no} -c 'set filetype={syntax}' {quoted_file}"
        else:
            return f"vim -c 'set filetype={syntax}' {quoted_file}"
    elif editor == 'emacs':
        if line_no > 0:
            return f"emacs +{line_no} -eval '({syntax})' {quoted_file}"
        else:
            return f"emacs -eval '({syntax})' {quoted_file}"
    elif editor == 'vscode':
        # Convert to absolute path for vscode URI
        # Use realpath to resolve symlinks and expanduser for ~ expansion
        abs_path = os.path.realpath(os.path.expanduser(filename))
        if line_no > 0:
            return f'code --file-uri "vscode-file://vscode-app{abs_path}?language={syntax}#L{line_no}"'
        else:
            return f'code --file-uri "vscode-file://vscode-app{abs_path}?language={syntax}"'
    else:
        # Default to joe
        if line_no > 0:
            return f"joe +{line_no} -syntax {syntax} {quoted_file}"
        else:
            return f"joe -syntax {syntax} {quoted_file}"

def get_mime_type(filename: str) -> str:
  """Get MIME type of file using 'file' command"""
  try:
    result = subprocess.run(
      ['file', '-b', '--mime-type', filename],
      capture_output=True,
      text=True,
      check=True
    )
    return result.stdout.strip()
  except subprocess.CalledProcessError:
    return ""

def get_file_type(filename: str) -> str:
  """Get file type description using 'file' command"""
  try:
    result = subprocess.run(
      ['file', '-b', filename],
      capture_output=True,
      text=True,
      check=True
    )
    return result.stdout.strip()
  except subprocess.CalledProcessError:
    return ""

def check_shebang(filename: str) -> tuple[Optional[str], bool]:
  """Check file's shebang line for type hints

  Returns:
    tuple: (syntax_name, is_bash) where is_bash indicates bash-specific shebang
  """
  try:
    with open(filename, 'r', encoding='utf-8') as f:
      first_line = f.readline().strip()

    # Shell variants - bash specific
    if first_line in {
      "#!/bin/bash",
      "#!/usr/bin/env bash",
      "#!/usr/bin/bash"
    }:
      return ("sh", True)

    # Shell variants - generic sh
    if first_line in {
      "#!/bin/sh",
      "#!/usr/bin/env sh",
      "#!/usr/bin/sh"
    }:
      return ("sh", False)

    if first_line in {
      "#!/bin/csh",
      "#!/usr/bin/env csh",
      "#!/bin/tcsh",
      "#!/usr/bin/env tcsh"
    }:
      return ("csh", False)

    # Scripting languages
    if first_line.startswith(("#!/usr/bin/python", "#!/usr/bin/env python")):
      return ("python", False)

    if first_line.startswith(("#!/usr/bin/perl", "#!/usr/bin/env perl")):
      return ("perl", False)

    if first_line.startswith(("#!/usr/bin/ruby", "#!/usr/bin/env ruby")):
      return ("ruby", False)

    if first_line in {
      "#!/usr/bin/php",
      "#!/usr/bin/env php"
    } or first_line.startswith("<?php") or first_line == "<?":
      return ("php", False)

    # Web/scripting utilities
    if first_line.startswith(("#!/usr/bin/node", "#!/usr/bin/env node")):
      return ("js", False)

    if first_line.startswith(("#!/usr/bin/awk", "#!/usr/bin/env awk", "#!/usr/bin/gawk")):
      return ("awk", False)

    if first_line.startswith(("#!/usr/bin/sed", "#!/usr/bin/env sed")):
      return ("sed", False)

    if first_line.startswith(("#!/usr/bin/lua", "#!/usr/bin/env lua")):
      return ("lua", False)

    if first_line.startswith(("#!/usr/bin/tclsh", "#!/usr/bin/env tclsh", "#!/usr/bin/wish")):
      return ("tcl", False)

  except (IOError, UnicodeDecodeError):
    pass

  return (None, False)

def filetype(filename: str, return_metadata: bool = False) -> str | tuple[str, bool]:
  """
  Determine the type of a file based on extension, shebang, and content analysis.

  Args:
    filename: Path to the file to analyze
    return_metadata: If True, return (syntax, detected_bash) tuple

  Returns:
    str: Joe editor syntax name (sh, python, c, etc.) or 'text' or 'binary'
    tuple: (syntax, detected_bash) if return_metadata=True
  """
  detected_bash = False

  # Get file extension if present
  path = Path(filename)
  extension = path.suffix.lower().lstrip('.')

  # Dotfiles without additional extension should have empty extension
  if filename.startswith('.') and '.' not in path.name[1:]:
    extension = ''

  # Check extension first
  if extension:
    extension_types = {
      'sh': ['sh', 'bash'],
      'csh': ['csh', 'tcsh'],
      'python': ['py'],
      'perl': ['pl', 'pm', 't'],
      'ruby': ['rb', 'gemspec', 'rabl'],
      'php': ['php'],
      'awk': ['awk'],
      'sed': ['sed'],
      'lua': ['lua'],
      'tcl': ['tcl'],
      'js': ['js', 'mjs'],
      'json': ['json'],
      'typescript': ['ts', 'tsx'],
      'html': ['htm', 'html'],
      'css': ['css'],
      'xml': ['xml', 'xsd', 'jnlp', 'resx'],
      'yaml': ['yaml', 'yml'],
      'ini': ['ini'],
      'conf': ['conf', 'cfg'],
      'properties': ['properties'],
      'md': ['md', 'markdown'],
      'tex': ['tex', 'sty'],
      'c': ['c', 'cpp', 'cc', 'cxx', 'h', 'hpp', 'h++', 'hh', 'mm'],
      'java': ['java'],
      'go': ['go'],
      'rust': ['rs'],
      'csharp': ['cs'],
      'swift': ['swift'],
      'scala': ['scala'],
      'd': ['d'],
      'haskell': ['hs', 'lhs'],
      'erlang': ['erl', 'hrl'],
      'elixir': ['ex', 'exs'],
      'lisp': ['lisp', 'lsp', 'cl'],
      'ocaml': ['ml', 'mli'],
      'sql': ['sql'],
      'diff': ['diff', 'patch'],
      'r': ['r'],
      'prolog': ['prolog', 'pro'],
      'pascal': ['pas'],
      'fortran': ['f', 'for', 'f90'],
      'cobol': ['cob', 'cbl'],
      'verilog': ['v', 'vh'],
      'vhdl': ['vhd', 'vhdl'],
      'batch': ['bat', 'cmd'],
      'ps': ['ps', 'eps'],
      'text': ['txt', 'text']
    }

    for ftype, exts in extension_types.items():
      if extension in exts:
        # For shell scripts, check shebang to detect bash vs sh
        if ftype == 'sh' and os.path.isfile(filename):
          shebang_result = check_shebang(filename)
          if shebang_result[0] and shebang_result[1]:
            detected_bash = True
        if return_metadata:
          return (ftype, detected_bash)
        return ftype

  # If path is a directory, return 'directory'
  if os.path.isdir(filename):
    if return_metadata:
      return ('directory', detected_bash)
    return 'directory'

  # If file doesn't exist and no recognized extension, assume text
  if not os.path.isfile(filename):
    if return_metadata:
      return ('text', detected_bash)
    return 'text'

  # Check shebang
  shebang_result = check_shebang(filename)
  if shebang_result[0]:
    detected_bash = shebang_result[1]
    if return_metadata:
      return (shebang_result[0], detected_bash)
    return shebang_result[0]

  # Check MIME type
  mime_type = get_mime_type(filename)
  if mime_type:
    mime_map = {
      # Scripts
      'text/x-shellscript': 'sh',
      'text/x-python': 'python',
      'text/x-perl': 'perl',
      'text/x-ruby': 'ruby',
      'text/x-php': 'php',
      'text/x-awk': 'awk',
      'text/x-lua': 'lua',
      'text/x-tcl': 'tcl',
      # Compiled languages
      'text/x-c': 'c',
      'text/x-c++': 'c',
      'text/x-java': 'java',
      # Web
      'text/html': 'html',
      'text/css': 'css',
      'application/javascript': 'js',
      'text/javascript': 'js',
      'application/json': 'json',
      'application/xml': 'xml',
      'text/xml': 'xml',
      # Data formats
      'text/x-yaml': 'yaml',
      'text/x-diff': 'diff'
    }

    if mime_type in mime_map:
      if return_metadata:
        return (mime_map[mime_type], detected_bash)
      return mime_map[mime_type]

  # CRITICAL: Check if binary BEFORE text/* catch-all
  # This prevents binary files with text-like MIME types from being
  # misidentified as editable text, which would cause data corruption
  file_type = get_file_type(filename)
  # Check for specific binary signatures (NOT "data" or "binary" which are too broad)
  import re
  binary_patterns = (r'^ELF', r'^PE32', r'^Mach-O', r'^executable', r'compiled', r'compressed', r'archive')
  binary_mime_prefixes = ('application/', 'image/', 'audio/', 'video/')

  if (any(re.search(pattern, file_type) for pattern in binary_patterns) or
      any(mime_type.startswith(prefix) for prefix in binary_mime_prefixes)):
    if return_metadata:
      return ('binary', detected_bash)
    return 'binary'

  # Catch-all for text (after binary check)
  if mime_type and mime_type.startswith('text/'):
    if return_metadata:
      return ('text', detected_bash)
    return 'text'

  # Default to text
  if return_metadata:
    return ('text', detected_bash)
  return 'text'

#fin
