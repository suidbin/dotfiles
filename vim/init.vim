" Use Vim settings, rather than Vi settings
set nocompatible

" XDG support  - https://blog.joren.ga/vim-xdg
" Configures VIM to use XDG standard directories for cache, data, config
" ----------------------------------------------------------------------------
if empty($MYVIMRC) | let $MYVIMRC = expand('<sfile>:p') | endif

if empty($XDG_CACHE_HOME)  | let $XDG_CACHE_HOME  = $HOME."/.cache"       | endif
if empty($XDG_CONFIG_HOME) | let $XDG_CONFIG_HOME = $HOME."/.config"      | endif
if empty($XDG_DATA_HOME)   | let $XDG_DATA_HOME   = $HOME."/.local/share" | endif

set runtimepath^=$XDG_CONFIG_HOME/vim
set runtimepath+=$XDG_DATA_HOME/vim
set runtimepath+=$XDG_CONFIG_HOME/vim/after

set packpath^=$XDG_DATA_HOME/vim,$XDG_CONFIG_HOME/vim
set packpath+=$XDG_CONFIG_HOME/vim/after,$XDG_DATA_HOME/vim/after

let g:netrw_home = $XDG_DATA_HOME."/vim"
call mkdir($XDG_DATA_HOME."/vim/spell", 'p', 0700)
set viewdir=$XDG_DATA_HOME/vim/view | call mkdir(&viewdir, 'p', 0700)

set backupdir=$XDG_CACHE_HOME/vim/backup | call mkdir(&backupdir, 'p', 0700)
set directory=$XDG_CACHE_HOME/vim/swap   | call mkdir(&directory, 'p', 0700)
set undodir=$XDG_CACHE_HOME/vim/undo     | call mkdir(&undodir,   'p', 0700)

if !has('nvim') " Neovim has its own special location
  set viminfofile=$XDG_CACHE_HOME/vim/viminfo
endif

" On WSL, automatically copy whatever is yanked into the system clipboard
" ----------------------------------------------------------------------------
let s:clip = '/mnt/c/Windows/System32/clip.exe'
if executable(s:clip) && has('autocmd')
    augroup WSLYank
        autocmd!
        autocmd TextYankPost * call system(s:clip, @")
    augroup end
endif

" Other Miscellaneous settings
" ----------------------------------------------------------------------------

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set backup        " keep a backup file (restore to a previous version)
set undofile      " keep an undo file (undo changes after closing)
set history=50    " keep 50 lines of command line history
set ruler         " show the cursor position all the time
set showcmd       " show incomplete commands
set incsearch     " do incremental searching
set laststatus=2  " statusline is always visible

" Some preferences for the file browser (:Ex)plore :
set g:netrw_banner     = 0  " Disable the banner
set g:netrw_liststyle  = 3  " Default to tree view

" setting default tabstop and shiftwidth to 4 spaces (expandtabs)
set tabstop=4
set shiftwidth=4
set expandtab

" enable syntax highlighting if there are colors available
if &t_Co > 2 || has("gui_running")
    syntax on
endif

" Use vim Man plugin as the keyword program
runtime ftplugin/man.vim
set keywordprg=:Man

" Enable mouse if available
if has('mouse')
    set mouse=a
endif
" Enable mouse handling for modern terminal emulators
" https://stackoverflow.com/questions/7000960/
if has('mouse_sgr')
    set ttymouse=sgr
endif

if has("autocmd")

    " Enable file type detection
    filetype plugin indent on

    " Put these in an autocmd group, so that we can delete them easily
    augroup vimrcEx
    au!

    " For all text files set textwidth to 78 characters
    autocmd FileType text setlocal textwidth=78

    " Enable spellchecking for Markdown
    autocmd BufRead,BufNewFile *.md set filetype=markdown
    autocmd FileType markdown setlocal spell

    " Automatically wrap at 80 characters for Markdown
    autocmd BufRead,BufNewFile *.md setlocal textwidth=80

    " When editing a file, always jump to the last known cursor position.
    " Don't do it for commit messages, when the position is invalid, or when
    " inside an event handler (happens when dropping a file on gvim).
    autocmd BufReadPost *
      \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
      \   exe "normal g`\"" |
      \ endif
    
    augroup END

    " only highlight the current line in the current window
    augroup CursorLine
        au!
        au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
        au WinLeave * setlocal nocursorline
    augroup END
else
    set autoindent
    set smartindent
endif

" enabling true colors for vim
if exists('+termguicolors')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors
endif

" set colorscheme and lightline theme
packadd! onedark.vim
colorscheme onedark
let g:lightline = {
    \ 'colorscheme': 'onedark'
    \ }
