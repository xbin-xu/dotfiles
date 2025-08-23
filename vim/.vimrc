set nocompatible    " disable Vi compatible
set shortmess+=I    " disable the default Vim startup message.

"-----------------------
" General configurations
"-----------------------

" Encoding
"---------------------------------------------------------
set encoding=utf-8

" Font
"---------------------------------------------------------
set guifont=JetBrainsMono\ Nerd\ Font\ 11

" Colorscheme
"---------------------------------------------------------
" transparent
" augroup colorset
"     autocmd!
"     autocmd ColorScheme * hi Normal guibg=NONE ctermbg=NONE
" augroup END

" onedark.vim override: Don't set a background color when running in a terminal;
" just use the terminal's background color
" `gui` is the hex color code used in GUI mode/nvim true-color mode
" `cterm` is the color code used in 256-color mode
" `cterm16` is the color code used in 16-color mode
if (has("autocmd") && !has("gui_running"))
    augroup colorset
        autocmd!
        let s:white = { "gui": "#ABB2BF", "cterm": "145", "cterm16" : "7" }
        autocmd ColorScheme * call onedark#set_highlight("Normal", { "fg": s:white }) " `bg` will not be styled since there is no `bg` setting
    augroup END
endif
colorscheme onedark

" Syntax
"---------------------------------------------------------
syntax on           " turn on syntax highlighting

" Indent
"---------------------------------------------------------
filetype plugin on  " load filetype's plugin file
filetype indent on  " load filetype's indent file
set autoindent      " set automatically indented
set smartindent     " set smart indent
" Disable ':' to reindenting of the current line
set cinkeys="0{,0},0),0],0#,!^F,o,O,e"
set indentkeys="0{,0},0),0],0#,!^F,o,O,e"

" UI
"---------------------------------------------------------
set mouse+=a        " enable mouse support
set timeoutlen=200  " timeout of keystrokes
set updatetime=200  " set updatetime, default is 4000

" set spell           " enable spell check
set number          " show line numbers
set relativenumber  " show relative numbering
set laststatus=2    " show the status line at the bottom
set showcmd         " show command in bottom bar
set wildmenu        " enhance command-line completion
set wildmode=longest:full,full  " command-line completion mode
set showmatch       " show matching braces when text indicator is over them
set colorcolumn=80  " set the anchor line at 80 characters
set scrolloff=5     " set cursor with at least 5 lines at the top or bottom
set hidden          " allow having hidden buffers(not displayed in any window)
set splitbelow      " split window to below
set splitright      " split window to right
set signcolumn=yes  " always show thw signcolumn, otherwise it would shift the text each time
set completeopt=menu,menuone,noselect   " completion for insert mode

" Disable annoying audible bell(error noises)
set noerrorbells visualbell t_vb=
" Make backspace behave in a more intuitive way
set backspace=indent,eol,start
" Make jumplist(<C-o>) like stack
" https://vi.stackexchange.com/questions/18344/how-to-change-jumplist-behavior
set jumpoptions+=stack

" Highlight current line, but only in active window
augroup CursorLineOnlyInActiveWindow
    autocmd!
    autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
    autocmd WinLeave * setlocal nocursorline
augroup END

" Disable 'o' and 'O' toogle continue comment, but '<CR>' will
augroup ContinueComment
    autocmd!
    autocmd FileType * setlocal formatoptions-=o
    autocmd FileType * setlocal formatoptions+=r
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

" Search
"---------------------------------------------------------
set incsearch       " search as characters are entered
set hlsearch        " highlight matches
set ignorecase      " ignore case in searches by default
set smartcase       " but make it case sensitive if an uppercase is entered
" Ignore files for completion
set wildignore+=*/.git/*,*/tmp/*

" History
"---------------------------------------------------------
set history=2000    " set the number of history

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

"-------------
" Key bindings
"-------------

" Leader key
"---------------------------------------------------------
nnoremap <Space> <Nop>
let mapleader="\<Space>"

" Reload .vimrc
"---------------------------------------------------------
noremap <leader>r :source $MYVIMRC<CR>

" Escap
"---------------------------------------------------------
" Map jk to <Esc> in insert mode
" inoremap jk <Esc>

" Quit & Save
"---------------------------------------------------------
nnoremap <leader>q :q!<CR>
" nnoremap <leader>q :bdelete<CR>
nnoremap <leader>w :w<CR><Esc>
noremap <leader>W :w !sudo tee % >/dev/null<CR>
inoremap <C-s> :w<CR><Esc>
xnoremap <C-s> :w<CR><Esc>
nnoremap <C-s> :w<CR><Esc>
snoremap <C-s> :w<CR><Esc>

" Terminal
"---------------------------------------------------------
" Toggle terminal, default is horizontal, use `:vert term` tp open in vertical
noremap <silent> <C-/> :term ++close ++rows=15<CR>
tnoremap <C-/> <C-w>:q!<CR>

" Tab
"---------------------------------------------------------
nnoremap <leader><tab>n :tabnew<CR>
nnoremap <leader><tab>d :tabclose<CR>
nnoremap <leader><tab>l :tablast<CR>
nnoremap <leader><tab>f :tabfirst<CR>

" Navigate tab
nnoremap [<tab> :tabprevious<CR>
nnoremap ]<tab> :tabnext<CR>

" Window
"---------------------------------------------------------
" nnoremap <leader>wd <C-w>c
" nnoremap <leader>ww <C-w>p
" Split window
" nnoremap <leader>w- <C-w>s
" nnoremap <leader>w\| <C-w>v
nnoremap <leader>- :sp<CR>
nnoremap <leader>\| :vsp<CR>

" Navigate window
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
tnoremap <C-h> <C-w>h
tnoremap <C-j> <C-w>j
tnoremap <C-k> <C-w>k
tnoremap <C-l> <C-w>l

" Resize window
nnoremap <C-Up> :resize +2<CR>
nnoremap <C-Down> :resize -2<CR>
nnoremap <C-Left> :vertical resize -2<CR>
nnoremap <C-Right> :vertical resize +2<CR>

" Buffer
"---------------------------------------------------------
noremap <leader>bb :e #<CR>
noremap <leader>bn :enew<CR>
noremap <leader>bd :bdelete<CR>

" Navigate buffer
nnoremap [b :bprevious<CR>
nnoremap ]b :bnext<CR>
" nnoremap <S-Tab> :bprevious<CR>
" nnoremap <Tab> :bnext<CR>
" nnoremap <S-h> :bprevious<CR>
" nnoremap <S-l> :bnext<CR>

" Clipboard
"---------------------------------------------------------
" Replace selected whithout yank it
vnoremap p "_dP
" Quick copy paste into system clipboard
nnoremap <leader>y "+y
nnoremap <leader>d "+d
nnoremap <leader>p "+p
nnoremap <leader>P "+P
vnoremap <leader>y "+y
vnoremap <leader>d "+d
vnoremap <leader>p "+p
vnoremap <leader>P "+P

" Movement
"---------------------------------------------------------
" Line head & tail
noremap H ^
noremap L $

" Move vertically by visual line
nnoremap <silent> <expr> j v:count == 0 ? 'gj' : 'j'
nnoremap <silent> <expr> k v:count == 0 ? 'gk' : 'k'
xnoremap <silent> <expr> j v:count == 0 ? 'gj' : 'j'
xnoremap <silent> <expr> k v:count == 0 ? 'gk' : 'k'

" Move line: `<A-j>` and `<M-j>` are not work
" Solve: press <C-v>, then press <Alt-j>
nnoremap j :m .+1<CR>==
nnoremap k :m .-2<CR>==
inoremap j <Esc>:m .+1<CR>==gi
inoremap k <Esc>:m .-2<CR>==gi
vnoremap j :m '>+1<CR>gv=gv
vnoremap k :m '<-2<CR>gv=gv

" Search
"---------------------------------------------------------
" Turn off highlight search
" noremap <leader>nh :noh<CR>
nnoremap <silent> <Esc> :noh<CR><Esc>

" Focus center
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap * *zzzv
nnoremap # #zzzv
nnoremap g* g*zzzv
nnoremap <C-i> <C-i>zz
nnoremap <C-o> <C-o>zz

" Replace vim's built-in visual * and # behavior
xnoremap * :<C-u>call <SID>VSetSearch()<CR>/<C-R>=@/<CR><CR>
xnoremap # :<C-u>call <SID>VSetSearch()<CR>?<C-R>=@/<CR><CR>

function! s:VSetSearch()
    let temp = @s
    norm! gv"sy
    let @/ = '\V' . substitute(escape(@s, '/\'), '\n', '\\n', 'g')
    let @s = temp
endfunction

" Quickfix
"---------------------------------------------------------
" Location list
nnoremap <leader>xl :lopen<CR>

" Quickfix list
nnoremap <leader>xq :copen<CR>
nnoremap [q :cprev<CR>
nnoremap ]q :cnext<CR>

" Markdown
"---------------------------------------------------------
autocmd Filetype markdown inoremap ,f <Esc>/<++><CR>:nohlsearch<CR>c4l
autocmd Filetype markdown inoremap ,f <Esc>/<++><CR>:nohlsearch<CR>c4l
autocmd Filetype markdown inoremap ,n ---<Enter><Enter>
autocmd Filetype markdown inoremap ,b **** <++><Esc>F*hi
autocmd Filetype markdown inoremap ,s ~~~~ <++><Esc>F~hi
autocmd Filetype markdown inoremap ,i ** <++><Esc>F*i
autocmd Filetype markdown inoremap ,d `` <++><Esc>F`i
autocmd Filetype markdown inoremap ,c ```<Enter><++><Enter>```<Enter><Enter><++><Esc>4kA
autocmd Filetype markdown inoremap ,h ====<Space><++><Esc>F=hi
autocmd Filetype markdown inoremap ,p ![](<++>) <++><Esc>F[a
autocmd Filetype markdown inoremap ,a [](<++>) <++><Esc>F[a
autocmd Filetype markdown inoremap ,1 #<Space><Enter><++><Esc>kA
autocmd Filetype markdown inoremap ,2 ##<Space><Enter><++><Esc>kA
autocmd Filetype markdown inoremap ,3 ###<Space><Enter><++><Esc>kA
autocmd Filetype markdown inoremap ,4 ####<Space><Enter><++><Esc>kA
autocmd Filetype markdown inoremap ,l ---<Enter>

" Toggle
"---------------------------------------------------------
" Toggle spell
nnoremap <silent> <leader>us :set spell!<CR>

" Toggle wrap
nnoremap <silent> <leader>uw :set wrap!<CR>

" Toggle line numbers
nnoremap <silent> <leader>ul :set norelativenumber number!<CR>
nnoremap <silent> <leader>uL :set relativenumber!<CR>

" Other
"---------------------------------------------------------
" Navigate function
nnoremap [f [[
nnoremap [F []
nnoremap ]f ]]
nnoremap ]F ][

" Scroll cmd line history
cnoremap <C-j> <Down>
cnoremap <C-k> <Up>

" Highlight last inserted text
nnoremap gV `[v`]

" Enable continuous indent
vnoremap > >gv
vnoremap < <gv
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv

" Increment / Decrement
" nnoremap <C-a> ggVG
nnoremap vag ggVG
nnoremap yag ggVGy<C-o><C-o>
nnoremap + <C-a>
xnoremap + <C-a>
nnoremap - <C-x>
xnoremap - <C-x>

" Add undo break-points
inoremap , ,<C-g>u
inoremap . .<C-g>u
inoremap ; ;<C-g>u

" Unbind some useless/annoying default key bindings
"---------------------------------------------------------
" 'Q' in normal mode enters Ex mode. You almost never want this.
nmap Q <Nop>

" Prevent bad habits(using the arrow keys for movement)
"---------------------------------------------------------
nnoremap <Left>  :echoe "Use h"<CR>
nnoremap <Down>  :echoe "Use j"<CR>
nnoremap <Up>    :echoe "Use k"<CR>
nnoremap <Right> :echoe "Use l"<CR>

inoremap <Left>  <Esc>:echoe "Use h"<CR>
inoremap <Down>  <Esc>:echoe "Use j"<CR>
inoremap <Up>    <Esc>:echoe "Use k"<CR>
inoremap <Right> <Esc>:echoe "Use l"<CR>

vnoremap <Left>  <Esc>:echoe "Use h"<CR>
vnoremap <Down>  <Esc>:echoe "Use j"<CR>
vnoremap <Up>    <Esc>:echoe "Use k"<CR>
vnoremap <Right> <Esc>:echoe "Use l"<CR>

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
" if empty(glob('~/.vim/colors/onedark.vim'))
"     call system('cp ~/.vim/plugged/onedark.vim/colors/onedark.vim ~/.vim/colors/onedark.vim')
" endif
" if empty(glob('~/.vim/autoload/onedark.vim'))
"     call system('cp ~/.vim/plugged/onedark.vim/autoload/onedark.vim ~/.vim/autoload/onedark.vim')
" endif

" GUI enhancements
"---------------------------------------------------------
Plug 'mhinz/vim-startify'           " start screen
Plug 'scrooloose/nerdtree'          " file explorer
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'Xuyuanp/nerdtree-git-plugin'  " git status for nerdree
Plug 'sjl/gundo.vim'                " visualize undo tree
Plug 'kshenoy/vim-signature'        " show marks in the gutter
Plug 'vim-airline/vim-airline'      " beautify statusline
Plug 'vim-airline/vim-airline-themes'
Plug 'ryanoasis/vim-devicons'       " icon for vim plugins

" Fuzzy finder
"---------------------------------------------------------
Plug 'junegunn/fzf', {'do': { -> fzf#install() }}
Plug 'junegunn/fzf.vim'

" Tmux
"---------------------------------------------------------
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'roxma/vim-tmux-clipboard'
Plug 'christoomey/vim-tmux-navigator'

" Git GUI
"---------------------------------------------------------
Plug 'tpope/vim-fugitive'           " git interface
Plug 'airblade/vim-gitgutter'       " git gutter

" Movement
"---------------------------------------------------------
Plug 'easymotion/vim-easymotion'

" Text manipulation
"---------------------------------------------------------
Plug 'tpope/vim-surround'
Plug 'roxma/vim-paste-easy'         " automatically `set paste`
Plug 'tpope/vim-commentary'         " quick (un)comment line(s)
Plug 'junegunn/vim-easy-align'      " easy align
Plug 'voldikss/vim-translator'      " translator
Plug 'mg979/vim-visual-multi'
Plug 'tpope/vim-repeat'             " enable repeating supported plugin maps with "."

" Markdown
"---------------------------------------------------------
Plug 'godlygeek/tabular'
Plug 'preservim/vim-markdown'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'mzlogin/vim-markdown-toc'
Plug 'dhruvasagar/vim-table-mode'

" LSP
"---------------------------------------------------------
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'octol/vim-cpp-enhanced-highlight'

" DAP
"---------------------------------------------------------
" Plug 'puremourning/vimspector', {'do': './install_gadget.py --enable-rust --enable-python'}

" Other
"---------------------------------------------------------
Plug 'liuchengxu/vim-which-key'     " which key
" Plug 'liuchengxu/vim-which-key', { 'on': ['WhichKey', 'WhichKey!'] }
Plug 'romainl/vim-cool'             " auto enable/disable search highlight
" Plug 'Exafunction/codeium.vim', { 'branch': 'main' }
" Plug 'github/copilot.vim'
" Plug 'brglng/vim-im-select'         " auto switch input method

call plug#end()

"---------------------
" Plugin configuration
"---------------------

" nerdtree
"---------------------------------------------------------
" Can be enabled or disabled
let g:webdevicons_enable_nerdtree = 1
" Whether or not to show the nerdtree brackets around flags
let g:webdevicons_conceal_nerdtree_brackets = 1

" nnoremap <C-e> :NERDTreeToggle<CR>
" nnoremap <leader>e :NERDTreeFind<CR>
nnoremap <leader>e :NERDTreeToggle<CR>
nnoremap <leader>E :NERDTreeFind<CR>

" Show hidden files, but ignore .git, .idea, .history
let NERDTreeShowHidden = 1
let NERDTreeIgnore=['\.git$', '\.idea$', '\.history$']

" Enable liine numbers
let NERDTreeShowLineNumbers = 1

let g:NERDTreeDirArrowExpandable = ''
let g:NERDTreeDirArrowCollapsible = ''

" Make sure relative line numbers are used
autocmd FileType nerdtree setlocal relativenumber

" Close the tab if NERDTree is the only window remaining in it.
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endi

" nerdtree-git-plugin
"---------------------------------------------------------
" Force extra padding in NERDTree so that the filetype icons line up vertically
let g:WebDevIconsNerdTreeGitPluginForceVAlign = 1

" Enable nerdfonts
let g:NERDTreeGitStatusIndicatorMapCustom = {
    \ 'Modified'  :'',
    \ 'Staged'    :'',
    \ 'Untracked' :'',
    \ 'Renamed'   :'󰁕',
    \ 'Unmerged'  :'',
    \ 'Deleted'   :'✖',
    \ 'Dirty'     :'✗',
    \ 'Ignored'   :'',
    \ 'Clean'     :'✔︎',
    \ 'Unknown'   :'?',
    \ }

" vim-nerdtree-syntax-highlight
"---------------------------------------------------------
" None

" gundo
"---------------------------------------------------------
nnoremap <leader>uu :GundoToggle<CR>
if has('python3')
    let g:gundo_prefer_python3 = 1
endif

" vim-signature
"---------------------------------------------------------
" Enable confirm while delete all tags
let g:SignaturePurgeConfirmation = 1

" vim-airline
"---------------------------------------------------------
" Set theme for airline
let g:airline_theme = 'onedark'
" Enable airline
let g:airline#extensions#tabline#enabled = 1
" How file paths are displayed
let g:airline#extensions#tabline#formatter = 'unique_tail'

" fzf
"---------------------------------------------------------
" Default extra key bindings
let g:fzf_action = {
    \ 'ctrl-t': 'tab split',
    \ 'ctrl-x': 'split',
    \ 'ctrl-v': 'vsplit' }

" Default Layout
" - Popup window (center of the screen)
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }
" - down / up / left / right
" let g:fzf_layout = {'down': '40%'}

" Initialize configuration dictionary
let g:fzf_vim = {}
" This is the default option:
"   - Preview window on the right with 50% width
"   - CTRL-/ will toggle preview window.
" - Note that this array is passed as arguments to fzf#vim#with_preview function.
" - To learn more about preview window options, see `--preview-window` section of `man fzf`.
let g:fzf_vim.preview_window = ['right,50%', 'ctrl-/']

nnoremap <leader>, :Buffers<CR>
nnoremap <leader>/ :Rg<CR>
nnoremap <leader>: :History:<CR>
nnoremap <leader><Space> :Files<CR>

nnoremap <leader>fb :Buffers<CR>
nnoremap <leader>ff :Files<CR>
nnoremap <leader>fg :GFiles<CR>
nnoremap <leader>fh :Helptags<CR>
nnoremap <leader>fr :History<CR>

nnoremap <leader>gc :Commit<CR>

nnoremap <leader>sb :Buffers<CR>
nnoremap <leader>sc :History:<CR>
nnoremap <leader>sC :Commands<CR>
nnoremap <leader>sf :Files<CR>
nnoremap <leader>sg :Rg<CR>
nnoremap <leader>sh :Helptags<CR>
nnoremap <leader>sk :Maps<CR>
nnoremap <leader>sm :Marks<CR>
nnoremap <leader>sr :History<CR>
nnoremap <leader>ss :BTags<CR>
nnoremap <leader>sS :Tags<CR>

nnoremap <leader>uc :Colors<CR>

" vim-gitgutter
" notes: can not unstage staged changes
"---------------------------------------------------------
nmap <silent> [g :call GitGutterPrevHunkCycle()<CR>
nmap <silent> ]g :call GitGutterNextHunkCycle()<CR>
nmap <silent> <leader>gj :call GitGutterNextHunkCycle()<CR>
nmap <silent> <leader>gk :call GitGutterPrevHunkCycle()<CR>
nmap <silent> <leader>gs <plug>(GitGutterStageHunk)
nmap <silent> <leader>gu <plug>(GitGutterUndoHunk)
nmap <silent> <leader>gp <plug>(GitGutterPreviewHunk)
nmap <silent> <leader>gd :GitGutterDiffOrig<CR>
omap ih <Plug>(GitGutterTextObjectInnerPending)
omap ah <Plug>(GitGutterTextObjectOuterPending)
xmap ih <Plug>(GitGutterTextObjectInnerVisual)
xmap ah <Plug>(GitGutterTextObjectOuterVisual)

" Cycle through hunks in current buffer
function! GitGutterNextHunkCycle()
    let line = line('.')
    silent! GitGutterNextHunk
    if line('.') == line
        1
        GitGutterNextHunk
    endif
endfunction

function! GitGutterPrevHunkCycle()
    let line = line('.')
    silent! GitGutterPrevHunk
    if line('.') == line
        normal! G
        GitGutterPrevHunk
    endif
endfunction

" vim-easymotion
"---------------------------------------------------------
" Disable default mappings
let g:EasyMotion_do_mapping = 0
" Turn on case-insensitive feature
let g:EasyMotion_smartcase = 1

" <leader>f{char} to move to {char}
" map <leader>f <Plug>(easymotion-bd-f)
" nmap <leader>f <Plug>(easymotion-overwin-f)

" vim-sneak behaviour through easymotion
map s <Plug>(easymotion-f2)
nmap s <Plug>(easymotion-overwin-f2)
" map <leader>s <Plug>(easymotion-f2)
" nmap <leader>s <Plug>(easymotion-overwin-f2)

" JK motions: Line motions
map <leader>h <Plug>(easymotion-linebackward)
map <leader>j <Plug>(easymotion-j)
map <leader>k <Plug>(easymotion-k)
map <leader>l <Plug>(easymotion-lineforward)

" vim-surround
"---------------------------------------------------------
" None

" vim-paste-easy
"---------------------------------------------------------
let g:paste_easy_enable = 1

" vim-commentary
"---------------------------------------------------------
" C and C++ use "//" to comment, rather than "/**/"
autocmd FileType c,cpp set commentstring=//\ %s

" vim-easy-align
"---------------------------------------------------------
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" vim-translator
"---------------------------------------------------------
let g:translator_target_lang='zh'
" Available: 'bing', 'google', 'haici', 'sdcv', 'trans', 'youdao'
let g:translator_default_engines=['bing', 'google', 'haici', 'youdao']
" Available: 'popup'(use floatwin in nvim or popup in vim), 'preview'
let g:translator_window_type='popup'

" Display translation in a window
nmap <silent> <leader>ts <Plug>TranslateW
vmap <silent> <leader>ts <Plug>TranslateWV
" Replace the text with translation
vmap <silent> <leader>tr <Plug>TranslateRV
nmap <silent> <leader>tr <Plug>TranslateR
" Translate the text in clipboard
nmap <silent> <leader>tx <Plug>TranslateX

" vim-visual-multi
"---------------------------------------------------------
let g:vm_mouse_mappings = 1
let g:VM_theme = 'iceblue'
let g:VM_highlight_matches = 'underline'
let g:VM_maps = {}
let g:VM_maps['Undo'] = 'u'
let g:VM_maps['Redo'] = '<C-r>'

" vmi-repeat
"---------------------------------------------------------
" None

" vim-markdown
"---------------------------------------------------------
" Disable the folding configuration
let g:vim_markdown_folding_disabled = 1
" Disable conceal regardless of conceallevel setting
let g:vim_markdown_conceal = 0
" Disable math conceal with LaTeX math syntax enabled
let g:tex_conceal = ""
let g:vim_markdown_math = 1

" markdown-preview.nvim
"---------------------------------------------------------
" specify browser to open preview page
let g:mkdp_browser = ''
" use a custom location for images
let g:mkdp_images_path = '$HOME/.markdown_images'
" set default theme (dark or light)
let g:mkdp_theme = 'dark'
nnoremap <leader>cp <Plug>MarkdownPreviewToggle

" vim-markdown-toc
"---------------------------------------------------------
" None

" vim-table-mode
"---------------------------------------------------------
let b:table_mode_corner = '|'

" coc.nvim
"---------------------------------------------------------
" coc extensions
let g:coc_global_extensions = [
    \ 'coc-marketplace',
    \ 'coc-highlight',
    \ 'coc-yank',
    \ 'coc-diagnostic',
    \ 'coc-gitignore',
    \ 'coc-snippets',
    \ 'coc-json',
    \ 'coc-yaml',
    \ 'coc-lua',
    \ 'coc-vimlsp',
    \ 'coc-markdownlint',
    \ 'coc-markdown-preview-enhanced',
    \ 'coc-ci',
    \ 'coc-sh',
    \ 'coc-clangd',
    \ 'coc-cmake',
    \ 'coc-python',
    \ 'coc-pyright',
    \ 'coc-docker',
    \ ]

" coc-extention: explorer
"---------------------------------------------------------
" TODO: not work in windows, use NERDTree to instead
" nnoremap <leader>e :CocCommand explorer<CR>

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
inoremap <silent><expr> <C-j>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><C-k> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-o> to trigger completion
inoremap <silent><expr> <c-o> coc#refresh()

" Use `[d` and `]d` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
nmap <silent> [d <Plug>(coc-diagnostic-prev)
nmap <silent> ]d <Plug>(coc-diagnostic-next)

" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gI <Plug>(coc-implementation)
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
nmap <leader>cr <Plug>(coc-rename)

" Formatting selected code
xmap <leader>cf  <Plug>(coc-format-selected)
nmap <leader>cf  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s)
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying code actions to the selected code block
" Example: `<leader>aap` for current paragraph
xmap <leader>ca  <Plug>(coc-codeaction-selected)
" nmap <leader>ca  <Plug>(coc-codeaction-selected)

" Remap keys for applying code actions at the cursor position
nmap <leader>ca  <Plug>(coc-codeaction-cursor)
" Remap keys for apply code actions affect whole buffer
nmap <leader>cA  <Plug>(coc-codeaction-source)
" Apply the most preferred quickfix action to fix diagnostic on the current line
nmap <leader>cqf  <Plug>(coc-fix-current)

" Remap keys for applying refactor code actions
nmap <silent> <leader>cre <Plug>(coc-codeaction-refactor)
xmap <silent> <leader>cre  <Plug>(coc-codeaction-refactor-selected)
nmap <silent> <leader>cre  <Plug>(coc-codeaction-refactor-selected)

" Run the Code Lens action on the current line
nmap <leader>cl  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> to scroll float windows/popups
if has('nvim0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<CR>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<CR>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges
" Requires 'textDocument/selectionRange' support of language server
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

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

" Mappings for CoCList
" Show all diagnostics
nnoremap <silent><nowait> <leader>cd  :<C-u>CocList diagnostics<CR>
" Manage extensions
nnoremap <silent><nowait> <leader>ce  :<C-u>CocList extensions<CR>
" " Show commands
nnoremap <silent><nowait> <Space>cc   :<C-u>CocList commands<CR>
" Find symbol of current document
nnoremap <silent><nowait> <leader>co  :<C-u>CocList outline<CR>
" Search workspace symbols
nnoremap <silent><nowait> <leader>cs  :<C-u>CocList -I symbols<CR>
" " Do default action for next item
" nnoremap <silent><nowait> <Space>j  :<C-u>CocNext<CR>
" " Do default action for previous item
" nnoremap <silent><nowait> <Space>k  :<C-u>CocPrev<CR>
" " Resume latest coc list
" nnoremap <silent><nowait> <Space>p  :<C-u>CocListResume<CR>

" which key
"---------------------------------------------------------
" Use leader key to trigger which key
nnoremap <silent> <leader> :<C-u>WhichKey '<Space>'<CR>
vnoremap <silent> <leader> :<C-u>WhichKeyVisual '<Space>'<CR>

" Register the description dictionary for the prefix to pop up the guide menu
call which_key#register('<Space>', 'g:which_key_map', 'n')
call which_key#register('<Space>', 'g:which_key_map_visual', 'v')

" Define prefix dictionary
let g:which_key_map =  {}
let g:which_key_map_visual =  {}

" =======================================================
" Create menus not based on existing mappings:
" =======================================================
let g:which_key_map = {
    \ '-': 'Split window below',
    \ '|': 'Split window right',
    \ ',': 'Search buffers',
    \ '/': 'Search grep text',
    \ ':': 'Search command history',
    \ 'r': 'Reload $MYVIMRC',
    \ 'q': 'Quit',
    \ 'w': 'Save file',
    \ 'W': 'Write file by sudo',
    \ 'e': 'Toggle explorer',
    \ 'y': 'Copy',
    \ 'd': 'Cut',
    \ 'p': 'Paste',
    \ 'P': 'Paste prev line',
    \ }
let g:which_key_map.b = {
    \ 'name': '+buffer',
    \ 'b': 'Switch to other buffer',
    \ 'd': 'Close buffer',
    \ 'n': 'New buffer',
    \ }
let g:which_key_map.c = {
    \ 'name': '+code',
    \ 'a': 'Coc: Code action',
    \ 'A': 'Coc: Source action',
    \ 'c': 'Coc: Commands',
    \ 'd': 'Coc: Diagnostics',
    \ 'e': 'Coc: Extensions',
    \ 'f': 'Coc: Format',
    \ 'l': 'Coc: Codelines action',
    \ 'o': 'Coc: Symbol outline',
    \ 'p': 'Toggle markdown preview',
    \ 'r': 'Coc: Rename',
    \ 's': 'Coc: Symbol outline workspace',
    \ }
let g:which_key_map.f = {
    \ 'name': '+file/find',
    \ 'b': 'Buffers',
    \ 'f': 'Files',
    \ 'g': 'Git files',
    \ 'h': 'Help tags',
    \ 'r': 'Recent files',
    \ }
let g:which_key_map.g = {
    \ 'name': '+git',
    \ 'c': 'Commits',
    \ 'j': 'Next hunk',
    \ 'k': 'Prev hunk',
    \ 's': 'Stage hunk',
    \ 'u': 'Undo stage hunk',
    \ 'p': 'Preview hunk',
    \ 'd': 'Diff this',
    \ }
let g:which_key_map.s = {
    \ 'name': '+search',
    \ 'b': 'Buffers',
    \ 'c': 'Command history',
    \ 'C': 'Commands',
    \ 'f': 'Files',
    \ 'g': 'Grep text',
    \ 'h': 'Help tags',
    \ 'k': 'Key maps',
    \ 'm': 'Marks',
    \ 'r': 'Recent files',
    \ 's': 'Symbol(buffer)',
    \ 'S': 'Symbol(workspace)',
    \ }
let g:which_key_map.t = {
    \ 'name': '+translate',
    \ 'm': 'Toggle table mode',
    \ 'r': 'Replace the text with translator',
    \ 's': 'Translate in a window',
    \ 't': 'Table mode tableize',
    \ 'x': 'Translate the text in clipboard',
    \ }
let g:which_key_map.u = {
    \ 'name': '+UI',
    \ 'c': 'Preview colorscheme',
    \ 'l': 'Toggle line number',
    \ 'L': 'Toggle relative line number',
    \ 's': 'Toggle spell',
    \ 'u': 'Toggle undotree',
    \ 'w': 'Toggle word wrap',
    \ }
" let g:which_key_map.w = {
"     \ 'name': '+window',
"     \ '-': 'Split window below',
"     \ '|': 'Split window right',
"     \ 'd': 'Switch to other window',
"     \ 'w': 'Delete window',
"     \ }
let g:which_key_map.x = {
    \ 'name': '+diagnostics/quickfix',
    \ 'q': 'Quickfix',
    \ 'l': 'Locationlist',
    \ }

" codeium
"---------------------------------------------------------
" Default Binding
" <Tab> codeium#Clear()
" <M-[> codeium#CycleCompletions(-1)
" <M-]> codeium#CycleCompletions(1)
" <C-]> codeium#Accept()
" <M-Bslash> codeium#Complete()
" imap <script><silent><nowait><expr> <C-l> codeium#Accept()

" copilot
"---------------------------------------------------------


" im-select
"---------------------------------------------------------
" " The default value on Windows
" let g:im_select_default = '1033'
" " Set to the im-select program path
" let g:im_select_command = 'im-select'

"---------------------
" Local customizations
"---------------------

let $LOCALFILE=expand("~/.vimrc_local")
if filereadable($LOCALFILE)
    source $LOCALFILE
endif
