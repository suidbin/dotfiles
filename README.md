# my personal dotfiles

Personal dotfiles managed by [dotbot].

Primary OS is Windows 10/11, and this attempts to keep configuration
consistent across Windows/Powershell and WSL/Ubuntu. [.profile] on posix
systems and [setup_env_win.ps1] set the [XDG] directories so that
configurations better mirror eachother.

## Install

```shell
    git clone https://github.com/suidbin/dotfiles
    cd dotfiles
    ./install  # or on windows powershell ./install.ps1
```

## Windows notes

On Windows you'll want developer mode enabled if possible, allowing `dotbot`
to create the symlinks.  See [bootstrap.ps1] as a script that tries to create
a symlink, and failing that attempts to enable developer mode.  The bootstrap
process will also use [winget] to install powershell 6/7+, as some of the
powershell syntax/features requires newer powershell.

The [setup_python.ps1] looks for the command `pyenv` to
manage python installations, and if not found will `git clone` [pyenv-win]
into `~/.local/pyenv`, and use pyenv-win to install the latest stable
(and not .0) version of python.

Python versions are stored in `~/.local/pyenv/pyenv-win/versions`, and the
shims and bin directory are added to the user path by [setup_user_path.ps1].

## Vim

Using Vim 8+ native package management rather than a plugin manager. Plugins
and packages are git submodules, described [here](vim/README.md).  Current
submodules:

 * [onedark]    - Colorscheme
 * [Lightline]  - Lightweight vim status line
 * [Tmuxline]   - Non autoloading. Generates a statusline for tmux using the
                  vim colorscheme.
 * [vimvinegar] - Enhancements to netrw

[.profile]:            shell/profile
[setup_env_win.ps1]:   setup_env_win.ps1
[bootstrap.ps1]:       bootstrap.ps1
[setup_python.ps1]:    setup_python.ps1
[setup_user_path.ps1]: setup_user_path.ps1
[dotbot]:     https://github.com/anishathalye/dotbot
[XDG]:        https://wiki.archlinux.org/title/XDG_Base_Directory
[winget]:     https://github.com/microsoft/winget-cli
[pyenv-win]:  https://github.com/pyenv-win/pyenv-win
[onedark]:    https://github.com/joshdick/onedark.vim.git
[Lightline]:  https://github.com/itchyny/lightline.vim
[Tmuxline]:   https://github.com/edkolev/tmuxline.vim
[vimvinegar]: https://github.com/tpope/vim-vinegar