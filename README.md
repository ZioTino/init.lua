Run command:  
`git clone git@github.com:ZioTino/nvim.git ~/.config && nvim`

Additional needed steps for a complete working environment:

### Neovim and Treesitter

This config targets **Neovim 0.12+** and uses the `main` branch of
[nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter), which
requires the `tree-sitter` CLI and a C compiler to build parsers:

- `tree-sitter` CLI 0.26.1 or newer
  - Windows: `winget install tree-sitter.tree-sitter-cli`
  - Linux: install `tree-sitter-cli` from your package manager
- a C compiler (`gcc` on Windows/Linux, `clang` on macOS)

After updating the plugin or changing parsers, run `:TSUpdate` (or
`:TSInstall <lang>` for a single one).

### Telescope fully enabled
[fd](https://github.com/sharkdp/fd) needs to be installed:

```bash
sudo apt install fd-find
```

### Image Preview
[Chafa](https://hpjansson.org/chafa/download/) needs to be installed:

```bash
sudo apt install chafa
```

### Clipboard
Since we set `unnamedplus` as our clipboard, a native clipboard tool is needed.
The config picks the first one available: `win32yank` on Windows, then `wl-copy`
(Wayland), `xsel`, `xclip`, and finally OSC 52 (only works in terminals that
support it).

On Wayland (e.g. Pop!_OS COSMIC, GNOME Wayland) install `wl-clipboard`:

```bash
sudo apt install wl-clipboard
```

On X11 install `xsel` (or `xclip`):

```bash
sudo apt-get install xsel
```

On Windows, Neovim's official `nvim-win64.zip` ships `win32yank.exe` next to
`nvim.exe` and it is used automatically. If your install doesn't include it,
get it from <https://github.com/equalsraf/win32yank/releases> and put it on
`PATH`. Without it the config falls back to OSC 52 for copy and PowerShell for
paste, which makes every paste take a few hundred milliseconds because a new
PowerShell process has to start.

> Note: OSC 52 is not supported by every terminal (cosmic-term denies it), so
> don't rely on it when a native tool can be installed.

### Python

```bash
pip install pylint
pip install pylint-venv
pip install black
pip install python-lsp-black
```
If working with python venv:  
- Linux `<path-to-venv>/bin/activate`  
- Windows `<path-to-venv>/scripts/activate.ps1`  
```bash
export PYTHONPATH="$PYTHONPATH:$VIRTUAL_ENV/lib/python<python-version>/site-packages"
```

### Jupyter notebooks (jove.nvim)

Jove needs `jupytext` and a Python that can import `jupyter_client` and
`ipykernel`. On Debian/Ubuntu the Python modules are packaged, but `jupytext`
is not:

```bash
sudo apt install python3-jupyter-client python3-ipykernel pipx
pipx install jupytext
```

If the Jupyter stack lives in a virtualenv or conda environment, point jove at
its interpreter by adding `bridge_python = "<path>/bin/python"` to the
`jove.nvim` opts in `lua/tino/lazy/jove.lua`, and make sure its `bin` directory
is on `$PATH` so `jupytext` can be found.

Verify the setup with `:checkhealth jove`. Do not install `jupytext.nvim`: it
and jove both register `BufReadCmd` for `*.ipynb`.

### Rust

Install `codelldb` for debugging:
```bash
sudo apt-get install codelldb
```
