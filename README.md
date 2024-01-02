Run command:  
`git clone git@github.com:ZioTino/nvim.git ~/.config && nvim`

Additional needed steps for a complete working environment:

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
