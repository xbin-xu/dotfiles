set nocompatible    " disable Vi compatible
set shortmess+=I    " disable the default Vim startup message.

"-----------------------
" General configurations
"-----------------------

" Encoding
"---------------------------------------------------------
set encoding=utf8

" Font
"---------------------------------------------------------
set guifont=JetBrainsMono\ Nerd\ Font\ 11

" Colorscheme
"---------------------------------------------------------
colorscheme onedark

" Syntax
"---------------------------------------------------------
syntax on           " turn on syntax highlighting

" Indent
"---------------------------------------------------------
filetype plugin on  " load filetype's plugin file
filetype indent on  " load filetype's indent file
set autoindent      " set automatically indented

" (Shift)Tab (de)indents code
vnoremap <Tab> >
vnoremap <S-Tab> <

" UI
"---------------------------------------------------------
set mouse+=a        " enable mouse support
set ttimeout        " set the timeout of the escape sequence
set ttimeoutlen=50

set number          " show line numbers
set relativenumber  " show relative numbering
set laststatus=2    " show the status line at the bottom
set showcmd         " show command in bottom bar
set wildmenu        " enhance command completion
set showmatch       " show matching braces when text indicator is over them
set colorcolumn=80  " set the anchor line at 80 characters
set scrolloff=5     " set cursor with at least 5 lines at the top or bottom
set hidden          " allow having hidden buffers(not displayed in any window)
set splitbelow      " split window to below
set splitright      " split window to right

" Disable annoying audible bell(error noises)
set noerrorbells visualbell t_vb=
" Make backspace behave in a more intuitive way
set backspace=indent,eol,start

" Highlight current line, but only in active window
augroup CursorLineOnlyInActiveWindow
    autocmd!
    autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
    autocmd WinLeave * setlocal nocursorline
augroup END

" Spaces & Tabs
"---------------------------------------------------------
set expandtab       " tabs are spaces, mainly because of python
set tabstop=4       " number of visual spaces per TAB
set shiftwidth=4    " insert 4 spaces on a tab
set softtabstop=4   " number of spaces in tab when editing

set list            " set list to see tabs and non-breakable spaces
set listchars=tab:>-,nbsp:.
" set listchars=tab:>-,trail:·,eol:¬,nbsp:_

" Seaerch
"---------------------------------------------------------
set incsearch       " search as characters are entered
set hlsearch        " highlight matches
set ignorecase      " ignore case in searches by default
set smartcase       " but make it case sensitive if an uppercase is entered
" Turn off search highlight
" nnoremap <silent> <C-h> :nohlsearch<CR>

" History
"---------------------------------------------------------
set history=200     " set the number of history
" Scroll history
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

" Folding
"---------------------------------------------------------
set foldenable          " enable folding
set foldlevelstart=10   " open most folds by default
set foldnestmax=10      " 10 nested fold max
set foldmethod=indent   " fold based on indent level

" Clipboard
"---------------------------------------------------------
" Use the sys clipboard by default (on versions compiled with `+clipboard`)
" [Vim 使用系统剪切板](https://harttle.land/2020/09/04/vim-clipboard.html)
" todo: not work
set clipboard=unnamed

" Undo
"---------------------------------------------------------
" Check Vim support undo
if has("persistent_undo")
    " maintain undo history between sessions
    set undofile

    " set the path to store undo files
    let target_path = expand('$HOME/.vim/undo')
    if !isdirectory(target_path)
        call system('mkdir -p ' . target_path)
    endif
    let &undodir = target_path
endif

" Leader key
"---------------------------------------------------------
nnoremap <space> <Nop>
let mapleader="\<space>"

"-------------
" Key bindings
"-------------

" Map jk to <Esc> in insert mode
" inoremap jk <Esc>

" Reload .vimrc
"---------------------------------------------------------
map <leader>r :source $MYVIMRC<CR>

" Quit & Save
"---------------------------------------------------------
nmap <leader>q :q!<CR>
nmap <leader>w :w<CR>
" Save read-only files
noremap <leader>W :w !sudo tee % >/dev/null<CR>

" Toggle terminal(require Vim-v8.1)
"---------------------------------------------------------
" default is horizontal, can use to `:vert term` open in vertical
map <C-t> :term ++close<cr>
tmap <C-t> <C-w>:term ++close<cr>

" Split windower
"---------------------------------------------------------
nnoremap <leader>- :sp<CR>
nnoremap <leader>\| :vsp<CR>

" Traversing the tab/buffer list
"---------------------------------------------------------
nnoremap <Leader>1 1gt<CR>
nnoremap <Leader>2 2gt<CR>
nnoremap <Leader>3 3gt<CR>
nnoremap <Leader>4 4gt<CR>
nnoremap <Leader>5 5gt<CR>
nnoremap <Leader>6 6gt<CR>
nnoremap <Leader>7 7gt<CR>
nnoremap <Leader>8 8gt<CR>
nnoremap <Leader>9 9gt<CR>
nnoremap <Leader>n :tabnew<CR>
nnoremap <Leader>x :tabclose<CR>
nnoremap <leader>bn :bnext<CR>
nnoremap <leader>bp :bprevious<CR>
nnoremap <leader>bd :bdelete<CR>

" Quick copy paste into system clipboard
"---------------------------------------------------------
nmap <leader>y "+y
nmap <leader>d "+d
nmap <leader>p "+p
nmap <leader>P "+P
vmap <leader>y "+y
vmap <leader>d "+d
vmap <leader>p "+p
vmap <leader>P "+P

" Movement
"---------------------------------------------------------
" move vertically by visual line
nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k

" highlight last inserted text
nnoremap gV `[v`]

" Line head & tail
map H ^
map L $

" Focus center
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap * *zzzv
nnoremap # #zzzv
nnoremap g* g*zzzv
nnoremap <C-o> <C-o>zz
nnoremap <C-i> <C-i>zz
" nnoremap J mzJ`z
" nnoremap j jzz
" nnoremap k kzz

" Replace vim's built-in visual * and # behavior
xnoremap * :<C-u>call <SID>VSetSearch()<CR>/<C-R>=@/<CR><CR>
xnoremap # :<C-u>call <SID>VSetSearch()<CR>?<C-R>=@/<CR><CR>

function! s:VSetSearch()
    let temp = @s
    norm! gv"sy
    let @/ = '\V' . substitute(escape(@s, '/\'), '\n', '\\n', 'g')
    let @s = temp
endfunction

" Prevent bad habits(using the arrow keys for movement)
"---------------------------------------------------------
nnoremap <Left>  :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up>    :echoe "Use k"<CR>
nnoremap <Down>  :echoe "Use j"<CR>

inoremap <Left>  <ESC>:echoe "Use h"<CR>
inoremap <Right> <ESC>:echoe "Use l"<CR>
inoremap <Up>    <ESC>:echoe "Use k"<CR>
inoremap <Down>  <ESC>:echoe "Use j"<CR>

vnoremap <Left>  <ESC>:echoe "Use h"<CR>
vnoremap <Right> <ESC>:echoe "Use l"<CR>
vnoremap <Up>    <ESC>:echoe "Use k"<CR>
vnoremap <Down>  <ESC>:echoe "Use j"<CR>

" Unbind some useless/annoying default key bindings
"---------------------------------------------------------
" 'Q' in normal mode enters Ex mode. You almost never want this.
nmap Q <Nop>
" Unbind for tmux
map <C-a> <Nop>

"---------------
" Plugin install
"---------------

" Auto install vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
    :exe '!curl -fLo ~/.vim/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" Colorschemes
"---------------------------------------------------------
Plug 'joshdick/onedark.vim'

" GUI enhancements
"---------------------------------------------------------
Plug 'scrooloose/nerdtree'          " file explorer
Plug 'sjl/gundo.vim'                " visualize undo tree
Plug 'kshenoy/vim-signature'        " show marks in the gutter
Plug 'vim-airline/vim-airline'      " beautify statusline
Plug 'vim-airline/vim-airline-themes'
Plug 'ryanoasis/vim-devicons'       " icon for vim plugins

" Fuzzy finder
"---------------------------------------------------------
Plug 'ctrlpvim/ctrlp.vim'
Plug 'junegunn/fzf', {'do': { -> fzf#install() }}
Plug 'junegunn/fzf.vim'

" Syntactic language support
"---------------------------------------------------------
Plug 'w0rp/ale'                     " linting engine
" Plug 'gabrielelana/vim-markdown'

" Tmux GUI
"---------------------------------------------------------
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'roxma/vim-tmux-clipboard'
Plug 'christoomey/vim-tmux-navigator'

" Movement
"---------------------------------------------------------
" Plug 'justinmk/vim-sneak'
Plug 'easymotion/vim-easymotion'

" Text manipulation
"---------------------------------------------------------
Plug 'tpope/vim-surround'
Plug 'roxma/vim-paste-easy'         " automatically `set paste`
Plug 'tpope/vim-commentary'         " quick (un)comment line(s)

" LSP
"---------------------------------------------------------
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'octol/vim-cpp-enhanced-highlight'

" DAP
"---------------------------------------------------------
Plug 'puremourning/vimspector', {'do': './install_gadget.py --enable-rust --enable-python'}

" Other
"---------------------------------------------------------
Plug 'liuchengxu/vim-which-key'     " which key

call plug#end()

"---------------------
" Plugin configuration
"---------------------

" nerdtree
"---------------------------------------------------------
nnoremap <leader>e :NERDTreeToggle<CR>

" gundo
"---------------------------------------------------------
nnoremap <leader>u :GundoToggle<CR>
if has('python3')
    let g:gundo_prefer_python3 = 1
endif

" signature
"---------------------------------------------------------
" Enable confirm while delete all tags
let g:SignaturePurgeConfirmation = 1

" airline
"---------------------------------------------------------
" Set theme for airline
let g:airline_theme = 'onedark'
" Enable airline
let g:airline#extensions#tabline#enabled = 1
" How file paths are displayed
let g:airline#extensions#tabline#formatter = 'unique_tail'

" ctrlp
"---------------------------------------------------------
" Change the default mapping and the default command to invoke CtrlP
let g:ctrlp_map = '<C-p>'
let g:ctrlp_cmd = 'CtrlP'

" fzf
"---------------------------------------------------------
let g:fzf_layout = {'down': '~40%'}

nnoremap <leader>fg :Rg<CR>
nnoremap <leader>ff :Files<CR>
nnoremap <leader>fh :History<CR>

" ale
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
nmap [a <Plug>(ale_previous_wrap)
nmap ]a <Plug>(ale_next_wrap)

" sneak
"---------------------------------------------------------
" Enable label-mode to motion(just like easymotion)
" let g:sneak#label = 1

" easymotion
"---------------------------------------------------------
map <leader> <Plug>(easymotion-prefix)

" Turn on case-insensitive feature
let g:EasyMotion_smartcase = 1

" <leader>f{char} to move to {char}
map <leader>f <Plug>(easymotion-bd-f)
nmap <leader>f <Plug>(easymotion-overwin-f)

" vim-sneak behaviour through easymotio
map <leader>t <Plug>(easymotion-t2)
map <leader>s <Plug>(easymotion-f2)
nmap <leader>t <Plug>(easymotion-overwin-t2)
nmap <leader>s <Plug>(easymotion-overwin-f2)

" JK motions: Line motions
map <leader>h <Plug>(easymotion-linebackward)
map <leader>j <Plug>(easymotion-j)
map <leader>k <Plug>(easymotion-k)
map <leader>l <Plug>(easymotion-lineforward)

" surround
"---------------------------------------------------------
" None

" paste-easy
"---------------------------------------------------------
let g:paste_easy_enable = 1

" commentary
"---------------------------------------------------------
" C and C++ use "//" to comment, rather than "/**/"
autocmd FileType c,cpp set commentstring=//\ %s

" coc
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
" xmap <leader>f  <Plug>(coc-format-selected)
" nmap <leader>f  <Plug>(coc-format-selected)

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

" cpp-enhanced-highlight
"---------------------------------------------------------
" None

" vimspector
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

" which key
"---------------------------------------------------------
" Use leader key to trigger which key
nnoremap <silent> <leader> :<C-u>WhichKey '<space>'<CR>
vnoremap <silent> <leader> :<C-u>WhichKeyVisual '<space>'<CR>

" Register the description dictionary for the prefix to pop up the guide menu
" call which_key#register('<space>', "g:which_key_map")

" Pop up the guide menu after no further keystrokes within `timeoutlen`
set timeoutlen=400

" Define prefix dictionary
let g:which_key_map =  {}

" =======================================================
" Create menus not based on existing mappings:
" =======================================================
" None

"---------------------
" Local customizations
"---------------------

let $LOCALFILE=expand("~/.vimrc_local")
if filereadable($LOCALFILE)
    source $LOCALFILE
endif
