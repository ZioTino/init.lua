Run command:  
`git clone git@github.com:ZioTino/nvim.git ~/.config && nvim`

Additional needed steps for a complete working environment:

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
