#!/usr/bin/env bash
# install.sh - Install filetype/editcmd tools to /usr/local/bin
#
# This script copies all necessary files to /usr/local/bin for system-wide access.
# Both bash and Python versions are installed, along with their required library files.

set -euo pipefail
shopt -s inherit_errexit

# Script metadata
VERSION='1.0.0'
SCRIPT_PATH=$(readlink -en -- "$0" 2>/dev/null || realpath "$0")
SCRIPT_DIR=${SCRIPT_PATH%/*}
SCRIPT_NAME=${SCRIPT_PATH##*/}
readonly -- VERSION SCRIPT_PATH SCRIPT_DIR SCRIPT_NAME

# Installation configuration
INSTALL_DIR="${INSTALL_DIR:-/usr/local/bin}"
readonly -- INSTALL_DIR

# Color definitions
if [[ -t 1 && -t 2 ]]; then
  declare -- RED=$'\033[0;31m' GREEN=$'\033[0;32m' YELLOW=$'\033[1;33m' NC=$'\033[0m'
else
  declare -- RED='' GREEN='' YELLOW='' NC=''
fi
readonly -- RED GREEN YELLOW NC

# Files to install
declare -a EXECUTABLES=(
  'filetype'
  'filetype.py'
  'editcmd'
  'editcmd.py'
)
readonly -a EXECUTABLES

declare -a LIBRARIES=(
  'filetype-lib.sh'
  'filetype_lib.py'
)
readonly -a LIBRARIES

# Core message function
_msg() {
  local -- prefix="$SCRIPT_NAME:" msg
  case "${FUNCNAME[1]}" in
    success) prefix+=" ${GREEN}✓${NC}" ;;
    error)   prefix+=" ${RED}✗${NC}" ;;
    info)    prefix+=" ${YELLOW}Note:${NC}" ;;
    *)       ;;
  esac
  for msg in "$@"; do printf '%s %s\n' "$prefix" "$msg"; done
}

# Messaging functions
success() { _msg "$@"; }
error() { >&2 _msg "$@"; }
info() { >&2 _msg "$@"; }
die() { (($# > 1)) && error "${@:2}"; exit "${1:-0}"; }

# Check if file exists
check_file() {
  local -- file="$1"
  if [[ ! -f "$SCRIPT_DIR/$file" ]]; then
    error "Missing: $file"
    return 1
  fi
  success "Found: $file"
  return 0
}

# Verify all required files exist
verify_files() {
  local -i missing=0
  local -- file

  echo 'Checking files...'

  for file in "${EXECUTABLES[@]}" "${LIBRARIES[@]}"; do
    check_file "$file" || missing=1
  done

  if ((missing)); then
    echo ''
    die 1 'Some files are missing. Cannot proceed with installation.'
  fi
}

# Install executable file
install_executable() {
  local -- file="$1"
  [[ -L "$INSTALL_DIR/$file" ]] && rm "$INSTALL_DIR/$file"
  cp "$SCRIPT_DIR/$file" "$INSTALL_DIR/$file"
  chmod 755 "$INSTALL_DIR/$file"
  success "Installed: $INSTALL_DIR/$file"
}

# Install library file
install_library() {
  local -- file="$1"
  [[ -L "$INSTALL_DIR/$file" ]] && rm "$INSTALL_DIR/$file"
  cp "$SCRIPT_DIR/$file" "$INSTALL_DIR/$file"
  chmod 644 "$INSTALL_DIR/$file"
  success "Installed: $INSTALL_DIR/$file"
}

# Main installation function
main() {
  echo '======================================================================'
  echo '  filetype/editcmd Installation'
  echo '======================================================================'
  echo ''
  echo "Installing to: $INSTALL_DIR"
  echo ''

  # Check if running as root or with sudo
  if [[ $EUID -ne 0 && ! -w "$INSTALL_DIR" ]]; then
    info "$INSTALL_DIR requires elevated privileges"
    echo 'Please run with sudo or as root:'
    echo "  sudo $0"
    die 1
  fi

  # Verify all files exist
  verify_files

  echo ''
  echo 'Installing files...'

  # Install executables
  local -- file
  for file in "${EXECUTABLES[@]}"; do
    install_executable "$file"
  done

  # Install libraries
  for file in "${LIBRARIES[@]}"; do
    install_library "$file"
  done

  echo ''
  echo '======================================================================'
  echo '  Installation Complete!'
  echo '======================================================================'
  echo ''
  echo 'Installed executables:'
  for file in "${EXECUTABLES[@]}"; do
    echo "  - $file"
  done
  echo ''
  echo 'Installed libraries:'
  for file in "${LIBRARIES[@]}"; do
    echo "  - $file"
  done
  echo ''
  echo 'Verify installation:'
  echo '  filetype --version'
  echo '  filetype.py --version'
  echo '  editcmd --version'
  echo '  editcmd.py --version'
  echo ''
  echo 'Usage examples:'
  echo '  filetype script.py              # Detect file type'
  echo '  filetype -e nano app.js         # Get nano-specific syntax'
  echo '  editcmd script.py               # Open in editor with syntax'
  echo '  editcmd -l 42 app.js            # Jump to line 42'
  echo ''
}

main "$@"
#fin
