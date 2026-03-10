# Installation Guide

This document provides detailed installation instructions for the filetype/editcmd tools.

## Quick Installation

The recommended way to install is using the provided installation script:

```bash
cd /ai/scripts/lib/files/filetype
sudo ./install.sh
```

This will:
1. Copy `filetype` executable to `/usr/local/bin/`
2. Create `editcmd` symlink pointing to `filetype`
3. Copy `filetype-lib.sh` library to `/usr/local/bin/`
4. Set proper permissions (755 for executables, 644 for libraries)
5. Verify all files are present

## What Gets Installed

### Executables (755 permissions):
- `filetype` - Bash file type detector + editor launcher (monolith)

### Symlinks:
- `editcmd -> filetype` - Triggers editcmd CLI mode via busybox-style dispatch

### Libraries (644 permissions):
- `filetype-lib.sh` - Backward-compat stub (sources `filetype`)

## Installation Details

### Installation Strategy

The `filetype` executable and `filetype-lib.sh` library are **copied** to the install directory. The `editcmd` command is a **symlink** to `filetype`:

1. **`filetype`** is a bash monolith containing all detection logic and both CLI modes (filetype + editcmd). It uses busybox-style `$0` dispatch — when invoked as `editcmd`, it activates editor launcher mode.

2. **Simplicity**: All files in one location (`/usr/local/bin`)
3. **Reliability**: Symlink resolution is deliberate — `${0##*/}` preserves the invocation name

### Library Files in /usr/local/bin

While `/usr/local/bin` typically contains only executables, placing the library file here is acceptable because:

- **Small footprint**: Only 1 library file
- **Tight coupling**: Library is specific to these tools
- **Simple updates**: Just copy new version
- **No conflicts**: Unique filename (`filetype-lib.sh`)

## Manual Installation

If you prefer manual installation:

```bash
cd /ai/scripts/lib/files/filetype

# Copy files
sudo cp filetype filetype-lib.sh /usr/local/bin/

# Create editcmd symlink
sudo ln -sf filetype /usr/local/bin/editcmd

# Set permissions
sudo chmod 755 /usr/local/bin/filetype
sudo chmod 644 /usr/local/bin/filetype-lib.sh
```

## Alternative: Custom Installation Directory

To install to a different directory:

```bash
# Set custom directory
export INSTALL_DIR="$HOME/bin"

# Create directory if needed
mkdir -p "$INSTALL_DIR"

# Run installation
./install.sh
```

Then add to your PATH in `~/.bashrc`:

```bash
export PATH="$HOME/bin:$PATH"
```

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
filetype --version      # Should show: filetype 1.0.0
editcmd --version       # Should show: editcmd 1.0.0

# Test basic functionality
filetype README.md      # Should show: md
editcmd -p README.md    # Should show editor command
```

## Uninstallation

To uninstall:

```bash
# Remove executable and symlink
sudo rm /usr/local/bin/{filetype,editcmd}

# Remove library
sudo rm /usr/local/bin/filetype-lib.sh
```

## Updating

To update to a newer version:

```bash
cd /ai/scripts/lib/files/filetype
git pull
sudo ./install.sh
```

The installation script will overwrite existing files.

## Troubleshooting

### Permission Denied

If you get "Permission denied":

```bash
sudo ./install.sh
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

## System Requirements

- Bash 4.4 or later
- `file` command (usually pre-installed)

Check versions:
```bash
bash --version
file --version
```

#fin
