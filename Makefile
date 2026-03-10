# Makefile - Install filetype/editcmd tools
#
# Usage:
#   sudo make install          # Install to /usr/local
#   sudo make uninstall        # Remove installed files
#   make install PREFIX=~/.local  # User-local install (no sudo)
#   make DESTDIR=/tmp/pkg install # Staged install for packaging

REPO_URL := https://github.com/Open-Technology-Foundation/filetype.git
VERSION  := 1.1.0

# Standard GNU directory variables
PREFIX  ?= /usr/local
BINDIR  ?= $(PREFIX)/bin
MANDIR  ?= $(PREFIX)/share/man/man1
COMPDIR ?= /etc/bash_completion.d

# Staging prefix for package builders
DESTDIR ?=

# Source files
EXECUTABLE   := filetype
MANPAGE      := filetype.1
COMPLETION   := .bash_completion

.PHONY: all install uninstall check test help

all: help

install:
	@echo '======================================================================'
	@echo '  filetype/editcmd Installation v$(VERSION)'
	@echo '======================================================================'
	@echo ''
	install -d $(DESTDIR)$(BINDIR)
	install -d $(DESTDIR)$(MANDIR)
	install -m 755 $(EXECUTABLE) $(DESTDIR)$(BINDIR)/filetype
	ln -sf filetype $(DESTDIR)$(BINDIR)/editcmd
	install -m 644 $(MANPAGE) $(DESTDIR)$(MANDIR)/filetype.1
	ln -sf filetype.1 $(DESTDIR)$(MANDIR)/editcmd.1
	@if [ -d $(DESTDIR)$(COMPDIR) ]; then \
	  install -m 644 $(COMPLETION) $(DESTDIR)$(COMPDIR)/filetype; \
	  echo "install -m 644 $(COMPLETION) $(DESTDIR)$(COMPDIR)/filetype"; \
	else \
	  echo "Note: Skipping bash completion ($(COMPDIR) not found)"; \
	fi
	@echo ''
	@echo 'Installed:'
	@echo '  $(DESTDIR)$(BINDIR)/filetype'
	@echo '  $(DESTDIR)$(BINDIR)/editcmd -> filetype'
	@echo '  $(DESTDIR)$(MANDIR)/filetype.1'
	@echo '  $(DESTDIR)$(MANDIR)/editcmd.1 -> filetype.1'
	@echo ''
	@if [ -z "$(DESTDIR)" ]; then \
	  $(MAKE) --no-print-directory check; \
	fi

uninstall:
	rm -f $(DESTDIR)$(BINDIR)/filetype
	rm -f $(DESTDIR)$(BINDIR)/editcmd
	rm -f $(DESTDIR)$(MANDIR)/filetype.1
	rm -f $(DESTDIR)$(MANDIR)/editcmd.1
	rm -f $(DESTDIR)$(COMPDIR)/filetype
	@echo 'Uninstalled filetype/editcmd'

check:
	@echo 'Verifying installation...'
	@if command -v filetype >/dev/null 2>&1; then \
	  echo "  filetype $(shell $(BINDIR)/filetype --version 2>/dev/null | head -1)  OK"; \
	else \
	  echo "  WARN: filetype not found in PATH"; \
	  echo "  Ensure $(BINDIR) is in your PATH"; \
	fi
	@if command -v editcmd >/dev/null 2>&1; then \
	  echo "  editcmd  OK"; \
	else \
	  echo "  WARN: editcmd not found in PATH"; \
	fi
	@if man -w filetype >/dev/null 2>&1; then \
	  echo "  man filetype  OK"; \
	else \
	  echo "  WARN: manpage not found (try: sudo mandb)"; \
	fi
	@echo ''

test:
	cd tests && ./run_all_tests.sh

help:
	@echo 'filetype $(VERSION)'
	@echo ''
	@echo 'Targets:'
	@echo '  install     Install to $(PREFIX)'
	@echo '  uninstall   Remove installed files'
	@echo '  check       Verify installation'
	@echo '  test        Run test suite'
	@echo '  help        Show this message'
	@echo ''
	@echo 'Variables:'
	@echo '  PREFIX=$(PREFIX)'
	@echo '  BINDIR=$(BINDIR)'
	@echo '  MANDIR=$(MANDIR)'
	@echo '  COMPDIR=$(COMPDIR)'
	@echo '  DESTDIR=$(DESTDIR)'
	@echo ''
	@echo 'Install from GitHub:'
	@echo '  git clone $(REPO_URL)'
	@echo '  cd filetype && sudo make install'
