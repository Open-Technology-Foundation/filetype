# Installation Guide

This document provides detailed installation instructions for the filetype/editcmd tools.

## Quick Installation

The recommended way to install is using the provided installation script:

```bash
cd /ai/scripts/lib/files/filetype
sudo ./install.sh
```

This will:
1. Copy all 4 executable files to `/usr/local/bin/`
2. Copy all 2 library files to `/usr/local/bin/`
3. Set proper permissions (755 for executables, 644 for libraries)
4. Verify all files are present

## What Gets Installed

### Executables (755 permissions):
- `filetype` - Bash file type detector
- `filetype.py` - Python file type detector
- `editcmd` - Bash editor launcher
- `editcmd.py` - Python editor launcher

### Libraries (644 permissions):
- `filetype-lib.sh` - Bash core library (~13KB)
- `filetype_lib.py` - Python core library (~14KB)

**Total size**: ~50KB

## Installation Details

### Why Copy Instead of Symlink?

The tools are designed to be installed via **copying** rather than symlinking for several reasons:

1. **Bash scripts** source their library from the same directory:
   ```bash
   SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
   source "$SCRIPT_DIR/filetype-lib.sh"
   ```

2. **Python scripts** dynamically add their directory to `sys.path`:
   ```python
   script_dir = os.path.dirname(os.path.realpath(__file__))
   sys.path.insert(0, script_dir)
   ```

3. **Simplicity**: All files in one location (`/usr/local/bin`)
4. **Reliability**: No symlink resolution issues
5. **Standard practice**: Small utility tools typically use this approach

### Library Files in /usr/local/bin

While `/usr/local/bin` typically contains only executables, placing library files here is acceptable for small tools because:

- **Small footprint**: Only 2 library files (~27KB total)
- **Tight coupling**: Libraries are specific to these tools
- **Simple updates**: Just copy new versions
- **No conflicts**: Unique filenames (`filetype-lib.sh`, `filetype_lib.py`)

For larger projects, consider using:
- `/usr/local/lib/filetype/` for bash libraries
- Python package installation via `pip` for Python libraries

## Manual Installation

If you prefer manual installation:

```bash
cd /ai/scripts/lib/files/filetype

# Copy all files
sudo cp filetype filetype.py editcmd editcmd.py \
         filetype-lib.sh filetype_lib.py \
         /usr/local/bin/

# Set executable permissions
sudo chmod 755 /usr/local/bin/{filetype,filetype.py,editcmd,editcmd.py}

# Set library permissions
sudo chmod 644 /usr/local/bin/{filetype-lib.sh,filetype_lib.py}
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

This works because both Bash and Python scripts can find their libraries when run from the source directory.

## Verification

After installation, verify all tools work:

```bash
# Check versions
filetype --version      # Should show: filetype 1.0.0
filetype.py --version   # Should show: filetype 1.0.0
editcmd --version       # Should show: editcmd 1.0.0
editcmd.py --version    # Should show: editcmd 1.0.0

# Test basic functionality
filetype README.md      # Should show: md
filetype.py install.sh  # Should show: sh
editcmd -p README.md    # Should show editor command
```

## Uninstallation

To uninstall:

```bash
# Remove executables
sudo rm /usr/local/bin/{filetype,filetype.py,editcmd,editcmd.py}

# Remove libraries
sudo rm /usr/local/bin/{filetype-lib.sh,filetype_lib.py}
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

### Python Import Errors

If Python scripts show `ModuleNotFoundError: No module named 'filetype_lib'`:

1. Verify library was installed:
   ```bash
   ls -l /usr/local/bin/filetype_lib.py
   ```

2. Check the script has the sys.path fix:
   ```bash
   grep "sys.path.insert" /usr/local/bin/filetype.py
   ```

If missing, reinstall using the latest version.

### Bash Library Not Found

If bash scripts show "filetype-lib.sh: No such file or directory":

1. Verify library was installed:
   ```bash
   ls -l /usr/local/bin/filetype-lib.sh
   ```

2. Check permissions:
   ```bash
   ls -l /usr/local/bin/filetype-lib.sh
   # Should show: -rw-r--r-- (644)
   ```

## System Requirements

### For Bash Scripts (filetype, editcmd)
- Bash 4.0 or later
- `file` command (usually pre-installed)

### For Python Scripts (filetype.py, editcmd.py)
- Python 3.6 or later
- No external dependencies

Check versions:
```bash
bash --version
python3 --version
file --version
```

#fin
