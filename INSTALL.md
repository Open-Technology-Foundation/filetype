# Installation Guide

This document provides detailed installation instructions for the filetype/editcmd tools.

## Quick Installation

```bash
cd /ai/scripts/lib/files/filetype
sudo make install
```

This will:
1. Copy `filetype` executable to `/usr/local/bin/`
2. Create `editcmd` symlink pointing to `filetype`
3. Install `filetype.1` manpage to `/usr/local/share/man/man1/`
4. Create `editcmd.1` manpage symlink
5. Install bash completion to `/etc/bash_completion.d/filetype`

## What Gets Installed

### Executables (755 permissions):
- `filetype` - Bash file type detector + editor launcher (monolith)

### Symlinks:
- `editcmd -> filetype` - Triggers editcmd CLI mode via busybox-style dispatch
- `editcmd.1 -> filetype.1` - Manpage alias

### Manpages (644 permissions):
- `filetype.1` - Documents both filetype and editcmd

## Installation Details

### Installation Strategy

The `filetype` executable is **copied** to the install directory. The `editcmd` command is a **symlink** to `filetype`:

1. **`filetype`** is a bash monolith containing all detection logic and both CLI modes (filetype + editcmd). It uses busybox-style `$0` dispatch — when invoked as `editcmd`, it activates editor launcher mode.

2. **Simplicity**: All files in one location (`/usr/local/bin`)
3. **Reliability**: Symlink resolution is deliberate — `${0##*/}` preserves the invocation name
4. **Library mode**: Other scripts can `source filetype` directly to access exported functions

## Custom Installation Directory

```bash
# User-local install (no sudo needed)
make install PREFIX=$HOME/.local

# Custom prefix
sudo make install PREFIX=/opt/filetype
```

Then ensure the bin directory is in your PATH:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

## Staged Install (Packaging)

For building packages (dpkg, rpm, etc.):

```bash
make DESTDIR=/tmp/filetype-pkg install
```

This installs under `/tmp/filetype-pkg/usr/local/...` without touching the real filesystem.

## Alternative: Add to PATH (No Installation)

If you don't want to copy files system-wide:

```bash
# Add to ~/.bashrc or ~/.bash_profile
export PATH="/ai/scripts/lib/files/filetype:$PATH"
```

This works because the scripts can find their libraries when run from the source directory.

## Verification

After installation, verify all tools work:

```bash
# Check versions
filetype --version      # Should show: filetype 1.1.0
editcmd --version       # Should show: editcmd 1.1.0

# Test basic functionality
filetype README.md      # Should show: md
editcmd -p README.md    # Should show editor command

# Check manpage
man filetype
man editcmd
```

## Uninstallation

```bash
sudo make uninstall
```

This removes all installed files (executables, symlinks, library, manpages, completion).

## Updating

```bash
cd /ai/scripts/lib/files/filetype
git pull
sudo make install
```

The Makefile will overwrite existing files.

## Troubleshooting

### Permission Denied

If you get "Permission denied":

```bash
sudo make install
```

### Command Not Found After Installation

If commands aren't found:

1. Check if `/usr/local/bin` is in your PATH:
   ```bash
   echo $PATH | grep /usr/local/bin
   ```

2. If not, add to `~/.bashrc`:
   ```bash
   export PATH="/usr/local/bin:$PATH"
   ```

3. Reload shell:
   ```bash
   source ~/.bashrc
   ```

### Bash Library Not Found

If bash scripts fail to source `filetype`:

1. Verify it was installed:
   ```bash
   ls -l /usr/local/bin/filetype
   ```

2. Check permissions:
   ```bash
   ls -l /usr/local/bin/filetype
   # Should show: -rwxr-xr-x (755)
   ```

## Bash Completion

After installation, bash tab-completion is automatically available in new shell sessions:

```bash
filetype -e <TAB>        # Shows: joe nano vim emacs vscode helix micro zed
editcmd -e <TAB>         # Shows: joe nano vim emacs vscode helix micro zed
```

If `/etc/bash_completion.d/` doesn't exist on your system, source manually:

```bash
source /path/to/filetype/.bash_completion
```

## Makefile Targets

| Target | Description |
|--------|-------------|
| `install` | Install to `$(PREFIX)` (default: `/usr/local`) |
| `uninstall` | Remove all installed files |
| `test` | Run the test suite |
| `help` | Show available targets and variables |

## Makefile Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `PREFIX` | `/usr/local` | Installation prefix |
| `BINDIR` | `$(PREFIX)/bin` | Executable directory |
| `MANDIR` | `$(PREFIX)/share/man/man1` | Manpage directory |
| `COMPDIR` | `/etc/bash_completion.d` | Completion directory |
| `DESTDIR` | *(empty)* | Staging prefix for packaging |

## System Requirements

- Bash 5.2 or later
- `file` command (usually pre-installed)
- `make` and `install` (standard on all Linux systems)

Check versions:
```bash
bash --version
file --version
make --version
```

#fin
