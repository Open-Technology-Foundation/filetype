# Makefile - Install filetype/editcmd tools
# BCS1212 compliant

PREFIX  ?= /usr/local
BINDIR  ?= $(PREFIX)/bin
MANDIR  ?= $(PREFIX)/share/man/man1
COMPDIR ?= /etc/bash_completion.d
DESTDIR ?=

.PHONY: all install uninstall check test help

all: help

install:
	install -d $(DESTDIR)$(BINDIR)
	install -m 755 filetype $(DESTDIR)$(BINDIR)/filetype
	ln -sf filetype $(DESTDIR)$(BINDIR)/editcmd
	install -d $(DESTDIR)$(MANDIR)
	install -m 644 filetype.1 $(DESTDIR)$(MANDIR)/filetype.1
	ln -sf filetype.1 $(DESTDIR)$(MANDIR)/editcmd.1
	@if [ -d $(DESTDIR)$(COMPDIR) ]; then \
	  install -m 644 filetype.bash_completion $(DESTDIR)$(COMPDIR)/filetype; \
	fi
	@if [ -z "$(DESTDIR)" ]; then $(MAKE) --no-print-directory check; fi

uninstall:
	rm -f $(DESTDIR)$(BINDIR)/filetype
	rm -f $(DESTDIR)$(BINDIR)/editcmd
	rm -f $(DESTDIR)$(MANDIR)/filetype.1
	rm -f $(DESTDIR)$(MANDIR)/editcmd.1
	rm -f $(DESTDIR)$(COMPDIR)/filetype

check:
	@command -v filetype >/dev/null 2>&1 \
	  && echo 'filetype: OK' \
	  || echo 'filetype: NOT FOUND (check PATH)'
	@command -v editcmd >/dev/null 2>&1 \
	  && echo 'editcmd: OK' \
	  || echo 'editcmd: NOT FOUND (check PATH)'

test:
	cd tests && ./run_all_tests.sh

help:
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Targets:'
	@echo '  install     Install to $(PREFIX)'
	@echo '  uninstall   Remove installed files'
	@echo '  check       Verify installation'
	@echo '  test        Run test suite'
	@echo '  help        Show this message'
	@echo ''
	@echo 'Install from GitHub:'
	@echo '  git clone https://github.com/Open-Technology-Foundation/filetype.git'
	@echo '  cd filetype && sudo make install'
