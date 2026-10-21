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
Since we set `unnamedplus` as our clipboard, to ensure it works as expected install `xsel`:

```bash
sudo apt-get install xsel
```

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

### Rust

Install `codelldb` for debugging:
```bash
sudo apt-get install codelldb
```
