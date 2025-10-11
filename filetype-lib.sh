#!/usr/bin/env bash
# filetype-lib.sh - Core library for file type detection and editor command generation
#
# This library provides functions for:
# - Detecting file types based on extensions, shebangs, and MIME types
# - Mapping syntax names to editor-specific formats
# - Building editor launch commands with syntax highlighting and line positioning
#
# Usage:
#   source filetype-lib.sh
#   result=$(filetype "somefile.py")
#   cmd=$(build_editor_command "vim" "python" "file.py" 42)
#
# Functions exported:
#   - detect_editor_from_env
#   - map_to_editor
#   - build_editor_command
#   - filetype
#

# Detect editor from EDITOR environment variable
detect_editor_from_env() {
  local -- editor_path="${EDITOR:-}"
  [[ -z $editor_path ]] && { echo 'joe'; return 0; }

  # Resolve symlinks and get basename
  if [[ -e $editor_path ]]; then
    editor_path=$(readlink -fn -- "$editor_path" 2>/dev/null || echo "$editor_path")
  fi
  local -- editor_name
  editor_name=$(basename "$editor_path")

  # Map common editor names to supported types
  case "$editor_name" in
    joe|jstar|jj)           echo 'joe' ;;
    nano)                   echo 'nano' ;;
    vim|vi|nvim|neovim)     echo 'vim' ;;
    emacs|emacs-nox)        echo 'emacs' ;;
    code|code-insiders)     echo 'vscode' ;;
    *)                      echo 'joe' ;;  # Default fallback
  esac
}
declare -fx detect_editor_from_env

# Map syntax name to editor-specific name
map_to_editor() {
  local -- syntax="$1"
  local -- filename="${2:-}"
  local -- editor="${EDITOR_TYPE:-$(detect_editor_from_env)}"

  case "$editor" in
    nano)
      case "$syntax" in
        js)       echo 'javascript' ;;
        md)       echo 'markdown' ;;
        diff)     echo 'patch' ;;
        *)        echo "$syntax" ;;
      esac
      ;;
    vim)
      case "$syntax" in
        js)       echo 'javascript' ;;
        md)       echo 'markdown' ;;
        sh)
          # Check if file has bash shebang
          if [[ -f $filename ]]; then
            local -- first_line
            if read -r first_line < "$filename" 2>/dev/null; then
              case "$first_line" in
                '#!/bin/bash'|'#!/usr/bin/env bash'|'#!/usr/bin/bash')
                  echo 'bash'
                  return 0
                  ;;
              esac
            fi
          fi
          echo 'sh'
          ;;
        c)        [[ $filename == *.cpp || $filename == *.cc || $filename == *.cxx ]] && echo 'cpp' || echo 'c' ;;
        *)        echo "$syntax" ;;
      esac
      ;;
    emacs)
      case "$syntax" in
        sh|csh)   echo "${syntax}-mode" ;;
        c)
          [[ $filename == *.cpp || $filename == *.cc || $filename == *.cxx || $filename == *.hpp ]] && echo 'c++-mode' || echo 'c-mode'
          ;;
        js)       echo 'javascript-mode' ;;
        md)       echo 'markdown-mode' ;;
        xml)      echo 'nxml-mode' ;;
        diff)     echo 'diff-mode' ;;
        text|binary|directory) echo "$syntax" ;;
        *)        echo "${syntax}-mode" ;;
      esac
      ;;
    vscode)
      case "$syntax" in
        sh)       echo 'shellscript' ;;
        c)        [[ $filename == *.cpp || $filename == *.cc || $filename == *.cxx || $filename == *.hpp ]] && echo 'cpp' || echo 'c' ;;
        js)       echo 'javascript' ;;
        md)       echo 'markdown' ;;
        csh)      echo 'shellscript' ;;
        *)        echo "$syntax" ;;
      esac
      ;;
    joe|*)
      echo "$syntax"
      ;;
  esac
}
declare -fx map_to_editor

# Build full editor command with syntax highlighting
build_editor_command() {
  local -- editor="$1"
  local -- syntax="$2"
  local -- filename="$3"
  local -i line_no="${4:-0}"

  # Handle binary files and directories - don't generate edit commands
  if [[ $syntax == binary ]]; then
    echo "error: Cannot edit binary file '$filename'" >&2
    return 1
  fi
  if [[ $syntax == directory ]]; then
    echo "error: Cannot edit directory '$filename'" >&2
    return 1
  fi

  case "$editor" in
    joe)
      if ((line_no > 0)); then
        printf "joe +%d -syntax %s %q" "$line_no" "$syntax" "$filename"
      else
        printf "joe -syntax %s %q" "$syntax" "$filename"
      fi
      ;;
    nano)
      if ((line_no > 0)); then
        printf "nano +%d --syntax=%s %q" "$line_no" "$syntax" "$filename"
      else
        printf "nano --syntax=%s %q" "$syntax" "$filename"
      fi
      ;;
    vim)
      if ((line_no > 0)); then
        printf "vim +%d -c 'set filetype=%s' %q" "$line_no" "$syntax" "$filename"
      else
        printf "vim -c 'set filetype=%s' %q" "$syntax" "$filename"
      fi
      ;;
    emacs)
      if ((line_no > 0)); then
        printf "emacs +%d -eval '(%s)' %q" "$line_no" "$syntax" "$filename"
      else
        printf "emacs -eval '(%s)' %q" "$syntax" "$filename"
      fi
      ;;
    vscode)
      # Convert to absolute path for vscode URI
      # Use readlink -f to resolve symlinks and relative paths (including ..)
      local -- abs_path
      abs_path=$(readlink -f -- "$filename" 2>/dev/null || echo "$filename")
      # If readlink failed or result is not absolute, fall back to manual resolution
      if [[ $abs_path != /* ]]; then
        abs_path="$(pwd)/$filename"
      fi
      if ((line_no > 0)); then
        printf 'code --file-uri "vscode-file://vscode-app%s?language=%s#L%d"' "$abs_path" "$syntax" "$line_no"
      else
        printf 'code --file-uri "vscode-file://vscode-app%s?language=%s"' "$abs_path" "$syntax"
      fi
      ;;
    *)
      if ((line_no > 0)); then
        printf "joe +%d -syntax %s %q" "$line_no" "$syntax" "$filename"
      else
        printf "joe -syntax %s %q" "$syntax" "$filename"
      fi
      ;;
  esac
}
declare -fx build_editor_command

# Find filetype of file (returns joe editor syntax name)
filetype() {
  local -- filename="$1"
  local -- extension

  # Extract extension, handling dotfiles correctly
  # Dotfiles without additional dots (.bashrc) should have no extension
  if [[ $filename == .* && $filename != *.* ]]; then
    extension=''
  else
    extension="${filename##*.}"
  fi

  # Determine filetype from extension
  if [[ -n $extension ]]; then
    case "${extension,,}" in
      # Shell scripts
      sh|bash)                echo sh; return 0 ;;
      csh|tcsh)               echo csh; return 0 ;;

      # Scripting languages
      py)                     echo python; return 0 ;;
      pl|pm|t)                echo perl; return 0 ;;
      rb|gemspec|rabl)        echo ruby; return 0 ;;
      php)                    echo php; return 0 ;;
      awk)                    echo awk; return 0 ;;
      sed)                    echo sed; return 0 ;;
      lua)                    echo lua; return 0 ;;
      tcl)                    echo tcl; return 0 ;;

      # Web development
      js|mjs)                 echo js; return 0 ;;
      json)                   echo json; return 0 ;;
      ts|tsx)                 echo typescript; return 0 ;;
      htm|html)               echo html; return 0 ;;
      css)                    echo css; return 0 ;;
      xml|xsd|jnlp|resx)      echo xml; return 0 ;;

      # Data/config formats
      yaml|yml)               echo yaml; return 0 ;;
      ini)                    echo ini; return 0 ;;
      conf|cfg)               echo conf; return 0 ;;
      properties)             echo properties; return 0 ;;

      # Markup/documentation
      md|markdown)            echo md; return 0 ;;
      tex|sty)                echo tex; return 0 ;;

      # Compiled languages
      c|cpp|cc|cxx|h|hpp|h++|hh|mm) echo c; return 0 ;;
      java)                   echo java; return 0 ;;
      go)                     echo go; return 0 ;;
      rs)                     echo rust; return 0 ;;
      cs)                     echo csharp; return 0 ;;
      swift)                  echo swift; return 0 ;;
      scala)                  echo scala; return 0 ;;
      d)                      echo d; return 0 ;;

      # Functional languages
      hs|lhs)                 echo haskell; return 0 ;;
      erl|hrl)                echo erlang; return 0 ;;
      ex|exs)                 echo elixir; return 0 ;;
      lisp|lsp|cl)            echo lisp; return 0 ;;
      ml|mli)                 echo ocaml; return 0 ;;

      # Database
      sql)                    echo sql; return 0 ;;

      # Version control/diffs
      diff|patch)             echo diff; return 0 ;;

      # Other
      r)                      echo r; return 0 ;;
      prolog|pro)             echo prolog; return 0 ;;
      pas)                    echo pascal; return 0 ;;
      f|for|f90)              echo fortran; return 0 ;;
      cob|cbl)                echo cobol; return 0 ;;
      v|vh)                   echo verilog; return 0 ;;
      vhd|vhdl)               echo vhdl; return 0 ;;
      bat|cmd)                echo batch; return 0 ;;
      ps|eps)                 echo ps; return 0 ;;

      # Plain text
      txt|text)               echo text; return 0 ;;
    esac
  fi

  # If file 'filename' does not exist, with no recognised extension,
  # then assume filetype 'text'
  [[ -d "$filename" ]] && { echo 'directory'; return 0; }
  [[ -f "$filename" ]] || { echo 'text'; return 0; }

  # File type not determined from extension
  # Attempt to determine from #!shebang
  local -- first_line
  if ! read -r first_line < "$filename" 2>/dev/null; then
    first_line=''
  fi
  case "$first_line" in
    # Shell variants
    "#!/bin/bash"|"#!/usr/bin/env bash"|"#!/usr/bin/bash")
        echo sh; return 0 ;;
    "#!/bin/sh"|"#!/usr/bin/env sh"|"#!/usr/bin/sh")
        echo sh; return 0 ;;
    "#!/bin/csh"|"#!/usr/bin/env csh"|"#!/bin/tcsh"|"#!/usr/bin/env tcsh")
        echo csh; return 0 ;;

    # Scripting languages
    "#!/usr/bin/python"*|"#!/usr/bin/env python"*)
        echo python; return 0 ;;
    "#!/usr/bin/perl"*|"#!/usr/bin/env perl"*)
        echo perl; return 0 ;;
    "#!/usr/bin/ruby"*|"#!/usr/bin/env ruby"*)
        echo ruby; return 0 ;;
    "#!/usr/bin/php"|"#!/usr/bin/env php"|"<?php"*|"<?")
        echo php; return 0 ;;

    # Web/scripting utilities
    "#!/usr/bin/node"*|"#!/usr/bin/env node"*)
        echo js; return 0 ;;
    "#!/usr/bin/awk"*|"#!/usr/bin/env awk"*|"#!/usr/bin/gawk"*)
        echo awk; return 0 ;;
    "#!/usr/bin/sed"*|"#!/usr/bin/env sed"*)
        echo sed; return 0 ;;
    "#!/usr/bin/lua"*|"#!/usr/bin/env lua"*)
        echo lua; return 0 ;;
    "#!/usr/bin/tclsh"*|"#!/usr/bin/env tclsh"*|"#!/usr/bin/wish"*)
        echo tcl; return 0 ;;
  esac

  # filetype still not determined; use 'file' command
  local -- file_mime_type
  file_mime_type=$(file -b --mime-type "$filename")
  case "$file_mime_type" in
    # Scripts
    text/x-shellscript)        echo sh; return 0 ;;
    text/x-python)             echo python; return 0 ;;
    text/x-perl)               echo perl; return 0 ;;
    text/x-ruby)               echo ruby; return 0 ;;
    text/x-php)                echo php; return 0 ;;
    text/x-awk)                echo awk; return 0 ;;
    text/x-lua)                echo lua; return 0 ;;
    text/x-tcl)                echo tcl; return 0 ;;

    # Compiled languages
    text/x-c)                  echo c; return 0 ;;
    text/x-c++)                echo c; return 0 ;;
    text/x-java)               echo java; return 0 ;;

    # Web
    text/html)                 echo html; return 0 ;;
    text/css)                  echo css; return 0 ;;
    application/javascript)    echo js; return 0 ;;
    text/javascript)           echo js; return 0 ;;
    application/json)          echo json; return 0 ;;
    application/xml|text/xml)  echo xml; return 0 ;;

    # Data formats
    text/x-yaml)               echo yaml; return 0 ;;
    text/x-diff)               echo diff; return 0 ;;
  esac

  # CRITICAL: Check if file is binary BEFORE text/* catch-all
  # This prevents binary files with text-like MIME types from being
  # misidentified as editable text, which would cause data corruption
  local -- file_type
  file_type=$(file -b "$filename")
  # Check for specific binary signatures (NOT "data" which is too broad)
  if [[ $file_type =~ ^(ELF|PE32|Mach-O|executable) ]] || \
     [[ $file_type =~ (compiled|compressed|archive) ]] || \
     [[ $file_mime_type =~ ^(application/|image/|audio/|video/) ]]; then
    echo 'binary'
    return 0
  fi

  # Catch-all for text (after binary check)
  if [[ $file_mime_type =~ ^text/ ]]; then
    echo 'text'
    return 0
  fi

  # If we get here, assume 'text'
  echo 'text'
  return 0
}
declare -fx filetype

#fin
