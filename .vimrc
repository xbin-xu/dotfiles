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

" Map esc to jk in insert mode
inoremap jk <ESC>

" Focus center
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap * *zzzv
nnoremap # #zzzv
nnoremap g* g*zzzv
nnoremap <C-o> <C-o>zz
nnoremap <C-i> <C-i>zz
"nnoremap J mzJ`z
"nnoremap j jzz
"nnoremap k kzz

" Set the anchor line at 80 characters
set colorcolumn=80

" Set cursor with at least 5 lines at the top or bottom
set scrolloff=5

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
set smartcase       " but make it case sensitive if an uppercase is entered
" Turn off search highlight
vnoremap <C-h> :nohlsearch<CR>
nnoremap <C-h> :nohlsearch<CR>

" Undo
if has("persistent_undo")       " Check if vim support it
    " maintain undo history between sessions
    set undofile

    " set the path to store undo files
    let target_path = expand('$HOME/.vim/undo')
    if !isdirectory(target_path)
        call system('mkdir -p ' . target_path)
    endif
    let &undodir = target_path
endif

" Use Sudow to save read-only files, see <https://www.cnblogs.com/dylanchu/p/11345675.html>
" command -nargs=0 Sudow w !sudo tee % >/dev/null

" Use the sys clipboard by default (on versions compiled with `+clipboard`)
" [Vim 使用系统剪切板](https://harttle.land/2020/09/04/vim-clipboard.html)
" todo: not work
set clipboard=unnamed

" Line head & tail
map H ^
map L $

" Leader
nnoremap <SPACE> <Nop>
let mapleader=" "   " leader is space

" Reload .vimrc
map <leader>r :source $MYVIMRC<CR>

" Quit & Save
nmap <leader>q :q!<CR>
nmap <leader>w :w<CR>
" To save read-only files, see https://www.cnblogs.com/dylanchu/p/11345675.html
noremap <leader>W :w !sudo tee % >/dev/null<CR>

" Toggle paste mode, and also can use plugin vim-paste-easy
noremap <leader>p :set paste!<CR>

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

if empty(glob('~/.vim/autoload/plug.vim'))
    :exe '!curl -fLo ~/.vim/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    au VimEnter * PlugInstall --sync | source $MYVIMRC
endif

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
Plug 'scrooloose/nerdtree'          " file explorer
Plug 'sjl/gundo.vim'                " visualize undo tree
Plug 'kshenoy/vim-signature'        " show marks in the gutter
Plug 'vim-airline/vim-airline'      " beautify statusline
Plug 'vim-airline/vim-airline-themes'

" Fuzzy finder
Plug 'ctrlpvim/ctrlp.vim'
Plug 'junegunn/fzf', {'do': { -> fzf#install() }}
Plug 'junegunn/fzf.vim'

" Syntactic language support
Plug 'w0rp/ale'                     " linting engine
" Plug 'gabrielelana/vim-markdown'

" Tmux GUI
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'roxma/vim-tmux-clipboard'

" Movement
Plug 'justinmk/vim-sneak'
Plug 'easymotion/vim-easymotion'

" Text manipulation
Plug 'tpope/vim-surround'
Plug 'roxma/vim-paste-easy'         " automatically `set paste`
Plug 'tpope/vim-commentary'         " quick (un)comment line(s)

" LSP
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'octol/vim-cpp-enhanced-highlight'

" DAP
Plug 'puremourning/vimspector', {'do': './install_gadget.py --enable-rust --enable-python'}

call plug#end()

"---------------------
" Plugin configuration
"---------------------

" nerdtree https://github.com/preservim/nerdtree
"---------------------------------------------------------
nnoremap <leader>e :NERDTreeToggle<CR>
nnoremap <leader>f :NERDTreeFind<CR>

" gundo https://github.com/sjl/gundo.vim
"---------------------------------------------------------
nnoremap <leader>u :GundoToggle<CR>
if has('python3')
    let g:gundo_prefer_python3 = 1
endif

" signature https://github.com/kshenoy/vim-signature
"---------------------------------------------------------
" Enable confirm while delete all tags
let g:SignaturePurgeConfirmation = 1

" airline https://github.com/vim-airline/vim-airline
"---------------------------------------------------------
" Set theme for airline
let g:airline_theme = 'solarized'
" Enable airline
let g:airline#extensions#tabline#enabled = 1
" How file paths are displayed
let g:airline#extensions#tabline#formatter = 'unique_tail'

" ctrlp https://github.com/ctrlpvim/ctrlp.vim
"---------------------------------------------------------
" Change the default mapping and the default command to invoke CtrlP
let g:ctrlp_map = '<C-p>'
let g:ctrlp_cmd = 'CtrlP'

" fzf https://github.com/junegunn/fzf.vim
"---------------------------------------------------------
let g:fzf_layout = {'down': '~40%'}

nnoremap <leader>fg :Rg<CR>
nnoremap <leader>ff :Files<CR>
nnoremap <leader>fh :History<CR>

" ale https://github.com/dense-analysis/ale
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
            \ '*': ['remove_trailing_lines', 'trim_whitespace'],
            \ 'javascript': ['prettier'],
            \ 'css': ['prettier'],
            \ 'html': ['prettier'],
            \ 'markdown': ['prettier'],
            \ 'json': ['prettier'],
            \ 'yaml': ['prettier'],
            \ }

" Navigate between errors quickly
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

" sneak https://github.com/justinmk/vim-sneak
"---------------------------------------------------------
" Enable label-mode to motion(just like easymotion)
let g:sneak#label = 1

" easymotion https://github.com/easymotion/vim-easymotion
"---------------------------------------------------------
map <Space> <Plug>(easymotion-prefix)

" surround https://github.com/tpope/vim-surround
"---------------------------------------------------------
" None

" paste-easy https://github.com/roxma/vim-paste-easy
"---------------------------------------------------------
let g:paste_easy_enable = 1

" vim-commentary https://github.com/tpope/vim-commentary
"---------------------------------------------------------
" None

" coc.nvim https://github.com/neoclide/coc.nvim
"---------------------------------------------------------
" coc extensions
let g:coc_global_extensions = [
            \ 'coc-json',
            \ 'coc-vimlsp',
            \ 'coc-highlight',
            \ 'coc-markdownlint',
            \ 'coc-sh',
            \ 'coc-cmake',
            \ 'coc-pyright',
            \ ]

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config
inoremap <silent><expr> <TAB>
            \ coc#pum#visible() ? coc#pum#next(1) :
            \ CheckBackspace() ? "\<Tab>" :
            \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
            \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion
if has('nvim')
    inoremap <silent><expr> <c-space> coc#refresh()
else
    inoremap <silent><expr> <c-@> coc#refresh()
endif

" Show all diagnostics
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Use `-` and `=` to navigate diagnostics
nmap <silent> <leader>- <Plug>(coc-diagnostic-prev)
nmap <silent> <leader>= <Plug>(coc-diagnostic-next)
" Apply the most preferred quickfix action to fix diagnostic on the current line
nmap <leader>ca <Plug>(coc-fix-current)

" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
    if CocAction('hasProvider', 'hover')
        call CocActionAsync('doHover')
    else
        call feedkeys('K', 'in')
    endif
endfunction

" Highlight the symbol and its references when holding the cursor
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
    autocmd!
    " Setup formatexpr specified filetype(s)
    autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
    " Update signature help on jump placeholder
    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap <C-f> and <C-b> to scroll float windows/popups
if has('nvim-0.4.0') || has('patch-8.2.0750')
    nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
    nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
    inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
    inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
    vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
    vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Add `:Format` command to format current buffer
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" vim-cpp-enhanced-highlight https://github.com/octol/vim-cpp-enhanced-highlight
"---------------------------------------------------------
" None

" vimspector https://github.com/puremourning/vimspector
"---------------------------------------------------------
let g:vimspector_enable_mappings = 'VISUAL_STUDIO'

function! s:generate_vimspector_conf()
    if empty(glob('.vimspector.json'))
        if &filetype == 'c' || &filetype == 'cpp'
            !cp ~/.vim/vimspector_config/c.json ./.vimspector.json
        elseif &filetype == 'python'
            !cp ~/.vim/vimspector_config/python.json ./.vimspector.json
        endif
    endif
    e .vimspector.json
endfunction
command! -nargs=0 Gvimspector :call s:generate_vimspector_conf()

"---------------------
" Local customizations
"---------------------

let $LOCALFILE=expand("~/.vimrc_local")
if filereadable($LOCALFILE)
    source $LOCALFILE
endif
