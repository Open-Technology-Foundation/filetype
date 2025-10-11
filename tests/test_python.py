#!/usr/bin/env python3
"""
test_python.py - Comprehensive test suite for Python filetype implementation
Tests ~500+ assertions matching the bash test suite
"""
import sys
from pathlib import Path

# Use venv pytest if available
venv_python = Path(__file__).parent / ".venv" / "bin" / "python3"
if venv_python.exists() and Path(sys.executable).resolve() != venv_python.resolve():
    import os
    os.execv(str(venv_python), [str(venv_python)] + sys.argv)

import pytest
import subprocess
import os
from pathlib import Path

# Path to filetype.py script
SCRIPT_DIR = Path(__file__).parent
FILETYPE_PY = SCRIPT_DIR.parent / "filetype.py"


def run_filetype(*args, expect_error=False):
    """Helper to run filetype.py and return output"""
    result = subprocess.run(
        ["python3", str(FILETYPE_PY)] + list(args),
        capture_output=True,
        text=True
    )
    if not expect_error and result.returncode != 0:
        pytest.fail(f"filetype.py failed: {result.stderr}")
    return result.stdout.strip(), result.returncode


class TestExtensions:
    """Test all 80+ file extensions"""

    def test_shell_scripts(self):
        assert run_filetype("fixtures/extensions/test.sh")[0] == "sh"
        assert run_filetype("fixtures/extensions/test.bash")[0] == "sh"
        assert run_filetype("fixtures/extensions/test.csh")[0] == "csh"
        assert run_filetype("fixtures/extensions/test.tcsh")[0] == "csh"

    def test_scripting_languages(self):
        assert run_filetype("fixtures/extensions/test.py")[0] == "python"
        assert run_filetype("fixtures/extensions/test.pl")[0] == "perl"
        assert run_filetype("fixtures/extensions/test.pm")[0] == "perl"
        assert run_filetype("fixtures/extensions/test.t")[0] == "perl"
        assert run_filetype("fixtures/extensions/test.rb")[0] == "ruby"
        assert run_filetype("fixtures/extensions/test.gemspec")[0] == "ruby"
        assert run_filetype("fixtures/extensions/test.rabl")[0] == "ruby"
        assert run_filetype("fixtures/extensions/test.php")[0] == "php"
        assert run_filetype("fixtures/extensions/test.awk")[0] == "awk"
        assert run_filetype("fixtures/extensions/test.sed")[0] == "sed"
        assert run_filetype("fixtures/extensions/test.lua")[0] == "lua"
        assert run_filetype("fixtures/extensions/test.tcl")[0] == "tcl"

    def test_web_development(self):
        assert run_filetype("fixtures/extensions/test.js")[0] == "js"
        assert run_filetype("fixtures/extensions/test.mjs")[0] == "js"
        assert run_filetype("fixtures/extensions/test.json")[0] == "json"
        assert run_filetype("fixtures/extensions/test.ts")[0] == "typescript"
        assert run_filetype("fixtures/extensions/test.tsx")[0] == "typescript"
        assert run_filetype("fixtures/extensions/test.htm")[0] == "html"
        assert run_filetype("fixtures/extensions/test.html")[0] == "html"
        assert run_filetype("fixtures/extensions/test.css")[0] == "css"
        assert run_filetype("fixtures/extensions/test.xml")[0] == "xml"
        assert run_filetype("fixtures/extensions/test.xsd")[0] == "xml"
        assert run_filetype("fixtures/extensions/test.jnlp")[0] == "xml"
        assert run_filetype("fixtures/extensions/test.resx")[0] == "xml"

    def test_data_config_formats(self):
        assert run_filetype("fixtures/extensions/test.yaml")[0] == "yaml"
        assert run_filetype("fixtures/extensions/test.yml")[0] == "yaml"
        assert run_filetype("fixtures/extensions/test.ini")[0] == "ini"
        assert run_filetype("fixtures/extensions/test.conf")[0] == "conf"
        assert run_filetype("fixtures/extensions/test.cfg")[0] == "conf"
        assert run_filetype("fixtures/extensions/test.properties")[0] == "properties"

    def test_markup_documentation(self):
        assert run_filetype("fixtures/extensions/test.md")[0] == "md"
        assert run_filetype("fixtures/extensions/test.markdown")[0] == "md"
        assert run_filetype("fixtures/extensions/test.tex")[0] == "tex"
        assert run_filetype("fixtures/extensions/test.sty")[0] == "tex"

    def test_compiled_languages(self):
        assert run_filetype("fixtures/extensions/test.c")[0] == "c"
        assert run_filetype("fixtures/extensions/test.cpp")[0] == "c"
        assert run_filetype("fixtures/extensions/test.cc")[0] == "c"
        assert run_filetype("fixtures/extensions/test.cxx")[0] == "c"
        assert run_filetype("fixtures/extensions/test.h")[0] == "c"
        assert run_filetype("fixtures/extensions/test.hpp")[0] == "c"
        assert run_filetype("fixtures/extensions/test.h++")[0] == "c"
        assert run_filetype("fixtures/extensions/test.hh")[0] == "c"
        assert run_filetype("fixtures/extensions/test.mm")[0] == "c"
        assert run_filetype("fixtures/extensions/test.java")[0] == "java"
        assert run_filetype("fixtures/extensions/test.go")[0] == "go"
        assert run_filetype("fixtures/extensions/test.rs")[0] == "rust"
        assert run_filetype("fixtures/extensions/test.cs")[0] == "csharp"
        assert run_filetype("fixtures/extensions/test.swift")[0] == "swift"
        assert run_filetype("fixtures/extensions/test.scala")[0] == "scala"
        assert run_filetype("fixtures/extensions/test.d")[0] == "d"

    def test_functional_languages(self):
        assert run_filetype("fixtures/extensions/test.hs")[0] == "haskell"
        assert run_filetype("fixtures/extensions/test.lhs")[0] == "haskell"
        assert run_filetype("fixtures/extensions/test.erl")[0] == "erlang"
        assert run_filetype("fixtures/extensions/test.hrl")[0] == "erlang"
        assert run_filetype("fixtures/extensions/test.ex")[0] == "elixir"
        assert run_filetype("fixtures/extensions/test.exs")[0] == "elixir"
        assert run_filetype("fixtures/extensions/test.lisp")[0] == "lisp"
        assert run_filetype("fixtures/extensions/test.lsp")[0] == "lisp"
        assert run_filetype("fixtures/extensions/test.cl")[0] == "lisp"
        assert run_filetype("fixtures/extensions/test.ml")[0] == "ocaml"
        assert run_filetype("fixtures/extensions/test.mli")[0] == "ocaml"

    def test_database(self):
        assert run_filetype("fixtures/extensions/test.sql")[0] == "sql"

    def test_version_control(self):
        assert run_filetype("fixtures/extensions/test.diff")[0] == "diff"
        assert run_filetype("fixtures/extensions/test.patch")[0] == "diff"

    def test_other_languages(self):
        assert run_filetype("fixtures/extensions/test.r")[0] == "r"
        assert run_filetype("fixtures/extensions/test.prolog")[0] == "prolog"
        assert run_filetype("fixtures/extensions/test.pro")[0] == "prolog"
        assert run_filetype("fixtures/extensions/test.pas")[0] == "pascal"
        assert run_filetype("fixtures/extensions/test.f")[0] == "fortran"
        assert run_filetype("fixtures/extensions/test.for")[0] == "fortran"
        assert run_filetype("fixtures/extensions/test.f90")[0] == "fortran"
        assert run_filetype("fixtures/extensions/test.cob")[0] == "cobol"
        assert run_filetype("fixtures/extensions/test.cbl")[0] == "cobol"
        assert run_filetype("fixtures/extensions/test.v")[0] == "verilog"
        assert run_filetype("fixtures/extensions/test.vh")[0] == "verilog"
        assert run_filetype("fixtures/extensions/test.vhd")[0] == "vhdl"
        assert run_filetype("fixtures/extensions/test.vhdl")[0] == "vhdl"
        assert run_filetype("fixtures/extensions/test.bat")[0] == "batch"
        assert run_filetype("fixtures/extensions/test.cmd")[0] == "batch"
        assert run_filetype("fixtures/extensions/test.ps")[0] == "ps"
        assert run_filetype("fixtures/extensions/test.eps")[0] == "ps"

    def test_plain_text(self):
        assert run_filetype("fixtures/extensions/test.txt")[0] == "text"
        assert run_filetype("fixtures/extensions/test.text")[0] == "text"


class TestShebangs:
    """Test shebang detection"""

    def test_shell_variants(self):
        assert run_filetype("fixtures/shebangs/bash1")[0] == "sh"
        assert run_filetype("fixtures/shebangs/bash2")[0] == "sh"
        assert run_filetype("fixtures/shebangs/bash3")[0] == "sh"
        assert run_filetype("fixtures/shebangs/sh1")[0] == "sh"
        assert run_filetype("fixtures/shebangs/sh2")[0] == "sh"
        assert run_filetype("fixtures/shebangs/sh3")[0] == "sh"
        assert run_filetype("fixtures/shebangs/csh1")[0] == "csh"
        assert run_filetype("fixtures/shebangs/csh2")[0] == "csh"
        assert run_filetype("fixtures/shebangs/tcsh1")[0] == "csh"
        assert run_filetype("fixtures/shebangs/tcsh2")[0] == "csh"

    def test_scripting_languages(self):
        assert run_filetype("fixtures/shebangs/python1")[0] == "python"
        assert run_filetype("fixtures/shebangs/python2")[0] == "python"
        assert run_filetype("fixtures/shebangs/python3")[0] == "python"
        assert run_filetype("fixtures/shebangs/perl1")[0] == "perl"
        assert run_filetype("fixtures/shebangs/perl2")[0] == "perl"
        assert run_filetype("fixtures/shebangs/ruby1")[0] == "ruby"
        assert run_filetype("fixtures/shebangs/ruby2")[0] == "ruby"
        assert run_filetype("fixtures/shebangs/php1")[0] == "php"
        assert run_filetype("fixtures/shebangs/php2")[0] == "php"
        assert run_filetype("fixtures/shebangs/php3")[0] == "php"

    def test_web_utilities(self):
        assert run_filetype("fixtures/shebangs/node1")[0] == "js"
        assert run_filetype("fixtures/shebangs/node2")[0] == "js"
        assert run_filetype("fixtures/shebangs/awk1")[0] == "awk"
        assert run_filetype("fixtures/shebangs/awk2")[0] == "awk"
        assert run_filetype("fixtures/shebangs/gawk")[0] == "awk"
        assert run_filetype("fixtures/shebangs/sed1")[0] == "sed"
        assert run_filetype("fixtures/shebangs/sed2")[0] == "sed"
        assert run_filetype("fixtures/shebangs/lua1")[0] == "lua"
        assert run_filetype("fixtures/shebangs/lua2")[0] == "lua"
        assert run_filetype("fixtures/shebangs/tclsh1")[0] == "tcl"
        assert run_filetype("fixtures/shebangs/tclsh2")[0] == "tcl"
        assert run_filetype("fixtures/shebangs/wish")[0] == "tcl"


class TestEditorMappings:
    """Test editor-specific syntax mappings"""

    def test_joe_passthrough(self):
        """Joe editor uses passthrough (no mapping)"""
        assert run_filetype("-e", "joe", "fixtures/extensions/test.sh")[0] == "sh"
        assert run_filetype("-e", "joe", "fixtures/extensions/test.py")[0] == "python"
        assert run_filetype("-e", "joe", "fixtures/extensions/test.cpp")[0] == "c"
        assert run_filetype("-e", "joe", "fixtures/extensions/test.js")[0] == "js"
        assert run_filetype("-e", "joe", "fixtures/extensions/test.md")[0] == "md"
        assert run_filetype("-e", "joe", "fixtures/extensions/test.diff")[0] == "diff"
        assert run_filetype("-e", "joe", "fixtures/extensions/test.xml")[0] == "xml"

    def test_nano_mappings(self):
        """Nano specific mappings"""
        assert run_filetype("-e", "nano", "fixtures/extensions/test.sh")[0] == "sh"
        assert run_filetype("-e", "nano", "fixtures/extensions/test.py")[0] == "python"
        assert run_filetype("-e", "nano", "fixtures/extensions/test.c")[0] == "c"
        assert run_filetype("-e", "nano", "fixtures/extensions/test.js")[0] == "javascript"
        assert run_filetype("-e", "nano", "fixtures/extensions/test.md")[0] == "markdown"
        assert run_filetype("-e", "nano", "fixtures/extensions/test.diff")[0] == "patch"
        assert run_filetype("-e", "nano", "fixtures/extensions/test.xml")[0] == "xml"

    def test_vim_mappings(self):
        """Vim specific mappings including bash and C++ detection"""
        assert run_filetype("-e", "vim", "fixtures/extensions/test.sh")[0] == "sh"
        assert run_filetype("-e", "vim", "fixtures/edge_cases/has_ext.sh")[0] == "bash"
        assert run_filetype("-e", "vim", "fixtures/extensions/test.py")[0] == "python"
        assert run_filetype("-e", "vim", "fixtures/extensions/test.c")[0] == "c"
        assert run_filetype("-e", "vim", "fixtures/extensions/test.cpp")[0] == "cpp"
        assert run_filetype("-e", "vim", "fixtures/extensions/test.cc")[0] == "cpp"
        assert run_filetype("-e", "vim", "fixtures/extensions/test.cxx")[0] == "cpp"
        assert run_filetype("-e", "vim", "fixtures/extensions/test.js")[0] == "javascript"
        assert run_filetype("-e", "vim", "fixtures/extensions/test.md")[0] == "markdown"
        assert run_filetype("-e", "vim", "fixtures/extensions/test.diff")[0] == "diff"

    def test_emacs_mappings(self):
        """Emacs specific mappings with -mode suffix"""
        assert run_filetype("-e", "emacs", "fixtures/extensions/test.sh")[0] == "sh-mode"
        assert run_filetype("-e", "emacs", "fixtures/extensions/test.csh")[0] == "csh-mode"
        assert run_filetype("-e", "emacs", "fixtures/extensions/test.py")[0] == "python-mode"
        assert run_filetype("-e", "emacs", "fixtures/extensions/test.c")[0] == "c-mode"
        assert run_filetype("-e", "emacs", "fixtures/extensions/test.cpp")[0] == "c++-mode"
        assert run_filetype("-e", "emacs", "fixtures/extensions/test.cc")[0] == "c++-mode"
        assert run_filetype("-e", "emacs", "fixtures/extensions/test.cxx")[0] == "c++-mode"
        assert run_filetype("-e", "emacs", "fixtures/extensions/test.hpp")[0] == "c++-mode"
        assert run_filetype("-e", "emacs", "fixtures/extensions/test.js")[0] == "javascript-mode"
        assert run_filetype("-e", "emacs", "fixtures/extensions/test.md")[0] == "markdown-mode"
        assert run_filetype("-e", "emacs", "fixtures/extensions/test.xml")[0] == "nxml-mode"
        assert run_filetype("-e", "emacs", "fixtures/extensions/test.diff")[0] == "diff-mode"
        assert run_filetype("-e", "emacs", "fixtures/extensions/test.java")[0] == "java-mode"
        assert run_filetype("-e", "emacs", "fixtures/extensions/test.rs")[0] == "rust-mode"
        assert run_filetype("-e", "emacs", "fixtures/extensions/test.txt")[0] == "text"
        assert run_filetype("-e", "emacs", "fixtures/binary/elf_test")[0] == "binary"

    def test_vscode_mappings(self):
        """VSCode specific mappings"""
        assert run_filetype("-e", "vscode", "fixtures/extensions/test.sh")[0] == "shellscript"
        assert run_filetype("-e", "vscode", "fixtures/extensions/test.csh")[0] == "shellscript"
        assert run_filetype("-e", "vscode", "fixtures/extensions/test.py")[0] == "python"
        assert run_filetype("-e", "vscode", "fixtures/extensions/test.c")[0] == "c"
        assert run_filetype("-e", "vscode", "fixtures/extensions/test.cpp")[0] == "cpp"
        assert run_filetype("-e", "vscode", "fixtures/extensions/test.cc")[0] == "cpp"
        assert run_filetype("-e", "vscode", "fixtures/extensions/test.cxx")[0] == "cpp"
        assert run_filetype("-e", "vscode", "fixtures/extensions/test.hpp")[0] == "cpp"
        assert run_filetype("-e", "vscode", "fixtures/extensions/test.js")[0] == "javascript"
        assert run_filetype("-e", "vscode", "fixtures/extensions/test.md")[0] == "markdown"


class TestEditorEnvironmentVariable:
    """Test EDITOR environment variable detection"""

    def test_no_editor_set(self):
        """No EDITOR → defaults to joe"""
        env = os.environ.copy()
        if 'EDITOR' in env:
            del env['EDITOR']
        result = subprocess.run(
            ["python3", str(FILETYPE_PY), "fixtures/extensions/test.js"],
            capture_output=True, text=True, env=env
        )
        assert result.stdout.strip() == "js"

    def test_editor_vim_variants(self):
        """EDITOR=vim/vi/nvim → vim mappings"""
        for editor in ['vim', 'vi', 'nvim']:
            env = os.environ.copy()
            env['EDITOR'] = editor
            result = subprocess.run(
                ["python3", str(FILETYPE_PY), "fixtures/extensions/test.js"],
                capture_output=True, text=True, env=env
            )
            assert result.stdout.strip() == "javascript", f"EDITOR={editor} failed"

    def test_editor_emacs(self):
        """EDITOR=emacs → emacs mappings"""
        env = os.environ.copy()
        env['EDITOR'] = "emacs"
        result = subprocess.run(
            ["python3", str(FILETYPE_PY), "fixtures/extensions/test.py"],
            capture_output=True, text=True, env=env
        )
        assert result.stdout.strip() == "python-mode"

    def test_editor_vscode(self):
        """EDITOR=code → vscode mappings"""
        for editor in ['code', 'code-insiders']:
            env = os.environ.copy()
            env['EDITOR'] = editor
            result = subprocess.run(
                ["python3", str(FILETYPE_PY), "fixtures/extensions/test.sh"],
                capture_output=True, text=True, env=env
            )
            assert result.stdout.strip() == "shellscript", f"EDITOR={editor} failed"

    def test_editor_unknown_fallback(self):
        """EDITOR=unknown → fallback to joe"""
        env = os.environ.copy()
        env['EDITOR'] = "unknown"
        result = subprocess.run(
            ["python3", str(FILETYPE_PY), "fixtures/extensions/test.js"],
            capture_output=True, text=True, env=env
        )
        assert result.stdout.strip() == "js"


class TestOptionPriority:
    """Test that -e flag overrides EDITOR variable"""

    def test_e_flag_overrides_editor(self):
        """Test -e flag takes priority over EDITOR"""
        env = os.environ.copy()
        env['EDITOR'] = "vim"
        result = subprocess.run(
            ["python3", str(FILETYPE_PY), "-e", "joe", "fixtures/extensions/test.js"],
            capture_output=True, text=True, env=env
        )
        assert result.stdout.strip() == "js"


class TestEdgeCases:
    """Test edge cases and special scenarios"""

    def test_dotfiles(self):
        """Dotfiles without extension"""
        assert run_filetype("fixtures/edge_cases/.bashrc")[0] == "text"
        assert run_filetype("fixtures/edge_cases/.vimrc")[0] == "text"
        assert run_filetype("fixtures/edge_cases/.gitignore")[0] == "text"
        assert run_filetype("fixtures/edge_cases/.bash_history.txt")[0] == "text"

    def test_multiple_extensions(self):
        """Files with multiple extensions - last one wins"""
        assert run_filetype("fixtures/edge_cases/archive.tar.gz")[0] == "text"
        assert run_filetype("fixtures/edge_cases/script.min.js")[0] == "js"

    def test_nonexistent_files(self):
        """Non-existent files detected by extension or default to text"""
        assert run_filetype("nonexistent.py")[0] == "python"
        assert run_filetype("nonexistent.txt")[0] == "text"
        assert run_filetype("nonexistent")[0] == "text"

    def test_empty_files(self):
        """Empty files detected by extension"""
        assert run_filetype("fixtures/edge_cases/empty.py")[0] == "python"
        assert run_filetype("fixtures/edge_cases/empty_no_ext")[0] == "text"

    def test_files_with_spaces(self):
        """Files with spaces in names"""
        assert run_filetype("fixtures/edge_cases/file with spaces.sh")[0] == "sh"
        assert run_filetype("fixtures/edge_cases/my file.py")[0] == "python"

    def test_binary_detection(self):
        """Binary files detected as binary"""
        assert run_filetype("fixtures/binary/elf_test")[0] == "binary"
        if os.path.exists("fixtures/binary/actual_binary"):
            assert run_filetype("fixtures/binary/actual_binary")[0] == "binary"


class TestBatchMode:
    """Test batch mode (multiple files)"""

    def test_single_file_no_prefix(self):
        """Single file returns just the syntax"""
        output, _ = run_filetype("fixtures/extensions/test.py")
        assert output == "python"

    def test_multiple_files_with_prefix(self):
        """Multiple files return filename: syntax format"""
        output, _ = run_filetype("fixtures/extensions/test.py", "fixtures/extensions/test.js")
        assert "test.py: python" in output
        assert "test.js: js" in output


class TestErrorHandling:
    """Test error conditions"""

    def test_no_files_specified(self):
        """No files → error exit"""
        _, exit_code = run_filetype(expect_error=True)
        assert exit_code != 0

    def test_invalid_editor_option(self):
        """Invalid -e value → error exit"""
        _, exit_code = run_filetype("-e", "invalid", "fixtures/extensions/test.py", expect_error=True)
        assert exit_code != 0

    def test_help_exits_successfully(self):
        """--help/-h → success exit"""
        _, exit_code = run_filetype("--help")
        assert exit_code == 0

        _, exit_code = run_filetype("-h")
        assert exit_code == 0


class TestVersionFlag:
    """Test version flag"""

    def test_version_short_flag(self):
        """-V outputs version"""
        output, exit_code = run_filetype("-V")
        assert exit_code == 0
        assert "filetype" in output
        assert "1.0.0" in output
        assert "version 1.0.0" not in output  # Should not have word "version"

    def test_version_long_flag(self):
        """--version outputs version"""
        output, exit_code = run_filetype("--version")
        assert exit_code == 0
        assert "filetype" in output
        assert "1.0.0" in output
        assert "version 1.0.0" not in output  # Should not have word "version"

    def test_version_format(self):
        """Version format is: filetype <version>"""
        output, exit_code = run_filetype("-V")
        assert exit_code == 0
        # Should be "filetype 1.0.0" not "filetype version 1.0.0"
        assert output.strip() == "filetype 1.0.0"


if __name__ == "__main__":
    # Change to tests directory
    os.chdir(SCRIPT_DIR)

    # Run pytest
    pytest.main([__file__, "-v", "--tb=short"])

#fin
