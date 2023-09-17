"-------------------------
" [General configurations](https://missing-semester-cn.github.io/2020/files/vimrc)
"-------------------------

" Comments in Vimscript start with a `"`.

" If you open this file in Vim, it'll be syntax highlighted for you.

" Vim is based on Vi. Setting `nocompatible` switches from the default
" Vi-compatibility mode and enables useful Vim functionality. This
" configuration option turns out not to be necessary for the file named
" '~/.vimrc', because Vim automatically enters nocompatible mode if that file
" is present. But we're including it here just in case this config file is
" loaded some other way (e.g. saved as `foo`, and then Vim started with
" `vim -u foo`).
set nocompatible

" Turn on syntax highlighting.
syntax on

" Disable the default Vim startup message.
set shortmess+=I

" Show line numbers.
set number          " same as `set nu`

" This enables relative line numbering mode. With both number and
" relativenumber enabled, the current line shows the true line number, while
" all other lines (above and below) are numbered relative to the current line.
" This is useful because you can tell, at a glance, what count is needed to
" jump up or down to a particular line, by {count}k to go up or {count}j to go
" down.
set relativenumber  " same as `set rnu`

" Always show the status line at the bottom, even if you only have one window open.
set laststatus=2

" The backspace key has slightly unintuitive behavior by default. For example,
" by default, you can't backspace before the insertion point set with 'i'.
" This configuration makes backspace behave more reasonably, in that you can
" backspace over anything.
set backspace=indent,eol,start

" By default, Vim doesn't let you hide a buffer (i.e. have a buffer that isn't
" shown in any window) that has unsaved changes. This is to prevent you from "
" forgetting about unsaved changes and then quitting e.g. via `:qa!`. We find
" hidden buffers helpful enough to disable this protection. See `:help hidden`
" for more information on this.
set hidden

" This setting makes search case-insensitive when all characters in the string
" being searched are lowercase. However, the search becomes case-sensitive if
" it contains any capital letters. This makes searching more convenient.
set ignorecase
set smartcase

" Enable searching as you type, rather than waiting till you press enter.
set incsearch

" Unbind some useless/annoying default key bindings.
nmap Q <Nop>        " 'Q' in normal mode enters Ex mode. You almost never want this.

" Disable audible bell because it's annoying.
set noerrorbells visualbell t_vb=

" Enable mouse support. You should avoid relying on this too much, but it can
" sometimes be convenient.
set mouse+=a

" Try to prevent bad habits like using the arrow keys for movement. This is
" not the only possible bad habit. For example, holding down the h/j/k/l keys
" for movement, rather than using more efficient movement commands, is also a
" bad habit. The former is enforceable through a .vimrc, while we don't know
" how to prevent the latter.
" Do this in normal mode...
nnoremap <Left>  :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up>    :echoe "Use k"<CR>
nnoremap <Down>  :echoe "Use j"<CR>
" ...and in insert mode
inoremap <Left>  <ESC>:echoe "Use h"<CR>
inoremap <Right> <ESC>:echoe "Use l"<CR>
inoremap <Up>    <ESC>:echoe "Use k"<CR>
inoremap <Down>  <ESC>:echoe "Use j"<CR>

"--------------------
" Misc configurations
"--------------------

" Enhance command-line completion
set wildmenu

" Set list to see tabs and non-breakable spaces
set list
set listchars=tab:>-,nbsp:.
" set listchars=tab:>-,trail:·,eol:¬,nbsp:_

" Spaces & Tabs
set expandtab       " tabs are spaces, mainly because of python
set tabstop=4       " number of visual spaces per TAB
set shiftwidth=4    " Insert 4 spaces on a tab
set softtabstop=4   " number of spaces in tab when editing

" Seaerch
set incsearch       " search as characters are entered
set hlsearch        " highlight matches
set ignorecase      " ignore case in searches by default
" set smartcase       " but make it case sensitive if an uppercase is entered
" turn off search highlight
vnoremap <C-h> :nohlsearch<CR>
nnoremap <C-h> :nohlsearch<CR>

" Undo
set undofile         " maintain undo history between sessions
set undodir=~/.vim/undodir

" Use Sudow to save read-only files, see <https://www.cnblogs.com/dylanchu/p/11345675.html>
" command -nargs=0 Sudow w !sudo tee % >/dev/null

" Leader
let mapleader=" "   " leader is space

" save read-only files, see <https://www.cnblogs.com/dylanchu/p/11345675.html>
noremap <leader>W :w !sudo tee % >/dev/null<CR>

"------------------
" Syntax and indent
"------------------
syntax on           " turn on syntax highlighting
set showmatch       " show matching braces when text indicator is over them

" Highlight current line, but only in active window
augroup CursorLineOnlyInActiveWindow
    autocmd!
    autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
    autocmd WinLeave * setlocal nocursorline
augroup END

" Vim can autodetect this based on $TERM (e.g. 'xterm-256color')
" but it can be set to force 256 colors
" set t_Co=256
if has('gui_running')
    colorscheme solarized
    let g:lightline = {'colorscheme': 'solarized'}
elseif &t_Co < 256
    colorscheme default
    set nocursorline                " looks bad in this mode
else
    set background=dark
    let g:solarized_termcolors=256  " instead of 16 color with mapping in terminal
    colorscheme solarized
    " Customized colors
    highlight SignColumn ctermbg=234
    highlight StatusLine cterm=bold ctermfg=245 ctermbg=235
    highlight StatusLineNC cterm=bold ctermfg=245 ctermbg=235
    let g:lightline = {'colorscheme': 'dark'}
    highlight SpellBad cterm=underline
    " Patches
    highlight CursorLineNr cterm=NONE
endif

" Enable file type detection
filetype plugin indent on
set autoindent

"---------------
" Plugin install
" [Vim plugin manager](https://github.com/junegunn/vim-plug)
"---------------

call plug#begin()
" The default plugin directory will be as follows:
"   - Vim (Linux/macOS): '~/.vim/plugged'
"   - Vim (Windows): '~/vimfiles/plugged'
"   - Neovim (Linux/macOS/Windows): stdpath('data') . '/plugged'
" You can specify a custom plugin directory by passing it as the argument
"   - e.g. `call plug#begin('~/.vim/plugged')`
"   - Avoid using standard Vim directory names like 'plugin'

" Make sure you use single quotes

" Colorschemes
" vim-colors-solarized need run next command
" `mkdir -p ~/.vim/colors`
" `mv ~/.vim/plugged/vim-colors-solarized/colors/solarized.vim ~/.vim/colors/`
Plug 'altercation/vim-colors-solarized'

" GUI enhancements
Plug 'scrooloose/nerdtree'          " File explorer

" fuzzy finder
Plug 'ctrlpvim/ctrlp.vim'

" Syntactic language support
Plug 'w0rp/ale'                     " Linting engine

" Tmux GUI
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'roxma/vim-tmux-clipboard'

call plug#end()

"---------------------
" Plugin configuration
"---------------------

" nerdtree https://github.com/preservim/nerdtree
"---------------------------------------------------------
nnoremap <Leader>n :NERDTreeToggle<CR>
nnoremap <Leader>f :NERDTreeFind<CR>

" CtrlP https://github.com/ctrlpvim/ctrlp.vim
"---------------------------------------------------------
" Change the default mapping and the default command to invoke CtrlP
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'

" Ale https://github.com/dense-analysis/ale
"---------------------------------------------------------
" Enable completion where available.
let g:ale_enabled = 1

" For quick startup
" Run linters only when you save files.
let g:ale_lint_on_enter = 1
let g:ale_lint_on_save = 1

" Set this variable to 1 to fix files when you save them.
let g:ale_fix_on_save = 1
let g:ale_float_preview = 1

" Configure fixers
let g:ale_fixers = {
    \   '*': ['remove_trailing_lines', 'trim_whitespace'],
    \   'javascript': ['prettier'],
    \   'css': ['prettier'],
    \   'html': ['prettier'],
    \   'markdown': ['prettier'],
    \   'json': ['prettier'],
    \   'yaml': ['prettier'],
    \}

" Navigate between errors quickly
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

"---------------------
" Local customizations
"---------------------

let $LOCALFILE=expand("~/.vimrc_local")
if filereadable($LOCALFILE)
    source $LOCALFILE
endif
